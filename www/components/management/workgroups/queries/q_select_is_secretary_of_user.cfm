<cfquery name="q_select_is_secretary_of_user" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	secretarydefinitions
WHERE
	secretarykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.secretary_userkey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.otheruser_userkey#">
;
</cfquery>