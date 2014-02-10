<cfquery name="q_update_principal_counter" datasource="#request.a_str_db_syncml#">
UPDATE
	sync4j_id
SET
	counter = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_princial_id#">
WHERE
	idspace = 'principal'
;
</cfquery>