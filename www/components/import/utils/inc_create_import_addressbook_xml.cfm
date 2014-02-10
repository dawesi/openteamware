<!--- //

	Module:        Import
	Description:   Create XML for import into address book
	

// --->

<cfif Len(arguments.categories_to_add) GT 0>
	<!--- check if a category field exists ... if true, add given category to the field --->
	<cfquery name="q_select_category_field_exists" dbtype="query">
	SELECT
		importfieldname
	FROM
		q_fields_mapping
	WHERE
		fieldname = 'category'
	;
	</cfquery>
	
	<cfif q_select_category_field_exists.recordcount IS 1>
	
		<cfloop query="q_select_data">
			
			<cfset a_str_current_category = q_select_data[q_fields_mapping.importfieldname][q_select_data.currentrow] />
			
			<cfset tmp = QuerySetCell(q_select_data, q_select_category_field_exists.importfieldname, ListAppend(a_str_current_category, arguments.categories_to_add), q_select_data.currentrow) />
		</cfloop>
	<cfelse>
		<cfset a_bol_add_own_category_field = true />
	</cfif>
</cfif>

<cfxml casesensitive="no" variable="a_str_xml_import">
<cfoutput>
<contacts>
	<cfloop query="q_select_data">
	<contact>
	
		<!--- which criteria to add? ... set the default value (criteria provided by user) --->
		<cfset a_str_criteria_of_this_contact = arguments.criteria_to_set />
	
		<!--- loop through fields --->
		<cfloop query="q_fields_mapping">
			<!--- output default .XML ... --->
			<#q_fields_mapping.fieldname#>#xmlformat(trim(q_select_data[q_fields_mapping.importfieldname][q_select_data.currentrow]))#</#q_fields_mapping.fieldname#>
		
			<!--- check for the certain displayname ...
				ok, we have to check if a certain value exists, and if yes, add this criteria to the contact ...
				the name of the field to check is stored in the importfieldname property
				
				Must be "1" in order to set the criteria --->
			<cfif FindNoCase('SetCriteriaIfTrue_', q_fields_mapping.displayname) IS 1>
			
				<!--- get the criteria ID to set if the field is "1" --->
				<cfset a_str_tmp_criteria_id = val(ReplaceNoCase(q_fields_mapping.displayname, 'SetCriteriaIfTrue_', '')) />
				
				<cfif (a_str_tmp_criteria_id GT 0) AND (Val(q_select_data[q_fields_mapping.importfieldname][q_select_data.currentrow]) IS 1)>
					
					<!--- set the new value for the criteria to set ... --->
					<cfset a_str_criteria_of_this_contact = ListAppend(a_str_criteria_of_this_contact, a_str_tmp_criteria_id) />
				</cfif>
			
			</cfif>
		</cfloop>
		
		<!--- criteria to set? --->
		<cfif Len(a_str_criteria_of_this_contact) GT 0>
			<criteria>#xmlformat(Trim(a_str_criteria_of_this_contact))#</criteria>
		</cfif>
		
		<!--- add categories? --->
		<cfif a_bol_add_own_category_field>
			<categories>#XMLFormat(arguments.categories_to_add)#</categories>
		</cfif>
		
		<!--- general type --->
		<contacttype>#q_select_import_table.datatype#</contacttype>
	</contact>
	</cfloop>
</contacts>
</cfoutput>
</cfxml>

