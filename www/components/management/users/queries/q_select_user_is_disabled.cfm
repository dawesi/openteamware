<cfquery name="q_select_user_is_disabled" datasource="#request.a_str_db_users#">
SELECT
	allow_login
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>