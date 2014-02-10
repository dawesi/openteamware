<cfquery name="q_select_file_att_entrykey" datasource="#request.a_str_db_crm#">
SELECT
	entrykey
FROM
	newsletter_attachments
WHERE
	filekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filekey#">
	AND
	issuekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issuekey#">
;
</cfquery>