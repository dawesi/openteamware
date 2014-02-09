<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_content#" method="DeleteSignature" returnvariable="q_select_signatures">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">