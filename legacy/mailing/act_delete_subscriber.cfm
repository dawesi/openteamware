<!--- //

	delete a subscriber
	
	// --->
	
<cfinclude template="/login/check_logged_in.cfm">

<cfdump var="#url#">

<cfset a_Str_email_Adr = ''>

<cfinvoke component="#application.components.cmp_addressbook#" method="getContact" returnvariable="a_struct_contact">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.contactkey#">
</cfinvoke>

<cfset a_str_email_adr = a_struct_contact.q_Select_contact.email_prim>

<cfinvoke component="#request.a_str_component_newsletter#" method="CreateAddressbookIgnoreItem" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="listkey" value="#url.listkey#">
	<cfinvokeargument name="contactkey" value="#url.contactkey#">
	<cfinvokeargument name="emailadr" value="#a_Str_email_Adr#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">