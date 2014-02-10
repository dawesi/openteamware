

<cfquery name="q_select_quota" datasource="#request.a_str_db_mailusers#">
SELECT
	maxsize,cursize
FROM
	quota
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>