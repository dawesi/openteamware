<cfquery name="q_select_userkey_from_sessionkey" datasource="#request.a_str_db_users#">
SELECT
	userkey
FROM
	sessionkeys
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">
;
</cfquery>