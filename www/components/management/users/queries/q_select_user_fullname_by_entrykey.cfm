
<cfquery name="q_select_user_fullname_by_entrykey">
SELECT
	firstname,surname
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>