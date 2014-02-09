<!--- //

	create an alias
	
	// --->
	
<cfdump var="#form#">

<cfset a_str_email_alias = form.frmaliasusername&'@'&form.frmdomain>

<cfinvoke component="/components/email/cmp_accounts" method="CreateAlias" returnvariable="stReturn">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="aliasaddress" value="#a_str_email_alias#">
	<cfinvokeargument name="destinationaddress" value="#form.frmusername#">
</cfinvoke>
		
<cflocation addtoken="no" url="#ReturnRedirectURL()#">