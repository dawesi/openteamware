<!--- //



	delete an email address from the pop3_data

	

	// --->



<cfparam name="DeleteEmailAdrRequest.id" type="numeric" default="0">



<cfquery name="q_delete_emailadr" datasource="#request.a_str_db_users#">
DELETE FROM
	pop3_data
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
AND
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#DeleteEmailAdrRequest.id#">
;
</cfquery>