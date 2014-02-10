<!--- //

	Component:	SQL
	Function:	AnalyzeTableStructure
	Description:Get datatypes of table
	

	
	
	HINT: Is bound to MYSQL at the moment ...
	
// --->

<!--- use mySQL syntax to select fields information ... --->
<cfquery name="q_select_raw_structure" datasource="#arguments.database#">
SHOW COLUMNS
FROM
	#arguments.table#
;
</cfquery>

<!--- ignore some internal field ... --->
<cfquery name="q_select_raw_structure" dbtype="query">
SELECT
	*
FROM
	q_select_raw_structure
WHERE
	NOT field IN ('id')
;
</cfquery>

<cfset stReturn.q_select_raw_structure = q_select_raw_structure />

<!--- create structure with information ... --->
<cfloop query="q_select_raw_structure">
	
	<cfset a_int_row = q_select_raw_structure.currentrow />
	<cfset a_str_cfmx_type = 'cf_sql_varchar' />
	<cfset a_int_maxlength = 0 />
	
	<cfset a_arr_fields[a_int_row] = StructNew() />
	<cfset a_arr_fields[a_int_row].fieldname = q_select_raw_structure.field />
	<!--- <cfset a_arr_fields[a_int_row].null = q_select_raw_structure.null />
	<cfset a_arr_fields[a_int_row].dbtype = q_select_raw_structure.type /> --->
	
	<!--- check the fields ... --->
	<cfif q_select_raw_structure.type IS 'datetime'>
		<cfset a_str_cfmx_type = 'cf_sql_timestamp' />
	</cfif>
	
	<cfif q_select_raw_structure.type IS 'date'>
		<cfset a_str_cfmx_type = 'cf_sql_date' />
	</cfif>
	
	<cfif FindNoCase('varchar', q_select_raw_structure.type) GT 0>
		<cfset a_str_cfmx_type = 'cf_sql_varchar' />
	</cfif>
	
	<cfif FindNoCase('int', q_select_raw_structure.type) GT 0>
		<cfset a_str_cfmx_type = 'cf_sql_integer' />
	</cfif>
	
	<cfif FindNoCase('text', q_select_raw_structure.type) GT 0>
		<cfset a_str_cfmx_type = 'cf_sql_longvarchar' />
	</cfif>
	
	<cfset a_arr_fields[a_int_row].cfmxtype = a_str_cfmx_type />
	<!--- <cfset a_arr_fields[a_int_row].maxlength = a_int_maxlength /> --->

	<!--- will be filled with data ... --->
	<cfset a_arr_fields[a_int_row].data = '' />
	<!--- by default, no field value has been provided, ignore field ... --->
	<cfset a_arr_fields[a_int_row].provided = false />

</cfloop>

