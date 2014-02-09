<!--- //

	label or de-label message
	
	// --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">
	
<cfparam name="url.id" type="numeric" default="0">
<cfparam name="url.folder" type="string" default="">
<cfparam name="url.account" type="string" default="#request.stSecurityContext.myusername#">
<cfparam name="url.redirect" type="string" default="#ReturnRedirectURL()#">
<cfparam name="url.status" type="numeric" default="0">


<cfinvoke component="/components/email/cmp_tools" method="setmessagestatus" returnvariable="a_str_result">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="foldername" value="#url.folder#">
	<cfinvokeargument name="uid" value="#url.id#">
	<cfinvokeargument name="status" value="#url.status#">
</cfinvoke>

<!--- redirect --->
<cflocation addtoken="no" url="#url.redirect#">