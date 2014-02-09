<!--- //

	remove all out-dated pop3 collector items
	
	// --->
	
<cfquery name="q_select_external_email_accounts" datasource="#request.a_str_db_users#">
SELECT
	emailadr,userkey
FROM
	pop3_data
WHERE
	origin = 1
;
</cfquery>

<cfdump var="#q_select_external_email_accounts#">