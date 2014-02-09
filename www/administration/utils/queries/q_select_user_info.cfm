<cfquery name="q_select_user_info" datasource="#request.a_str_db_users#">
SELECT
	firstname,surname,organization
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>