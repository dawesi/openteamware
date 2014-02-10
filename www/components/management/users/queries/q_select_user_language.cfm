<cfquery name="q_select_user_language" datasource="#request.a_str_db_users#">
SELECT
	defaultlanguage
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>