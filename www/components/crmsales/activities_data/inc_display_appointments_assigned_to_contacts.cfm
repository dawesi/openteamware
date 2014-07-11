<!--- //

	Module:		CRMSales
	Function:	DisplayAppointmentsAssignedToContact
	Description:display the appointments where a user is assigned ...


// --->

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.meetingmember_contact_entrykeys = arguments.contactkeys />

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn_calendar">
	<cfinvokeargument name="startdate" value="#arguments.filter.date_start#">
	<cfinvokeargument name="enddate" value="#arguments.filter.date_end#">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="calculaterepeatingevents" value="false">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_meeting_members_information = stReturn_calendar.q_select_meeting_members_eventskeys_by_parameter />
<cfset q_select_events = stReturn_calendar.q_select_events />

<cfset stReturn.recordcount = q_select_events.recordcount />

<!--- exit if no content available --->
<cfif q_select_events.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfif arguments.usersettings.device.type IS 'pda'>
	<cfset a_str_td_break = ' / ' />
	<cfset a_int_shortenstring = 20 />
<cfelse>
	<cfset a_str_td_break = '</td><td>' />
	<cfset a_int_shortenstring = 50 />
</cfif>

<cfsavecontent variable="sReturn">
<table class="table table-hover">
  <tr class="tbl_overview_header">
  	<cfif arguments.usersettings.device.type IS 'pda'>
		<td>
			<cfoutput>#GetLangVal('cm_wd_events')# (#q_select_events.recordcount#)</cfoutput>
			/
			<cfoutput>#GetLangVal('cm_wd_location')#</cfoutput>
			/
			<cfoutput>#GetLangVal('cm_wd_date')#</cfoutput>
			/
			<cfoutput>#GetLangVal('cal_wd_participants')#</cfoutput>
		</td>
	<cfelse>
		<td width="25%">
			<cfoutput>#GetLangVal('cm_wd_events')# (#q_select_events.recordcount#)</cfoutput>
		</td>
		<td width="25%">
			<cfoutput>#GetLangVal('cm_wd_date')# / #GetLangVal('cal_wd_duration')#</cfoutput>
		</td>
		<td width="25%">
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td width="25%">
			<cfif ListLen(arguments.contactkeys) GT 1>
				<cfoutput>#GetLangVal('cm_wd_contact')#</cfoutput> /
			</cfif>
			<cfoutput>#GetLangVal('cm_wd_location')#</cfoutput>
		</td>
	</cfif>

  </tr>
<cfoutput query="q_select_events">
	<tr>
		<td>
			<a name="appointments" id="id_test_123"></a>
			<a href="/calendar/?action=ShowEvent&entrykey=#q_select_events.entrykey#"><img src="/images/si/calendar.png" class="si_img" />#htmleditformat(CheckZeroString(q_select_events.title))#</a>

		#a_str_td_break#

			#FormatDateTimeAccordingToUserSettings(q_select_events.date_start)#

			<cfset a_int_hours = DateDiff('h', q_select_events.date_start, q_select_events.date_end) />
			<cfset a_int_minutes = DateDiff('n', q_select_events.date_start, q_select_events.date_end) />
			(<cfif a_int_hours GT 0>#a_int_hours# #GetLangVal('cal_wd_hours')# </cfif><cfif a_int_minutes GT 0>#a_int_minutes# #GetLangVal('cal_wd_minutes')#</cfif>)

		#a_str_td_break#

			#htmleditformat(q_select_events.description)#

		#a_str_td_break#

			<cfif ListLen(arguments.contactkeys) GT 1>

				<cfquery name="q_select_meeting_contact" dbtype="query">
				SELECT
					parameter AS contactkey
				FROM
					q_select_meeting_members_information
				WHERE
					eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_events.entrykey#">
					AND
					type = 1
				;
				</cfquery>

				<cfloop query="q_select_meeting_contact">
					<a href="/addressbook/?action=ShowItem&entrykey=#q_select_meeting_contact.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_meeting_contact.contactkey)#</a>
				</cfloop>
				<br />
			</cfif>

			#htmleditformat(q_select_events.location)#

			<cfif arguments.managemode>
				<br />
				<a href="/calendar/index.cfm?action=ShowEvent&entrykey=#q_select_events.entrykey#"><img src="/images/si/pencil.png" class="si_img" /> #MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a>
			</cfif>
		</td>
	</tr>
</cfoutput>
</table>

</cfsavecontent>


<!--- set content return string ... --->
<cfset stReturn.a_str_content = sReturn />

