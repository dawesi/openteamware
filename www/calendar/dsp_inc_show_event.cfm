<!--- //

	display an event ...

	the structure holds the whole data
	
		
	// --->
	
<cfparam name="ShowEventRequest.a_struct_event" type="struct">
<cfparam name="ShowEventRequest.ShowFullDate" type="boolean" default="true">
<cfparam name="ShowEventRequest.ShowNoDate" type="boolean" default="false">
<cfparam name="ShowEventRequest.Printmode" type="boolean" default="false">
<!--- day / week / month 	--->
<cfparam name="ShowEventRequest.ViewMode" type="string" default="day">

<!--- check if arrays with workgroupkeys --->
<cfif StructKeyExists(variables, 'a_str_list_private_entries') IS FALSE>
	<cfset a_str_list_private_entries = ''>
</cfif>

<cfoutput>
<div style="padding:3px;<cfif ShowEventRequest.a_struct_event.color NEQ ''>border:#ShowEventRequest.a_struct_event.color# solid 3px;</cfif>">

<cfif ShowEventRequest.printmode>
	<cfset a_int_title_shortenstring = 999 />
<cfelse>
	<cfset a_int_title_shortenstring = 30 />
</cfif>

<!--- see also below ... --->
<cfif ListFindNoCase('week', ShowEventRequest.ViewMode) IS 0>
<a title="#htmleditformat(ShowEventRequest.a_struct_event.title)#" href="default.cfm?action=ShowEvent&entrykey=#urlencodedformat(ShowEventRequest.a_struct_event.entrykey)#" style="font-weight:bold;">#htmleditformat(shortenstring(ShowEventRequest.a_struct_event.title, a_int_title_shortenstring))#</a>
</cfif>

<cfif ShowEventRequest.ShowNoDate IS FALSE>

	<font class="addinfotext">
	<cfif DateDiff('d', ShowEventRequest.a_struct_event.date_start, ShowEventRequest.a_struct_event.date_end) LTE 1>
	
		<cfif Minute(ShowEventRequest.a_struct_event.date_start) is 0>
			<cfset a_str_start_time_format = 'HH'>
		<cfelse>
			<cfset a_str_start_time_format = 'HH:mm'>	
		</cfif>
		
		<cfif Minute(ShowEventRequest.a_struct_event.date_end) is 0>
			<cfset a_str_end_time_format = 'HH'>
		<cfelse>
			<cfset a_str_end_time_format = 'HH:mm'>	
		</cfif>
			
		(#TimeFormat(ShowEventRequest.a_struct_event.date_start, a_str_start_time_format)# - #TimeFormat(ShowEventRequest.a_struct_event.date_end, a_str_end_time_format)#)
	<cfelse>
		(#LSDateFormat(ShowEventRequest.a_struct_event.date_start, 'ddd, dd.mm')# #TimeFormat(ShowEventRequest.a_struct_event.date_start, 'HH:mm')# - #LSDateFormat(ShowEventRequest.a_struct_event.date_end, 'ddd, dd.mm.yy')# #TimeFormat(ShowEventRequest.a_struct_event.date_end, 'HH:mm')#)
	</cfif>
	</font>

</cfif>

<!--- see also above --->
<cfif ListFindNoCase('week', ShowEventRequest.ViewMode) GT 0>
<br /><a title="#htmleditformat(ShowEventRequest.a_struct_event.title)#" href="default.cfm?action=ShowEvent&entrykey=#urlencodedformat(ShowEventRequest.a_struct_event.entrykey)#" style="font-weight:bold;">#htmleditformat(shortenstring(ShowEventRequest.a_struct_event.title, a_int_title_shortenstring))#</a>
</cfif>

<cfif ShowEventRequest.a_struct_event.privateevent IS 1>
	[#GetLangVal('cal_wd_private')#]
</cfif>

<cfset a_str_simple_entrykey = ReplaceNoCase(ShowEventRequest.a_struct_event.entrykey, '-', '', 'ALL')>

<!--- <cfif ListFindNoCase('week', ShowEventRequest.ViewMode) IS 0>
	
	<cfset a_str_tmp_id = 'popm_' & CreateUUIDJS()>
	<cfset a_str_tmp_link_id = 'id_link_popm_' & CreateUUIDJS()>

	<script type="text/javascript">
	#a_str_tmp_id# = new cActionPopupMenuItems();
	#a_str_tmp_id#.AddItem('#GetLangValJS('cal_wd_action_edit')#','default.cfm?action=ShowEditEvent&entrykey=#urlencodedformat(ShowEventRequest.a_struct_event.entrykey)#','','','');
	#a_str_tmp_id#.AddItem('#GetLangVal('cal_wd_action_delete')#', 'javascript:ConfirmDeleteEntry(\'#ShowEventRequest.a_struct_event.entrykey#\');');
	</script>
	
	<a href="##" id="#a_str_tmp_link_id#" onClick="ShowHTMLActionPopup('#a_str_tmp_link_id#', #a_str_tmp_id#);return false;">#GetLangVal('cm_wd_actions')#</a>
	
	
</cfif> --->

</cfoutput>

<!---<cfdump var="#ShowEventRequest.a_struct_event#">--->

<!---
<cfif compare(ShowEventRequest.a_struct_event.type, 4) is 0>BIRTHDAY</cfif>
--->

<!--- add type ... ---><!--- 
<cfset a_bol_color_span = ShowEventRequest.printmode is false AND ShowEventRequest.a_struct_event.type gt 0>

<cfif a_bol_color_span>
	<cfoutput><span style="background-color:#GetEventTypeBGColor(ShowEventRequest.a_struct_event.type)#">TYPE</span></cfoutput>
</cfif>
 --->


<cfif (len(ShowEventRequest.a_struct_event.AssociatedURL) gt 0) and (ShowEventRequest.printmode is false)>
	<!--- display hyperlink ... --->
</cfif>


<!--- show participating people ... --->


<cfif val(ShowEventRequest.a_struct_event.repeat_type) gt 0>
<!--- repeating? --->
	<img src="/images/si/arrow_rotate_clockwise.png" class="si_img" />
	<cfswitch expression="#ShowEventRequest.a_struct_event.repeat_type#">
		<cfcase value="1">
		<cfoutput>#GetLangVal("cal_wd_recur_daily")#</cfoutput>		
		</cfcase>
		<cfcase value="2">
		<cfoutput>#GetLangVal("cal_wd_recur_weekly")#</cfoutput>
		</cfcase>
		<cfcase value="3">
		<cfoutput>#GetLangVal("cal_wd_recur_monthly")#</cfoutput>
		</cfcase>
		<cfcase value="4">
		<cfoutput>#GetLangVal("cal_wd_recur_yearly")#</cfoutput>		
		</cfcase>
	</cfswitch>
</cfif>

<cfif len(ShowEventRequest.a_struct_event.description) GT 0>
	<br /> 
	<cfoutput>#shortenstring(ShowEventRequest.a_struct_event.description, 50)#</cfoutput>
</cfif>

<cfif Len(ShowEventRequest.a_struct_event.categories) GT 0>
	<br /> 
	<cfoutput>#GetLangVal('cm_wd_categories')#: #shortenstring(ShowEventRequest.a_struct_event.categories, 50)#</cfoutput>
</cfif>

<cfif Len(ShowEventRequest.a_struct_event.workgroupkeys) GT 0>
	<<br /> 
	<!--- display groups ... --->
	<cfset a_int_group_count = ListLen(ShowEventRequest.a_struct_event.workgroupkeys, ',')>
	
	 <!---<cfoutput>#a_int_group_count#</cfoutput> Gruppe(n):--->
	
	<cfset a_int_current_group_count = 0>
	
	<cfloop list="#ShowEventRequest.a_struct_event.workgroupkeys#" delimiters="," index="a_str_workgroupkey">
		<cfset a_int_current_group_count = a_int_current_group_count + 1>
		<cfif StructKeyExists(request.stSecurityContext.a_struct_workgroups, a_str_workgroupkey) IS TRUE>
			<img src="/images/calendar/16kalender_gruppen.gif" width="12" height="11" align="absmiddle" vspace="2" hspace="5" border="0">  <a href="../workgroups/default.cfm?action=ShowWorkgroup&entrykey=<cfoutput>#urlencodedformat(a_str_workgroupkey)#</cfoutput>"><cfoutput>#request.stSecurityContext.a_struct_workgroups[a_str_workgroupkey]#</cfoutput></a>
			 
			 <cfif a_int_current_group_count LT a_int_group_count>/</cfif>
		</cfif>
		
	</cfloop>

	<cfif  ShowEventRequest.a_struct_event.meetingmemberscount IS 0><br /></cfif>
</cfif>


<cfif ShowEventRequest.a_struct_event.meetingmemberscount GT 0>

	<br /> 
	<img src="/images/si/group.png" class="si_img" /> <cfoutput>#ShowEventRequest.a_struct_event.meetingmemberscount# #GetLangVal('cal_wd_participants')#</cfoutput>:
	
	<!--- load participating people ... --->
	<cfinvoke component="#application.components.cmp_calendar#" method="GetMeetingMembers" returnvariable="q_select_meeting_members">
		<cfinvokeargument name="entrykey" value="#ShowEventRequest.a_struct_event.entrykey#">
	</cfinvoke>	
    
	<!--- select the assigned contacts ... type = 1 --->
	<cfquery name="q_select_participating_assigned_contacts" dbtype="query">
	SELECT
		parameter
	FROM
		q_select_meeting_members
	WHERE
		type = 1
	;
	</cfquery>	
	
	<cfif q_select_participating_assigned_contacts.recordcount GT 0>
		<cfset a_struct_filter_load_contacts = StructNew()>
		<cfset a_struct_filter_load_contacts.entrykeys = ValueList(q_select_participating_assigned_contacts.parameter)>
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="filter" value="#a_struct_filter_load_contacts#">
		</cfinvoke>
		<cfset q_select_contacts = stReturn_contacts.q_select_contacts>
	</cfif>
	
	
	
	<!--- select the assigned resources ... type = 4 --->
	<cfquery name="q_select_participating_assigned_resources" dbtype="query">
	SELECT
		parameter
	FROM
		q_select_meeting_members
	WHERE
		type = 4
	;
	</cfquery>
	
	<cfif q_select_participating_assigned_resources.recordcount GT 0>
		<cfinvoke component="#application.components.cmp_resources#" method="GetResourcesByEntrykeys" returnvariable="q_select_resources">
			<cfinvokeargument name="entrykeys" value="#ValueList(q_select_participating_assigned_resources.parameter)#">
		</cfinvoke>
	</cfif>
    
    <cfset a_bool_first = true />
	
	<cfoutput query="q_select_meeting_members">
		<cfif q_select_meeting_members.type NEQ 4 AND q_select_meeting_members.sendinvitation EQ 1>
			<cfswitch expression="#q_select_meeting_members.status#">
				<cfcase value="0">
					<!--- no response yet ... --->
					<img src="/images/si/help.png" class="si_img" />
				</cfcase>
				<cfcase value="-1">
					<!-- maybe --->
					<img src="/images/si/cross.png" class="si_img" />
				</cfcase>
				<cfcase value="1">
					<!--- yes --->
					<img src="/images/si/accept.png" class="si_img" />
				</cfcase>
				<cfcase value="2">
					<img src="/images/si/pill_add.png" class="si_img" />
				</cfcase>
			</cfswitch>
        <cfelse>
            <cfif NOT(a_bool_first)>
            ;
            </cfif>
		</cfif>
        <cfset a_bool_first = false>
		
		<cfswitch expression="#q_select_meeting_members.type#">
			<cfcase value="0">
			<!--- workgroup members ... --->
			
				<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
					<cfinvokeargument name="userkey" value="#q_select_meeting_members.parameter#">
				</cfinvoke>

				#htmleditformat(q_select_user_data.surname)#, #htmleditformat(q_select_user_data.firstname)#
					
			</cfcase>
			<cfcase value="1">
			<!--- address book --->

				<cfquery name="q_select_contact_name" dbtype="query">
				SELECT
					firstname,surname
				FROM
					q_select_contacts
				WHERE
					entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_meeting_members.parameter#">
				;
				</cfquery>
				<a href="/addressbook/?action=ShowItem&Entrykey=#q_select_meeting_members.parameter#">#htmleditformat(q_select_contact_name.surname) & ', ' & htmleditformat(q_select_contact_name.firstname)#</a>
                      
			</cfcase>
			<cfcase value="2">
			<!--- simple e-mail address --->

				#htmleditformat(q_select_meeting_members.parameter)#

			</cfcase>
			<!--- <cfcase value="3">
				<!--- address book item ... --->
				
				<cfif StructKeyExists(variables, 'a_struct_contacts_cached_info')
					AND
					StructKeyExists(variables.a_struct_contacts_cached_info, q_select_meeting_members.parameter)>
					<cfset stReturn_contact.q_select_contact = variables.a_struct_contacts_cached_info[q_select_meeting_members.parameter]>
				<cfelse>
					<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn_contact">
						<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
						<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
						<cfinvokeargument name="entrykey" value="#q_select_meeting_members.parameter#">
					</cfinvoke>
				</cfif>
				


				<cfif StructKeyExists(stReturn_contact, 'q_select_contact')>
					<cfmodule template="crm/mod_dsp_inc_show_contact_info.cfm" query=#stReturn_contact.q_select_contact# viewmode=#a_str_cal_viewmode_web#>
				</cfif>
			</cfcase> --->
			<cfcase value="4">
				<cfquery name="q_select_resource_title" dbtype="query">
				SELECT
					title
				FROM
					q_select_resources
				WHERE
					entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_meeting_members.parameter#">
				;
				</cfquery>
				<img src="/images/si/wrench.png" class="si_img" /> #htmleditformat(q_select_resource_title.title)#
			</cfcase>
		</cfswitch>
		
		<cfif Len(q_select_meeting_members.comment) GT 0>
			<img alt="#htmleditformat(q_select_meeting_members.comment)#" src="/images/si/page_edit.png" class="si_img" />
		</cfif>
	
	</cfoutput>

</cfif>

</div>