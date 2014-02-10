<cfquery name="q_select_attended_users" datasource="#request.a_Str_Db_users#">
SELECT
	userkey,dt_created	
FROM
	secretarydefinitions
WHERE
	secretarykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>