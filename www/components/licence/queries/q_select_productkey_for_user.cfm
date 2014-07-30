<cfquery name="q_select_productkey_for_user">
SELECT
	productkey
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>