<cfquery name="q_select_userkey_exists">
SELECT
	COUNT(userid) AS count_id
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>