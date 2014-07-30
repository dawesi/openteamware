<cfquery name="q_select_user_is_disabled">
SELECT
	allow_login
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>