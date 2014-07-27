<cfquery name="q_select_ignore_list_for_list">
SELECT
	*
FROM
	newsletter_ignored_items
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
;
</cfquery>