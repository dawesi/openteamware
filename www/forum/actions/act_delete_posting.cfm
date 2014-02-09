<cfinclude template="/login/check_logged_in.cfm">

<cfset a_cmp_forum = CreateObject('component', request.a_str_component_forum)>

<cfinvoke component="#a_cmp_forum#" method="DeletePosting" returnvariable="a_bol_return_2">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="forumkey" value="#url.forumkey#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">