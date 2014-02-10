
<cfquery name="q_select_hased_login" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	AND
	MD5(pwd) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pwd#">
;
</cfquery>