<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_content#" method="SetDefaultSignature" returnvariable="q_select_signatures">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="format" value="#url.format#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">