<!--- //

	Module:        Import
	Description:   Import component
	

	$Id: cmp_import.cfc,v 1.16 2007-10-04 16:31:17 hansjp Exp $	// --->
<cfcomponent name="ImportData" hint="Import data from various formats">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- the supported formats - might be extended in future times ... --->
	<cfset request.a_str_supported_file_type_for_import = 'xls' />

	<cffunction name="ParseUploadedFileAndReturnResult" output="false" returntype="struct"
			hint="parse the given file using a parser and return the structure with the information">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of service the user wants to import data to">
		<cfargument name="datatype" type="numeric" default="0" required="false"
			hint="type of data to import (may vary from service to service, e.g. contacts = 0, accounts = 1) ...">
		<cfargument name="jobkey" type="string" required="true" hint="entrykey of import job">
		<cfargument name="filename" type="string" required="true" hint="location of file to parse">
		<cfargument name="filetype" type="string" required="true" hint="type of file" default="xls">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_parsedata = StructNew() />
		
		<cfset request.a_str_supported_file_type_for_import = 'xls' />
		
		<!--- is the filetype supported? --->
		<cfif ListFindNoCase(request.a_str_supported_file_type_for_import, arguments.filetype) IS 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 12502) />
		</cfif>
		
		<!--- check file type and call the right parser --->
		<cfswitch expression="#arguments.filetype#">
			<cfcase value="xls">
				<cfset stReturn_parsedata = CreateObject('component', 'cmp_read_xls').ParseData(filename = arguments.filename) />
			</cfcase>
		</cfswitch>
		
		<!--- check result of parser ... --->
		<cfif NOT stReturn_parsedata.result>
			<cfreturn CopyReturnStructData(stReturn, stReturn_parsedata) />
		</cfif>
		
		<!--- add a last new column called 'ibx_entrykey' ... and fill this field with
		uuids in order to uniquely identify each record!! --->
		<cfset a_arr_uuids = ArrayNew(1) />
		<cfloop index="a_int_loop" from="1" to="#stReturn_parsedata.q_select_data.recordcount#">
			<cfset a_arr_uuids[a_int_loop] = CreateUUID() />
		</cfloop>
		<cfset QueryAddColumn(stReturn_parsedata.q_select_data, 'ibx_entrykey', a_arr_uuids)>
		
		<!--- convert the query to wddx (to be able to store it in db) --->
		<cfwddx action="cfml2wddx" input="#stReturn_parsedata.q_select_data#" output="a_str_wddx">
		
		<!--- insert job --->
		<cfinclude template="queries/q_insert_import_job.cfm">

		<cfset stReturn.q_select_data = stReturn_parsedata.q_select_data>
		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>
	
	
	<cffunction access="public" name="GetImportTable" returntype="struct" output="false">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="jobkey" type="string" required="true" hint="entrykey of import job">
		
		<cfset var stReturn = GenerateReturnStruct()>
		
		<!--- load table from temp table ... --->
		<cfinclude template="queries/q_select_import_table.cfm">
		
		<cfwddx action="wddx2cfml" input="#q_select_import_table.table_wddx#" output="q_select_data">
		
		<!--- return the servicekey, datatype & query ... ---->
		<cfset stReturn.datatype = q_select_import_table.datatype />
		<cfset stReturn.servicekey = q_select_import_table.servicekey />
		<cfset stReturn.q_select_data = q_select_data />
		
		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>
	

	<cffunction access="public" name="SaveFieldMappings" returntype="struct" output="false"
			hint="save field mappings">	
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="jobkey" type="string" required="true" hint="entrykey of import job">
		<cfargument name="fieldstructure" type="struct" required="true"
			hint="structure with information">

		<cfset var stReturn = GenerateReturnStruct() />
		
		<!--- check if the fieldstructure argument is not empty structure --->
		<cfif StructIsEmpty(arguments.fieldstructure)>
			<cfreturn SetReturnStructErrorCode(stReturn, 12503) />
		</cfif>

		<!--- store the mappings --->
		<cfinclude template="queries/q_insert_field_mappings.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="GetFieldMappings" returntype="query" output="false"
			hint="return saved fields mappings">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="jobkey" type="string" required="true" hint="entrykey of import job">
		<cfargument name="servicekey" type="string" required="true" hint="entrykey of service for obtaining the displayname of the mapping record">
		
		<cfset 0 />
		<cfset var q_fields_of_service = 0 />
		<cfset var q_select_field_mappings = 0 />
		<cfset var a_int_rcount = 0 />
		<cfset var q_select_return = 0 />
	
		<!--- get the list of service fields (for displayname) --->
		<cfinvoke component="#application.components.cmp_tools#" method="ReturnDatabaseFieldsOfService" returnvariable="q_fields_of_service">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="servicekey" value="#arguments.servicekey#">
		</cfinvoke>
		
		<cfinclude template="queries/q_select_field_mappings.cfm">
		
		<cfquery dbtype="query" name="q_select_return">
			select 
				q_fields_of_service.displayname,
				q_fields_of_service.fieldname,
				q_select_field_mappings.ibxfield_md5,
				q_select_field_mappings.importfieldname
			from 
				q_select_field_mappings, q_fields_of_service
			where
				(q_select_field_mappings.ibxfield_md5 = q_fields_of_service.name_md5)
		</cfquery>
		
		<!--- include virtual set criteria fields ... --->
		<cfloop query="q_select_field_mappings">
			
			<cfif FindNoCase('SetCriteriaIfTrue_', q_select_field_mappings.ibxfield_md5) IS 1>
			
				<cfset a_int_rcount = (q_select_return.recordcount + 1) />
				<cfset QueryAddRow(q_select_return, 1) />
				<cfset QuerySetCell(q_select_return, 'displayname', q_select_field_mappings.ibxfield_md5, a_int_rcount) />
				<cfset QuerySetCell(q_select_return, 'fieldname', q_select_field_mappings.ibxfield_md5, a_int_rcount) />
				<cfset QuerySetCell(q_select_return, 'importfieldname', q_select_field_mappings.importfieldname, a_int_rcount) />
				<cfset QuerySetCell(q_select_return, 'ibxfield_md5', q_select_field_mappings.ibxfield_md5, a_int_rcount) />
				
			</cfif>
			
		</cfloop>
		
		<cfreturn q_select_return />
	</cffunction>
	
	<cffunction access="public" name="DeleteFieldMappingsOfJob" returntype="boolean" output="false"
			hint="delete the saved field mappings of a certain job key (to prevent double imports ...)">
		<cfargument name="jobkey" type="string" required="true"
			hint="entrykey of import job">
			
		<cfinclude template="queries/q_delete_saved_field_mappings.cfm">
		
		<cfreturn true />

	</cffunction>

	
	<cffunction access="public" name="DoImportData" returntype="struct" output="false"
			hint="really import data now">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="jobkey" type="string" required="true"
			hint="entrykey of import job">
		<cfargument name="dataentrykeystoimport" type="string" required="true"
			hint="entrykeys of records to import">
		<cfargument name="categories_to_add" type="string" required="false" default=""
			hint="categories to add">
		<cfargument name="criteria_to_set" type="string" required="false" default=""
			hint="criteria to set">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_xml_import = '' />
		<cfset var q_select_data = 0 />
		<cfset var a_bol_add_criteria_field = (Len(arguments.criteria_to_set) GT 0) />
		<cfset var a_bol_add_own_category_field = false />
		<cfset var a_str_criteria_of_this_contact = '' />
		<cfset var a_str_tmp_criteria_id = 0 />
		<cfset var stReturn_import = 0 />
		<cfset var a_cmp_create_contacts = CreateObject('component', 'cmp_write_addressbook') />
		
		<!--- Check if the dataentrykeystoimport is not empty --->
		<cfif Len(arguments.dataentrykeystoimport) EQ 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 12505) />
		</cfif>
		
		<!--- load the import job data --->
		<cfinclude template="queries/q_select_import_table.cfm">
		<cfwddx action="wddx2cfml" input="#q_select_import_table.table_wddx#" output="q_select_data">

		<!--- select only data that has been selected --->
		<cfquery dbtype="query" name="q_select_data">
		SELECT
			*
		FROM
			q_select_data
		WHERE
			ibx_entrykey IN ( #ListQualify(arguments.dataentrykeystoimport, "'")# )
		;
		</cfquery>
		
		<!--- load the field mappings --->
		<cfset q_fields_mapping = GetFieldMappings(securitycontext = arguments.securitycontext,
					usersettings = arguments.usersettings,
					jobkey  = arguments.jobkey,
					servicekey = q_select_import_table.servicekey) />
		
		<cfset stReturn_import = GenerateReturnStruct() />
		
		<!--- call the appropriate importData function (for the job's servicekey) --->
		<cfswitch expression="#q_select_import_table.servicekey#">
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<!--- address book! --->
				<cfinclude template="utils/inc_create_import_addressbook_xml.cfm">
				
				<cfinvoke component="#a_cmp_create_contacts#" method="ImportData" returnvariable="stReturn_import">
					<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
					<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
					<cfinvokeargument name="xmldata" value="#a_str_xml_import#">
				</cfinvoke>
			</cfcase>
		</cfswitch>
		
		<cfif NOT stReturn_import.result>
			<cfreturn CopyReturnStructData(stReturn, stReturn_import) />
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>
	
</cfcomponent>