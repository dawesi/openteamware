<cfquery name="q_select_backup_account_exists" datasource="#request.a_str_db_backup#">
SELECT
	COUNT(id) AS count_id
FROM
	datarep_users
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	enabled = 1
;
</cfquery>