<cfquery name="q_delete_session_key">
DELETE FROM
	sessionkeys
WHERE
	appname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationname#">
	AND
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">
;
</cfquery>