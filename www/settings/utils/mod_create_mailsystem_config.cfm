<!--- //

	create the mailsystem config
	
	// --->

<cfparam name="attributes.username" type="string" default="#request.stSecurityContext.myusername#">

<!---<cfhttp
	url="http://mail.openTeamWare.com/cgi-bin/generateprocmailconfig.pl?username=#urlencodedformat(lcase(attributes.username))#"
	method="get"
	resolveurl="no"></cfhttp>--->
	
<cfinvoke component="/components/email/cmp_filter" method="CreateProcmailconfig" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>