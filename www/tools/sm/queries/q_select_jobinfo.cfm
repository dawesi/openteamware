<cfquery name="q_select_jobinfo" datasource="#request.a_str_db_tools#">
SELECT
	asigned,
	aencrypted,
	subject,
	afrom,
	ato
FROM
	securemail_jobinfo
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userkey#">
	AND
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.jobkey#">
;
</cfquery>