
<cfquery name="q_update_postfix_pwd" datasource="#request.a_str_db_mailusers#">
UPDATE
	users
SET
	clear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
; 
</cfquery>