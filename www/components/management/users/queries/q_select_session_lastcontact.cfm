

<cfquery name="q_select_session_lastcontact">
SELECT
	dt_lastcontact
FROM
	sessionkeys
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>