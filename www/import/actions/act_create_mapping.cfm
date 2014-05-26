<!--- //

	Module:        Import
	Description:   create mapping and forward to preview page
	

// --->

<cfparam name="form.frm_jobkey" type="string">

<cfset a_struct_fields = StructNew() />

<!--- delete old definitions ... --->
<cfinvoke component="#application.components.cmp_import#" method="DeleteFieldMappingsOfJob" returnvariable="ab">
	<cfinvokeargument name="jobkey" value="#form.frm_jobkey#">
</cfinvoke>

<!--- Loop though all form field names and put the mappings into a_struct_field 
(where key is the imported column name and value is name_md5 of the inboxCC field) --->
<cfloop list="#form.fieldnames#" index="a_str_field_name">

	<!--- insert form field into mappings only if its name starts with 'frm_field_mapping_' and its value is not empty --->
	<cfif FindNoCase('frm_field_mapping_', a_str_field_name) GT 0 AND Len(form[a_str_field_name]) GT 0>
		<cfset a_str_col_name = Right(a_str_field_name, Len(a_str_field_name) - Len('frm_field_mapping_')) />
		<cfset a_struct_fields[a_str_col_name] = form[a_str_field_name] />
		
		<cfinvoke component="#application.components.cmp_person#" method="SaveUserPreference" returnvariable="a_bol_return">
			<cfinvokeargument name="section" value="import_data_field_mappings">
			<cfinvokeargument name="name" value="default_col_#hash(Ucase(a_str_col_name))#">
			<cfinvokeargument name="value" value="#form[a_str_field_name]#">
		</cfinvoke>
	</cfif>
	
</cfloop>

<!--- save the mappings into db --->
<cfinvoke component="#application.components.cmp_import#" method="SaveFieldMappings" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="jobkey" value="#form.frm_jobkey#">
	<cfinvokeargument name="fieldstructure" value="#a_struct_fields#">
</cfinvoke>

<!--- if not saved correctly show the mappings again --->
<cfif NOT stReturn.result>
	<cflocation url='index.cfm?action=FieldMappings&jobkey=#form.frm_jobkey#&ibxerrorno=#stReturn.error#'>
</cfif>

<!--- forward into preview data screen --->
<cflocation url='index.cfm?action=PreviewData&jobkey=#form.frm_jobkey#'>

