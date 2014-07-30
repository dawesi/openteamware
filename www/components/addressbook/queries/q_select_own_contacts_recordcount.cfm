<cfquery name="q_select_own_contacts_recordcount">
SELECT
	COUNT(id) AS count_id
FROM
	addressbook
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>