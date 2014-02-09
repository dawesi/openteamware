<!--- //

	

	select a possible forwarding element from the forwarding table

	

	// --->

	

<cfparam name="SelectEmailForwardingRequest.emailadr" type="string" default="">



<cfquery name="q_select_forwarding" datasource="#request.a_str_db_mailusers#">

SELECT destination,leavecopy FROM forwarding

WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectEmailForwardingRequest.emailadr#">;

</cfquery>