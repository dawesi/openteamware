<cfquery name="q_select_productkey_of_user">
SELECT
	productkey,userid
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>