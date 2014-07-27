<cfquery name="q_delete_ignore_item">
DELETE FROM
	newsletter_ignored_items
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
	AND
	contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#">
;
</cfquery>