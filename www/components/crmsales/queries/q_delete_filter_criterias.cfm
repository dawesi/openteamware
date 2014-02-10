<cfquery name="q_delete_filter_criterias" datasource="#request.a_str_db_tools#">
DELETE FROM
	crmfiltersearchsettings
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	viewkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.viewkey#">
;
</cfquery>