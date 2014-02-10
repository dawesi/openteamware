<cfquery name="q_delete_running_job" datasource="#request.a_str_db_backup#">
DELETE FROM
	datarep_runningjobs
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_jobkey#">
;
</cfquery>