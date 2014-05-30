
<!--- //

	show an event
	
	// --->
	
<cfparam name="url.entrykey" type="string" default="">

<cfparam name="url.returnurl" type="string" default="#ReturnRedirectURL()#">

<!---
	the date ... this is only important if we have an repeating event
	and we want the events near a single occurance --->
<cfparam name="url.date" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- load event now ... --->
<cfinvoke component="#application.components.cmp_calendar#" method="GetEvent" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>


<cfif NOT stReturn.result>

	<h4><cfoutput>#GetLangVal('cal_ph_error_no_permissions_or_not_found')#</cfoutput></h4>
	<br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_event = stReturn.q_select_event>
<cfset q_select_meeting_members = stReturn.q_select_meeting_members>
<cfset a_struct_rights = stReturn.rights>

<cfif (q_select_event.recordcount is 0)>
	<h4>no data found</h4>
	<cfexit method="exittemplate">
</cfif>

<cfset tmp = SetHeaderTopInfoString(q_select_event.title) />

<cfsavecontent variable="a_str_buttons">

<cfif a_struct_rights.edit>
	<input type="button" onClick="location.href='index.cfm?action=ShowEditEvent&entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>';" value="<cfoutput>#GetLangVal('cal_wd_edit')#</cfoutput>" class="btn btn-primary">
</cfif>
<cfif a_struct_rights.delete>
	<input type="button" onClick="DeleteThisEvent('<cfoutput>#JsStringFormat(url.entrykey)#</cfoutput>');" class="btn btn-primary" value="<cfoutput>#GetLangVal('cal_wd_action_delete')#</cfoutput>">
</cfif>
</cfsavecontent>

<cfsavecontent variable="a_str_content">

<table cellspacing="0" class="table_details">
	<tr class="mischeader">
		<td colspan="2">
			<cfoutput>#GetLangVal('cm_wd_summary')#</cfoutput>
		</td>
	</tr>
	<cfoutput query="q_select_event">
		<cfif Compare(q_select_event.userkey, request.stSecurityContext.myuserkey) NEQ 0>
		
			<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
				<cfinvokeargument name="entrykey" value="#q_select_event.userkey#">
			</cfinvoke>	
			
			<cfif StructKeyExists(a_struct_load_userdata, 'query')>
			<tr>
				<td colspan="2">
					#si_img('user')# <a href="/workgroups/?action=showuser&entrykey=#urlencodedformat(a_struct_load_userdata.query.entrykey)#"> #GetLangVal('cal_ph_is_event_of')# <b>#a_struct_load_userdata.query.firstname# #a_struct_load_userdata.query.surname#</b> (#a_struct_load_userdata.query.username#)</a>
				</td>
			</tr>
			</cfif> 		
		</cfif>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_title')#
		</td>
		<td style="font-weight:bold;">
			#htmleditformat(q_select_event.title)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_description')#
		</td>
		<td>
			<cfloop list="#q_select_event.description#" delimiters="#chr(10)#" index="a_str_line">
				#htmleditformat(trim(a_str_line))#<br>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_location')#
		</td>
		<td>
			#htmleditformat(q_select_event.location)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cal_wd_start')#
		</td>
		<td>
			<a href="index.cfm?action=ViewDay&date=#urlencodedformat(dateformat(q_select_event.date_start, 'mm/dd/yyyy'))#">#LSDateFormat(q_select_event.date_start, request.a_str_default_long_dt_format)# #TimeFormat(q_select_event.date_start, 'HH:mm')#</a>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cal_wd_end')#
		</td>
		<td>
			<a href="index.cfm?action=ViewDay&date=#urlencodedformat(dateformat(q_select_event.date_end, 'mm/dd/yyyy'))#">#LSDateFormat(q_select_event.date_end, request.a_str_default_long_dt_format)# #TimeFormat(q_select_event.date_end, 'HH:mm')#</a>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cal_wd_duration')#
		</td>
		<td>
			<cfif DateDiff('d', q_select_event.date_start, q_select_event.date_end) gt 1>
				#DateDiff('d', q_select_event.date_start, q_select_event.date_end)# #GetLangVal('cm_wd_days')#,
			</cfif>
	
			<cfset a_dt_date_diff = q_select_event.date_end - q_select_event.date_start>
	
			#timeformat(a_dt_date_diff, "H")# #GetLangVal('cm_wd_hours')# #GetLangVal('cm_wd_and')# #Timeformat(a_dt_date_diff, "m")# #GetLangVal('cal_wd_minutes')#
		</td>
	</tr>
	<cfif Len(q_select_event.categories) GT 0>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_categories')#
		</td>
		<td>
			#htmleditformat(q_select_event.categories)#
		</td>
	</tr>
	</cfif>
	<tr>
		<td class="field_name">
			#GetLangVal('cal_wd_showas')#
		</td>
		<td>
            #GetLangVal('cal_wd_showas_' & q_select_event.showtimeas)#
		</td>
	<tr>
		<td class="field_name">
			#GetLangVal('cal_wd_private')#
		</td>
		<td>
			<cfif q_select_event.privateevent is 1>#GetLangVal('cm_wd_yes')#<cfelse>#GetLangVal('cm_wd_no')#</cfif>
		</td>
	</tr>				
	<tr class="mischeader">
		<td colspan="2">
			#GetLangVal('cal_wd_participants')# (#q_select_meeting_members.recordcount#)
		</td>
	</tr>	
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


	    <!--- select participating resources --->
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
    
		<cfloop query="q_select_meeting_members">
		<tr>
			<td class="field_name">
				<cfif q_select_meeting_members.type NEQ 3>
					<cfswitch expression="#q_select_meeting_members.status#">
						<cfcase value="0">
						<i>#GetLangVal('cal_wd_status_open')#</i>
						</cfcase>
						<cfcase value="-1">
						<font color="red">#GetLangVal('cal_wd_status_declined')#</font>
						</cfcase>
						<cfcase value="1">
						<font color="green">#GetLangVal('cal_wd_status_ok')#</font>
						</cfcase>
						<cfcase value="2">
						<font color="gray">#GetLangVal('cal_wd_status_maybe')#</font>
						</cfcase>
					</cfswitch>
				</cfif>
			</td>
			<td>
				<cfswitch expression="#q_select_meeting_members.type#">
					<cfcase value="0">
						<!--- workgroup members ... --->
						
						<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
							<cfinvokeargument name="entrykey" value="#q_select_meeting_members.parameter#">
						</cfinvoke>
						
						<cfif q_select_user_data.smallphotoavaliable IS 1>
							<img width="70" src="../tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_meeting_members.parameter)#" border="0" align="absmiddle" />
						<cfelse>
							<img src="/images/si/user.png" class="si_img" />
						</cfif>
							
						<a href="../workgroups/index.cfm?action=ShowUser&entrykey=#urlencodedformat(q_select_meeting_members.parameter)#">#htmleditformat(q_select_user_data.surname)#, #htmleditformat(q_select_user_data.firstname)# (#htmleditformat(q_select_user_data.username)#)</a>

					</cfcase>
					<cfcase value="1">
						<!--- address book --->
						<cfquery name="q_select_contact_name" dbtype="query">
						SELECT
							firstname,surname,entrykey
						FROM
							q_select_contacts
						WHERE
							entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_meeting_members.parameter#">
						;
						</cfquery>
						<a href="/addressbook/?action=ShowItem&Entrykey=#q_select_contact_name.entrykey#"><img src="/images/si/vcard.png" class="si_img" /> #htmleditformat(q_select_contact_name.surname & ', ' & q_select_contact_name.firstname)#</a>
									
					</cfcase>
					<cfcase value="2">
                        <!--- just email address --->
						<img src="/images/si/email.png" class="si_img" /> #htmleditformat(q_select_meeting_members.parameter)#
					</cfcase>
					<!--- <cfcase value="3">
						<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn_contact">
							<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
							<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
							<cfinvokeargument name="entrykey" value="#q_select_meeting_members.parameter#">
						</cfinvoke>
						
						
						<cfif StructKeyExists(stReturn_contact, 'q_select_contact')>
							<cfmodule template="crm/mod_dsp_inc_show_contact_info.cfm" query=#stReturn_contact.q_select_contact# viewmode=#a_str_cal_viewmode_web#>
						</cfif>
					</cfcase> --->
					<cfcase value="4">
                        <!--- resource --->
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
					<br>#ReplaceNoCase(q_select_meeting_members.comment, chr(13), '<br>', 'ALL')#
				</cfif>
			</td>
		</tr>
		</cfloop>
	<cfif q_select_meeting_members.recordcount is 0>
		<tr>
			<td></td>
			<td class="addinfotext">
				#GetLangVal('cal_ph_participants_no_defined')#
			</td>
		</tr>
	</cfif>
	<tr class="mischeader">
		<td colspan="2">
			#GetLangVal('cal_wd_recurrence')#
		</td>
	</tr>
	<cfif q_select_event.repeat_type GT 0>
		<tr>
			<td class="field_name">
				<img src="/images/si/arrow_rotate_clockwise.png" class="si_img" />
			</td>
			<td>
				<cfswitch expression="#q_select_event.repeat_type#">
					<cfcase value="1">
					#GetLangVal("cal_wd_recur_daily")#		
					</cfcase>
					<cfcase value="2">
					#GetLangVal("cal_wd_recur_weekly")#
					</cfcase>
					<cfcase value="3">
					#GetLangVal("cal_wd_recur_monthly")#
					</cfcase>
					<cfcase value="4">
					#GetLangVal("cal_wd_recur_yearly")#		
					</cfcase>
				</cfswitch>
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#GetLangVal('cal_wd_end')#
			</td>
			<td>
				<cfif isDate(q_select_event.repeat_until)>
					#LsDateFormat(q_select_event.repeat_until, request.a_str_default_long_dt_format)#
				<cfelse>
					#GetLangVal('cal_wd_recurrence_no_end')#
				</cfif>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td></td>
			<td class="addinfotext">
				#GetLangVal('cal_ph_no_defined')#
			</td>
		</tr>
	</cfif>
	
	<tr class="mischeader">
		<td colspan="2">#GetLangVal('cal_wd_reminders')#</td>
	</tr>
	
	<cfinvoke component="#application.components.cmp_calendar#" method="GetReminders" returnvariable="q_select_reminders">
		<cfinvokeargument name="eventkey" value="#url.entrykey#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>	
	
	<cfif q_select_reminders.recordcount IS 0>
		<tr>
			<td></td>
			<td class="addinfotext">
				#GetLangVal('cal_ph_no_defined')#
			</td>
		</tr>	
	<cfelse>
		<cfloop query="q_select_reminders">
			<tr>
				<td class="field_name">
					<cfswitch expression="#q_select_reminders.type#">
						<cfcase value="0">#GetLangVal('cm_wd_email')#</cfcase>
						<cfcase value="1">#GetLangVal('cm_wd_sms')#</cfcase>
						<cfcase value="2">#GetLangVal('cm_wd_reminder')#</cfcase>
					</cfswitch>				
				</td>
				<td>
					#TimeFormat(q_select_reminders.dt_remind_local, 'HH:mm')#
					
					<cfif q_select_reminders.type is 0>
						(#GetLangVal('mail_wd_to')# #htmleditformat(q_select_reminders.remind_email_adr)#)
					</cfif>					
				</td>
			</tr>
		</cfloop>
	</cfif>
	
	<tr class="mischeader">
		<td colspan="2">
			#GetLangVal('cm_wd_details')#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_created')#
		</td>
		<td>
			#lsDateFormat(q_select_event.dt_created, request.a_str_default_long_dt_format)# #TimeFormat(q_select_event.dt_created, 'HH:mm')#
		
			<cfif comparenocase(q_select_event.userkey, request.stSecurityContext.myusername) GT 0>
				#GetLangVal('cm_wd_by')# #q_select_event.userkey#
			</cfif>		
		</td>
	</tr>
	<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
		<cfinvokeargument name="entrykey" value="#url.entrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	</cfinvoke>		
	
	<cfif q_select_shares.recordcount GT 0>
	 	<tr>
			<td class="field_name">
				#GetLangVal('cm_ph_workgroup_share')#
			</td>
			<td>
				<cfloop query="q_select_shares">
					<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupNameByEntryKey" returnvariable="a_str_workgroup_name">
						<cfinvokeargument name="entrykey" value="#q_select_shares.workgroupkey#">
					</cfinvoke>
			
					<a href="../workgroups/index.cfm?action=ShowWorkgroup&entrykey=#urlencodedformat(q_select_shares.workgroupkey)#">#htmleditformat(a_str_workgroup_name)#</a><br>
		
				</cfloop>
			</td>
		</tr>
	</cfif>
	
	</cfoutput>
</table>

		
</cfsavecontent>

<cfoutput>#WriteNewContentBox(htmleditformat(q_select_event.title), a_str_buttons, a_str_content)#</cfoutput>