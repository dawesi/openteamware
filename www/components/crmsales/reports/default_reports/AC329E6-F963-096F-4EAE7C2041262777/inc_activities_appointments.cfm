<!--- //

	also include calendar data ...
	
	// --->
	
<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<cfif Len(a_str_option_createdbyuserkey) GT 0>
	<cfset a_str_userkeys_created_by = a_str_option_createdbyuserkey>
<cfelse>
	<cfset a_str_userkeys_created_by = ValueList(q_select_users.entrykey)>
</cfif>

<cfquery name="q_select_events" datasource="#request.a_str_db_tools#">
SELECT
	meetingmembers.dt_created,
	meetingmembers.parameter,
	meetingmembers.createdbyuserkey,
	calendar.title,
	calendar.description,
	calendar.location,
	calendar.date_start,
	calendar.date_end,
	calendar.userkey
FROM
	meetingmembers
LEFT JOIN
	calendar ON (calendar.entrykey = meetingmembers.eventkey)
WHERE
	(meetingmembers.createdbyuserkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkeys_created_by#" list="yes">))
	AND
	(meetingmembers.type = 3)
	AND
	(calendar.date_start BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_end)#">)
;
</cfquery>

<cflog text="connected appointments: #q_select_events.recordcount#" type="Information" log="Application" file="ib_crm_reports">

<cfloop query="q_select_events">
	<!--- add a new row to the output table --->
	<cfset QueryAddRow(q_select_data, 1)>
	
	<!--- set the address book key --->
	<cfset QuerySetCell(q_select_data, 'addressbookkey', q_select_events.parameter, q_select_data.recordcount)>
	
	<!--- set common data like subject, item_Type ... these fields have ALWAYS to exist! --->
	<cfset QuerySetCell(q_select_data, 'VIRT_ITEMTYPE', request.a_cmp_lang.GetLangValExt(entryid = 'cm_wd_appointment', langno = arguments.usersettings.language), q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'VIRT_createdbyuserkey', q_select_events.userkey, q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'VIRT_SUBJECT', q_select_events.title, q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'virt_location', q_select_events.location, q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'virt_date_start', LsDateFormat(q_select_events.date_start, arguments.usersettings.default_dateformat) & ' ' & TimeFormat(q_select_events.date_start, arguments.usersettings.default_timeformat), q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'virt_date_end', LsDateFormat(q_select_events.date_end, arguments.usersettings.default_dateformat) & ' ' & TimeFormat(q_select_events.date_end, arguments.usersettings.default_timeformat), q_select_data.recordcount)>
	
	
	<!--- created field = start date --->
	<cfset QuerySetCell(q_select_data, 'virt_itemcreated', q_select_events.date_start, q_select_data.recordcount)>
	
	<cfsavecontent variable="a_str_description">
		<cfoutput>
		#q_select_events.description#
		</cfoutput>
	</cfsavecontent>
		
	<cfset QuerySetCell(q_select_data, 'virt_description', trim(a_str_description), q_select_data.recordcount)>

</cfloop>

<!--- add information ... load contact data of the found contacts too! --->		
<cfset sEntrykeys_of_contacts_2_load = ListAppend(sEntrykeys_of_contacts_2_load, ValueList(q_select_events.parameter))>