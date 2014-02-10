<cfquery name="q_delete_assignment" datasource="#request.a_str_db_tools#">
DELETE FROM
	assigned_items
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
;
</cfquery>