<cfquery name="q_select_other_setups" datasource="#request.a_str_db_tools#">
SELECT
	dt_lastmodified,install_name,program_id
FROM
	install_names
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">)
	AND NOT
	(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.computerid#">)
;
</cfquery>