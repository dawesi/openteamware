<!--- // load userdata // --->



<cfquery name="q_userlogin" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.username#">
	AND
	pwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.password#">
;
</cfquery>