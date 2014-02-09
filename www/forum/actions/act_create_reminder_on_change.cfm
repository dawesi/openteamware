<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.threadkey" type="string" default="">
<cfparam name="url.forumkey" type="string" default="">

<cfset a_cmp_forum = CreateObject('component', request.a_str_component_forum)>

<cfinvoke component="#a_cmp_forum#" method="CreateOnChangeAlert" returnvariable="a_bol_return_2">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="forumkey" value="#url.forumkey#">
	<cfinvokeargument name="threadkey" value="#url.threadkey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#&alerthasbeencreated=true">