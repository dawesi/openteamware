<cfinclude template="../../login/check_logged_in.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfset a_struct_newvalues = StructNew()>
<cfset a_struct_newvalues.done = 1>

<cfinvoke component="#request.a_str_component_followups#" method="UpdateFollowup" returnvariable="a_bol_return">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">				
	<cfinvokeargument name="newvalues" value="#a_struct_newvalues#">
</cfinvoke>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">