
<cfquery name="q_delete_external_accounts" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	emailaccount
WHERE
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>