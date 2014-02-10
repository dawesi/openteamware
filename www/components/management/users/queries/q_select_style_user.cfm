<cfquery name="q_select_style_user" datasource="#request.a_str_db_users#">
SELECT
	style
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>