<cfquery name="q_select_newsletter_attachment" datasource="#request.a_str_db_crm#">
SELECT
	filename,contenttype,filecontent
FROM
	newsletter_attachments
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>