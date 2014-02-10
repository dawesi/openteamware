<cfquery name="q_delete_customer_contact" datasource="#request.a_str_db_users#">
DELETE FROM
	companycontacts
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>