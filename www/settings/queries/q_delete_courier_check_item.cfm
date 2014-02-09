<!--- //



	remove from pop3 checker ...

	

	// --->

<cfparam name="DeleteEmailAdrRequest.emailadr" type="string" default="">



<cfquery name="q_delete_courier_check_item" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	emailaccount
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserid#">
AND
	accountid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeleteEmailAdrRequest.id#">
;
</cfquery>