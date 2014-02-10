<cfquery name="q_update_quota" datasource="#request.a_str_db_mailusers#">
UPDATE
	quota
SET
	maxsize = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.quota#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>