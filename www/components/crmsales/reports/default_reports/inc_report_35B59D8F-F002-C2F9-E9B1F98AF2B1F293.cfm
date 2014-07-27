<!--- create a report of overdue followups ... --->

<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_filter = StructNew()>

<cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>
<cfset a_cmp_crmsales = application.components.cmp_crmsales>
<cfset a_cmp_users = application.components.cmp_user>
<cfset a_cmp_translation = application.components.cmp_lang>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_userdata">
	<cfinvokeargument name="entrykey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<cfset q_select_user = a_struct_userdata.query>
<cfset iLangNo = a_struct_userdata.query.defaultlanguage>

<!--- always create a temp filter when selecting criterias --->
<cfinvoke component="#a_cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="viewkey" value="#arguments.crmfilterkey#">
</cfinvoke>

<!--- add possible options now to the crm filter structure ... --->
<cfinvoke component="/components/crmsales/crm_reports" method="MergeCRMFilterWithReportFilter" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="user_options" value="#arguments.options#">
	<cfinvokeargument name="report_options" value="#a_arr_report_options#">
	<cfinvokeargument name="crm_filter" value="#a_struct_crm_filter#">
</cfinvoke>

<cfset a_struct_crm_bindings = a_cmp_crmsales.GetCRMSalesBinding(companykey = request.stSecurityContext.mycompanykey)>
<cfset a_str_crm_databasekey = a_struct_crm_bindings.databasekey> 

<!--- use all rows --->
<cfset a_struct_loadoptions.maxrows = 0>
<cfset a_struct_filter.NoArchiveItems = true>

<!--- load contacts ... order by which column??? --->	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
	<!--- load crm data at once without manual reloads --->
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="fieldlist" value="#arguments.includefields#">
</cfinvoke>

<cfset q_select_fieldnames_of_contacts_table = stReturn_contacts.q_select_table_fields>

<!--- add additional fields?? reports only works in cfmx7 because of new attribute ... --->
<cfloop from="1" to="#ArrayLen(arguments.virtualfields)#" index="ii">
	
	<!--- add column to table with information about fieldnames ... --->
	<cfset QueryAddRow(q_select_fieldnames_of_contacts_table, 1)>
	<cfset QuerySetCell(q_select_fieldnames_of_contacts_table, 'fielddescription', '', q_select_fieldnames_of_contacts_table.recordcount)>
	<cfset QuerySetCell(q_select_fieldnames_of_contacts_table, 'showname', arguments.virtualfields[ii].fieldname, q_select_fieldnames_of_contacts_table.recordcount)>
	<cfset QuerySetCell(q_select_fieldnames_of_contacts_table, 'fieldname', arguments.virtualfields[ii].entrykey, q_select_fieldnames_of_contacts_table.recordcount)>
	<cfset QuerySetCell(q_select_fieldnames_of_contacts_table, 'fieldtype', a_cmp_database.GetDatabaseDataTypeFromSimpleInBoxccDataType(arguments.virtualfields[ii].datatype), q_select_fieldnames_of_contacts_table.recordcount)>
</cfloop>

<!--- now fill fields ... --->
<cfif Len(stReturn_contacts.crm_filter_returned_meta_data.entrykeys_followup_items) IS 0>
	<cfset stReturn_contacts.crm_filter_returned_meta_data.entrykeys_followup_items = 'dummyitem'>
</cfif>

<cfquery name="q_select_follow_ups_items" datasource="#request.a_str_db_tools#">
SELECT
	objectkey,userkey,createdbyuserkey,dt_due,comment,followuptype,priority,done 
FROM
	followups
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#stReturn_contacts.crm_filter_returned_meta_data.entrykeys_followup_items#" list="yes">)
;
</cfquery>

<cfdump var="#q_select_follow_ups_items#">

<!--- make a JOIN of followup items and contacts table --->
<cfset q_select_contacts = stReturn_contacts.q_select_contacts>

<cfquery name="q_select_contacts" dbtype="query">
SELECT

	<!--- add followup fields ... --->
	<cfloop list="#q_select_follow_ups_items.columnlist#" delimiters="," index="a_str_col">
	
		<cfloop from="1" to="#ArrayLen(arguments.virtualfields)#" index="ii">
		
			<cfif (CompareNoCase(arguments.virtualfields[ii].internal_fieldname, a_str_col) IS 0)>
				<!--- field found ... select it using AS parameter (AS virtual entrykey) plus CAST (be sure to have the right contenttype) --->
				CAST(q_select_follow_ups_items.#a_str_col# AS #GetColdFusionQueryDataTypeFromInBoxccDataType(arguments.virtualfields[ii].datatype)#) AS #arguments.virtualfields[ii].entrykey#,	
			</cfif>		
		</cfloop>
	
	</cfloop>
	
	<!--- add contacts fields --->
	<cfloop list="#q_select_contacts.columnlist#" delimiters="," index="a_str_col">
		q_select_contacts.#a_str_col#		
		<cfif ListLast(q_select_contacts.columnlist) NEQ a_str_col>,</cfif>		
	</cfloop>
FROM
	q_select_follow_ups_items,
	q_select_contacts	
WHERE
	q_select_follow_ups_items.objectkey = q_select_contacts.entrykey
;
</cfquery>

<!--- check if various fields exist --->
<cfset a_bol_userkey_field_exists = ListFindNoCase(q_select_contacts.columnlist, 'virt_9vuwh513_0C384092805A28109057DA86')>
<cfset a_bol_createdbyuserkey_field_exists = ListFindNoCase(q_select_contacts.columnlist, 'virt_d90dfgh20C384092805A28109057DA86')>
<cfset a_bol_type_field_exists = ListFindNoCase(q_select_contacts.columnlist, 'virt_39B385130C384092805A28109057DA86')>

<cfloop query="q_select_contacts">
	
	<!--- replace usernames ... --->
	<cfif a_bol_userkey_field_exists>
		<cfset QuerySetCell(q_select_contacts, 'virt_9vuwh513_0C384092805A28109057DA86', a_cmp_users.getusernamebyentrykey(q_select_contacts.virt_9vuwh513_0C384092805A28109057DA86), q_select_contacts.currentrow)>
	</cfif>
	
	<cfif a_bol_createdbyuserkey_field_exists>
		<cfset QuerySetCell(q_select_contacts, 'virt_d90dfgh20C384092805A28109057DA86', a_cmp_users.getusernamebyentrykey(q_select_contacts.virt_d90dfgh20C384092805A28109057DA86), q_select_contacts.currentrow)>	
	</cfif>
	
	<!--- replace followup type --->
	<cfif a_bol_type_field_exists>
	
		<cfswitch expression="#val(q_select_contacts.virt_39B385130C384092805A28109057DA86)#">
			<cfcase value="1">
				<cfset a_str_followup_type = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_email', langno = iLangNo)>
			</cfcase>			
			<cfcase value="2">
				<cfset a_str_followup_type = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_follow_up_call', langno = iLangNo)>
			</cfcase>
			<cfcase value="3">
				<cfset a_str_followup_type = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_follow_up_write_letter', langno = iLangNo)>
			</cfcase>
			<cfdefaultcase>
				<cfset a_str_followup_type = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_follow_up', langno = iLangNo)>
			</cfdefaultcase>
		</cfswitch>
		
		<cfset QuerySetCell(q_select_contacts, 'virt_39B385130C384092805A28109057DA86', a_str_followup_type, q_select_contacts.currentrow)>		
	</cfif>
	
</cfloop>

<cfdump var="#q_select_contacts#" label="q_select_contacts">

<cfset stReturn_contacts.q_select_contacts = q_select_contacts>


<cfinvoke component="/components/crmsales/crm_reports" method="CreateReportOutputTable" returnvariable="stReturn_create_output_table">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="reportkey" value="#q_select_report_settings.entrykey#">
	<cfinvokeargument name="databasekey" value="#a_str_databasekey_for_report#">
	<cfinvokeargument name="tablename" value="#GetLangVal('crm_ph_report_output_table_name_begin')# #q_select_report_settings.reportname# (#DateFormat(now(), 'dd.mm.yy')# #TimeFormat(now(), 'hhmm')#)">
	<cfinvokeargument name="tabledescription" value="#GetLangVal('cm_ph_created_by')# #a_cmp_users.getusernamebyentrykey(arguments.securitycontext.myuserkey)#">
	<cfinvokeargument name="q" value="#stReturn_contacts.q_select_contacts#">
	<cfinvokeargument name="q_select_fieldnames" value="#q_select_fieldnames_of_contacts_table#">
	<cfinvokeargument name="adddata" value="true">
</cfinvoke>

<cfset stReturn.tablekey_of_report_output = stReturn_create_output_table.tablekey>