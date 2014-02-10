<!--- //

	update crm data of contact
	
	// --->


<!--- record data auf die felder mappen --->

<!--- load fields --->
<cfif StructKeyExists(request, 'a_cached_comp_database')>
	<cfset variables.a_cmp_db = request.a_cached_comp_database>
<cfelse>
	<cfset variables.a_cmp_db = CreateObject('component', request.a_str_component_database)>
	<cfset request.a_cached_comp_database = variables.a_cmp_db>
</cfif>	
	
<cfinvoke
		component = "#variables.a_cmp_db#"   
		method = "GetTableFields"   
		returnVariable = "q_table_fields"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#"
		 >
</cfinvoke>

<cfloop query="q_table_fields">
	<cflog text="fieldname: #q_table_fields.fieldname#" type="Information" log="Application" file="ib_ws">
	<cflog text="showname: #q_table_fields.showname#" type="Information" log="Application" file="ib_ws">
</cfloop>

<cfset stUpdate_data_crm = StructNew()>

<!--- loop update data ... --->
<cfloop list="#StructKeyList(a_struct_contact_data)#" index="a_str_item">
	<cflog text="#a_str_item#: #a_struct_contact_data[a_str_item]#" type="Information" log="Application" file="ib_ws">
	
	<cfif FindNoCase('db_', a_str_item) IS 1>
		<!--- OK, might be an own database field --->
		
		<cfset a_str_fieldname = ReplaceNoCase(a_str_item, 'db_', '', 'ONE')>
		
		<!--- check if it is really an own datafield ... --->
		
		<cfquery name="q_select_is_own_datafield" dbtype="query">
		SELECT
			*
		FROM
			q_table_fields
		WHERE
			UPPER(showname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_fieldname)#">
		;
		</cfquery>
		
		<cfif q_select_is_own_datafield.recordcount IS 1>
			<!--- hit! --->
			<cflog text="hit! for #a_str_fieldname#" type="Information" log="Application" file="ib_ws">
			
			<cfset stUpdate_data_crm['frm_input_value_' & q_select_is_own_datafield.fieldname] = a_struct_contact_data[a_str_item]>
		</cfif>
		
	</cfif>
</cfloop>

<!---
<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="stUpdate_data_crm" type="html">
<cfdump var="#stUpdate_data_crm#">
</cfmail>--->

<cfif StructCount(stUpdate_data_crm) GT 0>

	<!--- select address book key field ... --->
	<cfquery name="q_select_addressbookkey_field" dbtype="query">
	SELECT
		fieldname
	FROM
		q_table_fields
	WHERE
		showname = 'addressbookkey'
	;
	</cfquery>
	
	<cfset stUpdate_data_crm['frm_input_value_' & q_select_addressbookkey_field.fieldname] = arguments.entrykey>

	<!--- we've got data to update ... --->

	<cfinvoke component="#variables.a_cmp_db#" method="GetRecordEntrykeyByAddressbookEntrykey" returnvariable="a_str_record_entrykey">
		<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
		<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
		<cfinvokeargument name="addressbookkey" value="#arguments.entrykey#">
		<cfinvokeargument name="tablekey" value="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#">
	</cfinvoke>
	
	<cflog text="a_str_record_entrykey: #a_str_record_entrykey#" type="Information" log="Application" file="ib_ws">
	
	
	<cfinvoke
				component = "#variables.a_cmp_db#"   
				method = "SaveTableData"   
				returnVariable = "a_struct_info"   
				securitycontext="#arguments.securitycontext#"
				usersettings="#arguments.usersettings#"
				table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#"
				record_entrykey="#a_str_record_entrykey#"
				record_data="#stUpdate_data_crm#"
				>
	</cfinvoke>
	
</cfif>