<cfquery name="q_select_connection_exists" datasource="#request.a_str_db_crm#">
SELECT
	COUNT(id) AS count_id
FROM
	connecteditems
WHERE
	projectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectkey#">
	AND
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
;
</cfquery>