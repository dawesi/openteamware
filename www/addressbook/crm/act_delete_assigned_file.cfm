<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_crmsales#" method="DeleteFileAttachedToUser" returnvariable="a_bol">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkey" value="#url.contactkey#">
	<cfinvokeargument name="directorykey" value="#url.directorykey#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<html>
	<head>
	</head>
	<body onLoad="javascript:history.go(-1);">
	
	</body>
</html>