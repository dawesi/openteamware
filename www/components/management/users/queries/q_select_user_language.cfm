<cfquery name="q_select_user_language">
SELECT
	defaultlanguage
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>