<cfquery name="q_select_contacts">
SELECT
	*
FROM
	addressbook
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadDataRequest.userkey#">
;
</cfquery>