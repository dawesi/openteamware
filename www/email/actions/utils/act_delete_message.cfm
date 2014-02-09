<!--- //

	Module:		E-Mail
	Action:		doPostBackgroundAction
	Description:Delete an email
	

// --->

<cfparam name="a_struct_parse.redirect" type="boolean" default="true">
		
<!--- delete a message ... --->
<cfinvoke component="#application.components.cmp_email_tools#" method="DeleteMessageOrMoveToTrash" returnvariable="ab">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="foldername" value="#a_struct_parse.data.foldername#">
	<cfinvokeargument name="uid" value="#a_struct_parse.data.uid#">
</cfinvoke>

<!--- <cfinvoke component="#application.components.cmp_email_tools#" method="GetRedirectTarget" returnvariable="a_str_redirect_url">
	<cfinvokeargument name="session_scope" value="#session#">
	<cfinvokeargument name="md5_querystring" value="#a_struct_parse.data.mbox_md5#">
	<cfinvokeargument name="foldername" value="#a_struct_parse.data.foldername#">
	<cfinvokeargument name="uid" value="#a_struct_parse.data.uid#">
	<cfinvokeargument name="openfullcontent" value="#a_struct_parse.data.openfullcontent#">
</cfinvoke> --->

<!--- call redirect? --->
<cfif a_struct_parse.redirect>

	<!--- <script type="text/javascript">
		var a_target = '<cfoutput>#JsStringFormat(a_str_redirect_url)#</cfoutput>';
		
	</script> --->
</cfif>

