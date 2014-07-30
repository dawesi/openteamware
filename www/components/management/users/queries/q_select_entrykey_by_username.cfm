<cfquery name="q_select_entrykey_by_username">
SELECT
	entrykey
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>