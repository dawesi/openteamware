<cfquery name="q_delete_ignore_item" datasource="#request.a_str_db_crm#">
DELETE FROM
	newsletter_ignored_items
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
	AND
	contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#">
;
</cfquery>