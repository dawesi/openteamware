<!--- // 

	update the password of a passwd entry (email account database)
	
	// --->
	
<cfquery name="q_update_ib_adr_password" datasource="#request.a_str_db_mailusers#">
UPDATE
	users
SET
	clear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3password#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_email_account.emailadr#">
;
</cfquery>