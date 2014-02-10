<cfquery name="q_delete_all_filters" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	filter
WHERE
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>