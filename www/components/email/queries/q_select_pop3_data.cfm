

<cfquery name="q_select_pop3_data" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>