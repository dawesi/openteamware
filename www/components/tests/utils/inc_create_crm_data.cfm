<!--- //

	lookup information ...
	
	// --->
	
<cfinvoke
		component = "#request.a_str_component_database#"   
		method = "GetTableFields"   
		returnVariable = "q_table_fields"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#"
		 >
</cfinvoke>

<cflog text="fields: #valuelist(q_table_fields.showname)#" type="Information" log="Application" file="ib_import">

<cfset ShowCoreData.save_data = StructNew()>

<cfloop list="#StructKeyList(a_struct_data)#" index="a_str_index" delimiters=",">

	<cfset a_str_index_search = Replace(a_str_index, 'db_', '', 'ONE')>
	
	<cflog text="looking for: #a_str_index_search#" type="Information" log="Application" file="ib_import">
	
	<!--- check via qoq if exists ... --->
	<cfquery name="q_select_field_name" dbtype="query">
	SELECT
		fieldname
	FROM
		q_table_fields
	WHERE
		LOWER(showname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(a_str_index_search)#">
	;
	</cfquery>
	
	<cfif (q_select_field_name.recordcount IS 1) AND (Len(a_struct_data[a_str_index]) GT 0)>
	
		<cflog text="hit: #q_select_field_name.fieldname#" type="Information" log="Application" file="ib_import">
		
		<cfset ShowCoreData.save_data['frm_input_value_' & q_select_field_name.fieldname] = a_struct_data[a_str_index]>
	</cfif>
	
</cfloop>

<cfquery name="q_select_field_name_addressbookkey" dbtype="query">
SELECT
	fieldname
FROM
	q_table_fields
WHERE
	LOWER(showname) = 'addressbookkey'
;
</cfquery>
	
<cfset ShowCoreData.save_data['frm_input_value_' & q_select_field_name_addressbookkey.fieldname] = sEntrykey>

<cfinvoke
			component = "#request.a_str_component_database#"   
			method = "SaveTableData"   
			returnVariable = "a_struct_info"   
			securitycontext="#arguments.securitycontext#"
			usersettings="#arguments.usersettings#"
			table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#"
			record_entrykey=""
			record_data="#ShowCoreData.save_data#"
			add_data = true
			 >
</cfinvoke>