<cfquery name="q_select_recipient">
SELECT
	contactkey,recipient_source,listkey,entrykey,recipient
FROM
	newsletter_recipients
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.listkey)#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recipientkey#">
;
</cfquery>