

<cfquery name="q_select_login_logbook">
SELECT
	ip,dt_created,loginsection
FROM
	loginstat
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>