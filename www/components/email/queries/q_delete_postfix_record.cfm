<cfquery name="q_delete_postfix_record" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	users
WHERE
	address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>