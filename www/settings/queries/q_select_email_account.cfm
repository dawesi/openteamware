<!--- //



	select all properties of an email account

	

	// --->

<cfparam name="SelectEmailAccountRequest.id" type="numeric" default="0">

	

<cfquery name="q_select_email_account">
SELECT
	*
FROM
	pop3_data
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
	AND
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectEmailAccountRequest.id#">
;
</cfquery>