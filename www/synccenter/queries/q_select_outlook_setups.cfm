<cfquery name="q_select_outlook_setups" datasource="#request.a_str_db_tools#">
SELECT
	dt_lastmodified,install_name,version
FROM
	install_names 
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
ORDER BY
	dt_lastmodified DESC
;
</cfquery>