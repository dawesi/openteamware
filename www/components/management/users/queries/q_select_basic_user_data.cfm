<cfquery name="q_select_basic_user_data" datasource="#request.a_str_db_users#">
SELECT
	firstname,surname,username,identificationcode
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>