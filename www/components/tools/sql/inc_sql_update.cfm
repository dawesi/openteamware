<!--- //

	Module:		SQL
	Function.	UpdateRecord
	Description:Update a record
	

// --->


<cfquery name="q_update" datasource="#arguments.database#">
UPDATE
	#arguments.table#
SET
	<cfloop from="1" to="#ArrayLen(a_arr_data)#" index="ii">
		#a_arr_data[ii].fieldname# = <cfqueryparam cfsqltype="#a_arr_data[ii].cfmxtype#" value="#a_arr_data[ii].data#">
		
		<cfif ii LT ArrayLen(a_arr_data)>,</cfif>
	</cfloop>
WHERE
	(#arguments.primary_field# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_primary_field_value#">)
LIMIT
	1
;
</cfquery>

