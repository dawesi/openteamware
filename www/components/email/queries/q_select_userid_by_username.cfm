<cfquery name="q_select_userid_by_username" datasource="#request.a_str_db_users#">
SELECT
	userid
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>