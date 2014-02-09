<!--- //

	add link
	
	// --->

<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_tools#" method="CreateElementLink" returnvariable="ab">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="source_servicekey" value="#form.frm_source_servicekey#">
	<cfinvokeargument name="source_entrykey" value="#form.frm_source_entrykey#">
	<cfinvokeargument name="source_displayname" value="#form.frm_source_name#">
	<cfinvokeargument name="dest_servicekey" value="#form.frm_dest_servicekey#">
	<cfinvokeargument name="dest_entrykey" value="#form.frm_dest_entrykey#">
	<cfinvokeargument name="dest_displayname" value="#form.frm_dest_name#">
	<cfinvokeargument name="comment" value="#form.frm_comment#">
	<cfinvokeargument name="connection_type" value="#form.frm_conn_string#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">