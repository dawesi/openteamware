<cfquery name="q_select_article_watchers" datasource="#request.a_str_db_tools#">
SELECT
	DISTINCT(userkey)
FROM
	alert_on_change_postings
WHERE
	(threadkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.threadkey#">)
	AND NOT
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey_posting#">)
;
</cfquery>