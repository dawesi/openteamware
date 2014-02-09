<cfquery name="q_delete_old_requests" datasource="#request.a_str_db_users#">
DELETE FROM
	webservices_enabled_applications
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">
	AND
	applicationkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">
	AND
	<!--- not yet started --->
	status = -1
;
</cfquery>