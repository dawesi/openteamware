<cfquery name="q_select_owner_userkey">
SELECT
	userkey
FROM
	addressbook
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>