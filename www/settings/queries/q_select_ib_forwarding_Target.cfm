<!--- //
	select the target of forwarding
	
	scope: SelectForwardingRequest
	
	// --->

<cfparam name="SelectForwardingRequest.emailadr" default="">	

<cfquery name="q_select_redirect" debug datasource="inboxcc_courier" dbtype="ODBC" username="u_courier_insert" password="mailcheck">
select destination,leavecopy from  forwarding
where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectForwardingRequest.emailadr#">;
</cfquery>