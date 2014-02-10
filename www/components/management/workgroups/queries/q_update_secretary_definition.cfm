<cfquery name="q_update_secretary_definition" datasource="#request.a_str_db_users#">
UPDATE
	secretarydefinitions
SET
	permission = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permission#">
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
;
</cfquery>