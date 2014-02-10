<cfquery name="q_select_speedmail_folder_exists" datasource="#request.a_str_db_email#">
SELECT
	COUNT(id) AS count_id
FROM
	folders
WHERE
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	AND
	foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
;
</cfquery>