<!--- //

	Module:        Import
	Description:   Insert field mappings
	

// --->
<cfquery name="q_insert">
	INSERT INTO importfieldmappings 
		(
			jobkey,
			ibxfield_md5,
			importfieldname
		)
	VALUES 
	<cfset a_arr_struct_keys = StructKeyArray(arguments.fieldstructure)>
	<cfloop index="a_int_loop" from="1" to="#ArrayLen(a_arr_struct_keys)#" >
		<cfset a_str_import_field_name = a_arr_struct_keys[a_int_loop]>
	    (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldstructure[a_str_import_field_name]#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_import_field_name#">
		)
		<cfif a_int_loop NEQ ArrayLen(a_arr_struct_keys)>
		,
		</cfif>
  	</cfloop>
</cfquery>

