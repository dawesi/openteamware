<!--- 

	delete a forwarding entry
	
	--->
	
<cfparam name="DeleteForwardingRequest.emailaddress" type="string" default="">

<cfif Len(DeleteForwardingRequest.emailaddress) IS 0>
	<cfexit method="exittemplate">
</cfif>


<cfquery name="q_delete_forwarding" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	forwarding
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeleteForwardingRequest.emailaddress#">
;
</cfquery>