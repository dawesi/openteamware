<cfquery name="q_select_secretary_permission" datasource="#request.a_str_db_users#">
SELECT
	permission
FROM
	secretarydefinitions
WHERE
	secretarykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.secretary_userkey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.otheruser_userkey#">
;
</cfquery>