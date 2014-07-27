<!--- //

	Component:	Calendar
	Function:	ShowDisplayOtherUsersCalendar
	Description:Display the list of available users in order to include their calendar
				in the output
	
	Header:	

// --->

<cfparam name="url.workgroupkey" type="string" default="">

<cfset a_str_included_user_calendars = GetUserPrefPerson('calendar', 'display.includeusercalendars', '', '', false) />

<cfinvoke component="/components/management/workgroups/cmp_secretary" method="GetAllAttendedUsers" returnvariable="q_select_attended_users">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_resources#" method="GetAvailableResources" returnvariable="q_select_resources">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
</cfinvoke>
	
<cfset a_str_text = GetLangval('cal_ph_select_user_calendars_current_count') />
<cfset a_str_text = ReplaceNoCase(a_Str_text , '%RECORDCOUNT%', ListLen(a_str_included_user_calendars)) />

<cfif ListLen(a_str_included_user_calendars) GT 0>
	<b><cfoutput>#a_str_text#</cfoutput></b>
	
	<table class="table table-hover">
			
	<cfloop list="#a_str_included_user_calendars#" delimiters="," index="a_str_userkey">
		<cfoutput>
		<tr>
			<td>
			<cfif Len(application.components.cmp_user.GetUsernamebyentrykey(a_str_userkey)) GT 0>
				#application.components.cmp_user.GetUsernamebyentrykey(a_str_userkey)#<br />
			</cfif>
			</td>
			<td>
				<input type="button" class="btn" value="#GetLangVal('cm_wd_close_btn_caption')#" onclick="GotoLocHref('act_remove_usercalendar.cfm?userkey=#urlencodedformat(a_str_userkey)#');" />
			</td>
		</tr>
		</cfoutput>
	</cfloop>
	</table>
</cfif>

<cfset StartNewTabNavigation() />
<cfset a_str_id_workgroups = AddTabNavigationItem(GetLangValJS('cm_wd_workgroups'), '', '') />
<cfset a_str_id_secretary = AddTabNavigationItem(GetLangValJS('adm_ph_secretary_entries'), '', '') />
<cfset a_str_id_resources = AddTabNavigationItem(GetLangValJS('cm_wd_resources'), '', '') />

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<div id="<cfoutput>#a_str_id_workgroups#</cfoutput>" class="div_module_tabs_content_box">
<table class="table table_details">
	<tr>	
		<td>

		<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">
						
			<cfloop from="1" to="#request.stSecurityContext.q_select_workgroup_permissions.workgrouplevel#" index="ii">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>
			
			<cfif ListFind(request.stSecurityContext.q_select_workgroup_permissions.permissions, 'managepermissions') GT 0>
				<a href="##" onclick="ShowDialogIncludeUserCalendar('#jsstringformat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key)#');return false;"><img src="/images/si/group.png" alt="" class="si_img" /> #htmleditformat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_name)#</a>
				<br />
			</cfif>
			
		</cfoutput>

		</td>
		<td>
		<!--- display workgroup members ... --->
		<cfif Len(url.workgroupkey) GT 0>
		
			<!--- todo hp: translate ... --->
			Diese Gruppe hat folgende Mitglieder:
			<br /><br />  
			<cfquery name="q_select_workgroup_name" dbtype="query">
			SELECT
				workgroup_name
			FROM
				request.stSecurityContext.q_select_workgroup_permissions
			WHERE
				workgroup_key = '#url.workgroupkey#'
			;
			</cfquery>
			
			<cfinvoke component="#application.components.cmp_workgroups#" method="GetWorkgroupMembers" returnvariable=q_select_users>
				<cfinvokeargument name="workgroupkey" value=#url.workgroupkey#>
			</cfinvoke>				
			
			<!--- <cfif q_select_users.recordcount GT 0>
				<a href="act_add_user_calendar.cfm?userkeys=<cfoutput>#urlencodedformat(ValueList(q_select_users.userkey))#</cfoutput>"><img src="/images/new_event.gif" width="12" height="12" vspace="3" hspace="3" border="0" align="absmiddle"> alle</a><br>
			<cfelse>
				No users found/Keine Benutzer gefunden
			</cfif>
			 --->
			<!--- load members ... --->				
			<cfloop query="q_select_users">
			
			
			<cfif CompareNoCase(q_select_users.userkey, request.stSecurityContext.myuserkey) NEQ 0>
			
			
				<cfoutput>
				<a href="index.cfm?action=DoAddUserCalendarDisplay&userkeys=#urlencodedformat(q_select_users.userkey)#"><img src="/images/si/user.png" alt="" class="si_img" /> #htmleditformat(q_select_users.fullname)#</a><br />
				</cfoutput>
				
			</cfif>
			
			</cfloop>

			
		</cfif>
		</td>

	</tr>
</table>
</div>

<div class="div_module_tabs_content_box" id="<cfoutput>#a_str_id_secretary#</cfoutput>">
<cfoutput query="q_select_attended_users">
	<a href="act_add_user_calendar.cfm?userkeys=#urlencodedformat(q_select_attended_users.userkey)#">#si_img('user')# #application.components.cmp_user.GetUsernamebyentrykey(q_select_attended_users.userkey)#</a><br />
</cfoutput>
</div>

<div class="div_module_tabs_content_box" id="<cfoutput>#a_str_id_resources#</cfoutput>">
<cfoutput query="q_select_resources">
	<a style="font-weight:bold; " href="index.cfm?action=DoAddUserCalendarDisplay&userkeys=&resourcekey=#q_select_resources.entrykey#">#htmleditformat(q_select_resources.title)#</a>
	<br /> 
	#q_select_resources.description#
	<br /><br />  
</cfoutput>
</div>


