<cfquery name="q_select_speedmail_folders_count" datasource="#request.a_str_db_email#">
SET ENABLE_SEQSCAN TO OFF;
SELECT
	COUNT(id) AS count_id
FROM
	folders
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">)
;
SET ENABLE_SEQSCAN TO ON;
</cfquery>