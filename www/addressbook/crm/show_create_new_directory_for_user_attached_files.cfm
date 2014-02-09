<cfinvoke component="#application.components.cmp_crmsales#" method="CreateNewFilesAttachedToUserDirectory" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkey" value="#url.contactkey#">
	<cfinvokeargument name="parentdirectorykey" value="#url.directorykey#">
	<cfinvokeargument name="directoryname" value="#url.directoryname#">
</cfinvoke>