<cfquery name="q_update_session_data">
UPDATE
	sessionkeys
SET
	struct_securitycontext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_securitycontext#">,
	struct_usersettings = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_usersettings#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">
;
</cfquery>