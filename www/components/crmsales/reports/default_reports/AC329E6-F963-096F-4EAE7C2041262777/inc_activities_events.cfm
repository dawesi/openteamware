<!--- //

	ereignisse aus dem crm bereich
	
	// --->
	
<!--- load activities now ... based on the activities, load the contacts ---><!--- 
<cfinvoke
		component = "#a_cmp_database#"   
		method = "GetTableData"   
		returnVariable = "a_struct_tabledata"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crm_bindings.activities_tablekey#">
</cfinvoke>

<cfset q_select_activities = a_struct_tabledata.origquery>

<cflog text="activities (total number): #q_select_activities.recordcount#" type="Information" log="Application" file="ib_crm_reports">

<cfinvoke
		component = "#a_cmp_database#"   
		method = "GetTableFields"   
		returnVariable = "q_select_table_fields"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crm_bindings.activities_tablekey#">
</cfinvoke>

<!---
	why did dateformat(yyyy) not work?
	we will never know it ...
--->

<cfset a_int_date_start_timeframe = '20' & DateFormat(a_dt_option_start_date, 'yymmdd')>
<cfset a_int_date_end_timeframe = '20' & DateFormat(a_dt_option_start_end, 'yymmdd')>


<!--- select timeframe ... --->
<cfquery name="q_select_activities" dbtype="query">
SELECT
	*
FROM
	q_select_activities
WHERE
	<!---(dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_end)#">)--->
	(dt_created_int BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_date_start_timeframe#">
		 AND <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_date_end_timeframe#">)

	<cfif Len(a_str_option_createdbyuserkey) GT 0>
		AND (userentrykey_created IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_option_createdbyuserkey#" list="yes">))
	</cfif>
;
</cfquery>

<cflog text="start date: #a_int_date_start_timeframe#" type="Information" log="Application" file="ib_crm_reports">

<cflog text="end date: #a_int_date_end_timeframe#" type="Information" log="Application" file="ib_crm_reports">

<cflog text="connected events (activities): #q_select_activities.recordcount#" type="Information" log="Application" file="ib_crm_reports">


<!--- now, select the address book entrykey field ... --->
<cfquery name="q_select_addressbookkey_field" dbtype="query">
SELECT
	fieldname
FROM
	q_table_fields
WHERE
	showname = 'addressbookkey'
;
</cfquery>

<cfset a_str_addressbookkey_fieldname = q_select_addressbookkey_field.fieldname> --->
<!--- 
<!--- if activities are here, check them ... --->
<cfif q_select_activities.recordcount GT 0>
	
	<cfset a_str_col_list_activities = q_select_activities.columnlist>
	<cfset a_str_col_list_q_delete_data = q_select_data.columnlist>

	<!--- loop over activities and add rows --->
	<cfloop query="q_select_activities">
	
		<cfset a_int_cur_row = q_select_activities.currentrow>
		
		<!--- add a new row to the output table --->
		<cfset QueryAddRow(q_select_data, 1)>
		
		<!--- set the address book key and who has created this entry --->
		<cfset QuerySetCell(q_select_data, 'addressbookkey', q_select_activities[a_str_addressbookkey_fieldname][a_int_cur_row], q_select_data.recordcount)>
		<cfset QuerySetCell(q_select_data, 'VIRT_createdbyuserkey', q_select_activities['USERENTRYKEY_CREATED'][a_int_cur_row], q_select_data.recordcount)>
		
		<!--- set common data like subject, item_Type ... these fields have ALWAYS to exist! --->
		<cfset QuerySetCell(q_select_data, 'VIRT_ITEMTYPE', request.a_cmp_lang.GetLangValExt(entryid = 'cm_wd_crm_event', langno = arguments.usersettings.language), q_select_data.recordcount)>
		
		<!--- creation date --->
		<cfset QuerySetCell(q_select_data, 'virt_itemcreated', q_select_activities['dt_created'][a_int_cur_row], q_select_data.recordcount)>
		
		<!--- if the column exists in the output query (=user has selected the field, then set the data in the output query --->
		<cfloop list="#a_str_col_list_q_delete_data#" index="a_str_col_name_q_data">
		
			<!--- the the real col name form the q_data table --->
			<cfset a_str_col_name_check = ReplaceNoCase(a_str_col_name_q_data, 'virt_', '', 'ONE')>
			
			<cfif ListFindNoCase(a_str_col_list_activities, a_str_col_name_check) GT 0>
			
				<cfset QuerySetCell(q_select_data, a_str_col_name_q_data, q_select_activities[a_str_col_name_check][a_int_cur_row], q_select_data.recordcount)>
				
			</cfif>
			
		</cfloop>
		 
	</cfloop>

</cfif>

<!--- set contact data to load --->
<cfset sEntrykeys_of_contacts_2_load = ListAppend(sEntrykeys_of_contacts_2_load, ArrayToList(q_select_activities[a_str_addressbookkey_fieldname]))> --->