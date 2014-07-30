<cfquery name="q_select_session_data">
SELECT
	struct_securitycontext,struct_usersettings
FROM
	sessionkeys
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">
;
</cfquery>