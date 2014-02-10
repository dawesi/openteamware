

<cfquery name="q_select_email_address_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(entrykey) AS count_account
FROM
	pop3_data
WHERE
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>