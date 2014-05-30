<cfquery name="q_select_file_att_entrykey">
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