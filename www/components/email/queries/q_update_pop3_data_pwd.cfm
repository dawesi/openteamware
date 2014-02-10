<!--- select old password --->
<cfquery name="q_select_original_password" datasource="#request.a_str_db_users#">
SELECT
	pop3password
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>


<cfquery name="q_update_pop3_data_pwd" datasource="#request.a_str_db_users#">
UPDATE
	pop3_data
SET
	pop3password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">,
	oldpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_original_password.pop3password#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>