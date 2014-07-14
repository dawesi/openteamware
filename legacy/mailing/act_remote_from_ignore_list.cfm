<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#request.a_str_component_newsletter#" method="DeleteIgnoreItem" returnvariable="a_bol_return">
	<cfinvokeargument name="listkey" value="#url.listkey#">
	<cfinvokeargument name="contactkey" value="#url.contactkey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">