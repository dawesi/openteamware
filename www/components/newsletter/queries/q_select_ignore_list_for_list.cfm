<cfquery name="q_select_ignore_list_for_list" datasource="#request.a_str_db_crm#">
SELECT
	*
FROM
	newsletter_ignored_items
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
;
</cfquery>