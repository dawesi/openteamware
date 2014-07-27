<cfquery name="q_select_newsletter_attachment">
SELECT
	filename,contenttype,filecontent
FROM
	newsletter_attachments
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>