<cfinclude template="/login/check_logged_in.cfm">

<!--- entrykey of list --->
<cfparam name="url.entrykey" type="string">

<cfinvoke component="#request.a_str_component_newsletter#" method="MakeProfileInvisible" returnvariable="ab">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
</cfinvoke>

<cflocation addtoken="no" url="default.cfm?action=ShowWelcome">