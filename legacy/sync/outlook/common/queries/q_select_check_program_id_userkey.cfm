<cfquery name="q_select_check_program_id_userkey" datasource="#request.a_str_db_Sync#">
SELECT
	COUNT(userkey) AS count_id
FROM
	install_names
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">
	AND
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PROGRAM_ID#">
;
</cfquery>