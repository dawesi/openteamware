<!--- insert a forwarding setting 

	scope: SetForwardingTarget
	--->
	
<!--- openTeamWare address --->
<cfparam name="SetForwardingTarget.InBoxccAddress" default="" type="string">

<!--- target address --->
<cfparam name="SetForwardingTarget.TargetAddress" default="" type="string">

<!--- leave copy? --->
<cfparam name="SetForwardingTarget.LeaveCopy" default="true" type="boolean">

<!--- delete existing items --->
<cfquery name="q_delete_redirects" debug datasource="inboxcc_courier" dbtype="ODBC" username="u_courier_insert" password="mailcheck">
DELETE FROM forwarding
WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SetForwardingTarget.InBoxccAddress#">;
</cfquery>

<cfquery name="q_insert_redirect" debug datasource="inboxcc_courier" dbtype="ODBC" username="u_courier_insert" password="mailcheck">
INSERT INTO forwarding
(id,destination,leavecopy)
values
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#SetForwardingTarget.InBoxccAddress#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#SetForwardingTarget.TargetAddress#">,
<cfif SetForwardingTarget.LeaveCopy is true>1<cfelse>0</cfif>);
</cfquery>

<cfhttp
	url="http://mail.openTeamWare.com/cgi-bin/generateprocmailconfig.pl?username=#urlencodedformat(lcase(SetForwardingTarget.InBoxccAddress))#"
	method="get"
	resolveurl="no"></cfhttp>