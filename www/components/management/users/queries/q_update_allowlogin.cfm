
<cfif arguments.allowlogin IS 1>
	<cfset a_int_status = 1>
<cfelse>
	<cfset a_int_status = -1>
</cfif>

<cfquery name="q_update_allowlogin" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	allow_login = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_status#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>