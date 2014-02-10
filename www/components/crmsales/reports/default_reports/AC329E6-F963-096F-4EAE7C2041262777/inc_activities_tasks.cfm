<!--- //

	load all tasks assigned to contacts
	
	with a certain start/end date
	
	// --->
	
<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<cfif Len(a_str_option_createdbyuserkey) GT 0>
	<cfset a_str_userkeys_created_by = a_str_option_createdbyuserkey>
<cfelse>
	<cfset a_str_userkeys_created_by = ValueList(q_select_users.entrykey)>
</cfif>
	
<!--- load all connected tasks --->
<cfquery name="q_select_connected_tasks" datasource="#request.a_Str_Db_tools#">
SELECT
	tasks.userkey,
	tasks.entrykey,
	tasks.title,
	tasks.notice,
	tasks.status,
	tasks.dt_due,
	tasks.categories,
	tasks.percentdone,
	tasks.dt_done,
	tasks.dt_start,
	tasks.dt_created,
	tasks_assigned_to_contacts.taskkey,
	tasks_assigned_to_contacts.contactkey
FROM
	tasks
LEFT JOIN
	tasks_assigned_to_contacts ON (tasks_assigned_to_contacts.taskkey = tasks.entrykey)
WHERE
	(tasks.userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkeys_created_by#" list="yes">))
	AND
	(Length(tasks_assigned_to_contacts.taskkey) > 0)
	AND
	<!--- create date --->
	(tasks.dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_end)#">)
;
</cfquery>

<cflog text="connected tasks: #q_select_connected_tasks.recordcount#" type="Information" log="Application" file="ib_crm_reports">

<cfloop query="q_select_connected_tasks">
		<!--- add a new row to the output table --->
		<cfset tmp = QueryAddRow(q_select_data, 1)>
		
		<!--- set the address book key --->
		<cfset tmp = QuerySetCell(q_select_data, 'addressbookkey', q_select_connected_tasks.contactkey, q_select_data.recordcount)>
		
		<!--- set common data like subject, item_Type ... these fields have ALWAYS to exist! --->
		<cfset tmp = QuerySetCell(q_select_data, 'VIRT_ITEMTYPE', request.a_cmp_lang.GetLangValExt(entryid = 'cm_wd_task', langno = arguments.usersettings.language), q_select_data.recordcount)>
		<cfset tmp = QuerySetCell(q_select_data, 'VIRT_SUBJECT', q_select_connected_tasks.title, q_select_data.recordcount)>

		<cfset a_str_task_status_langval = 'tsk_wd_status_' & q_select_connected_tasks.status>		
		<cfset tmp = QuerySetCell(q_select_data, 'virt_task_status', request.a_cmp_lang.GetLangValExt(entryid = a_str_task_status_langval, langno = arguments.usersettings.language), q_select_data.recordcount)>
		
		<cfset tmp = QuerySetCell(q_select_data, 'VIRT_createdbyuserkey', q_select_connected_tasks.userkey, q_select_data.recordcount)>
		<!--- creation date --->
		<cfset tmp = QuerySetCell(q_select_data, 'virt_itemcreated', q_select_connected_tasks.dt_created, q_select_data.recordcount)>
		
		
		<cfsavecontent variable="a_str_description">
			<cfoutput>
			%: #val(q_select_connected_tasks.percentdone)#%#chr(13)##chr(10)#
			<cfif IsDate(q_select_connected_tasks.dt_due)>
			#request.a_cmp_lang.GetLangValExt(entryid = 'tsk_ph_due_to', langno = arguments.usersettings.language)#: #LSDateFormat(q_select_connected_tasks.dt_due, arguments.usersettings.default_dateformat)#
			</cfif>
			</cfoutput>
		</cfsavecontent>
		
	<cfset tmp = QuerySetCell(q_select_data, 'virt_description', trim(a_str_description), q_select_data.recordcount)>

</cfloop>

<!--- add information ... load contact data of the found contacts too! --->		
<cfset sEntrykeys_of_contacts_2_load = ListAppend(sEntrykeys_of_contacts_2_load, ValueList(q_select_connected_tasks.contactkey))>