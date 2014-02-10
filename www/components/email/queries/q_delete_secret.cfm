
<cfquery name="q_delete_secret" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	usersecret
WHERE
	(id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">)
;	
</cfquery>