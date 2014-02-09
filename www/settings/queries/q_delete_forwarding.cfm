<!--- //

	

	delete a possible forwarding element from the forwarding table

	

	// --->

	

<cfparam name="DeleteEmailAdrRequest.emailadr" type="string" default="">

<cfquery name="q_delete_forwarding" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	forwarding
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeleteEmailAdrRequest.emailadr#">
;
</cfquery>