<!--- // select redirect entry for this address


	scope: GetRedirectPropertiesRequest
	
	
	// --->
	
<!--- email address --->
<cfparam name="GetRedirectPropertiesRequest.EmailAddress" default="" type="string">


<cfquery name="q_select_redirect" debug datasource="inboxcc_courier" dbtype="ODBC" username="u_courier_insert" password="mailcheck">
SELECT destination,leavecopy FROM forwarding
WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetRedirectPropertiesRequest.EmailAddress#">;
</cfquery>