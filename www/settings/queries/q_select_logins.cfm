<!--- // select log logins

	scope: request
	
	// --->

<cfquery name="q_select_logins" datasource="#request.a_str_db_log#">
SELECT
	ip,dt_created AS dt,loginsection
FROM
	loginstat
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
ORDER by
	dt DESC
LIMIT
	50
;
</cfquery>