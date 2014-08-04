<cfquery name="q_select_basic_user_data">
SELECT
	firstname,surname,username
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>