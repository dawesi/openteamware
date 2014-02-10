<cfquery name="q_select_signature" datasource="#request.a_str_db_users#">
SELECT
	signature
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>