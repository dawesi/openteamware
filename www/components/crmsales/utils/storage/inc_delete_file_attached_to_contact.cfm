<!--- //

	...
	
	// --->

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stSecurityContext_upload_file = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stUserSettings_upload_file = a_struct_settings>

<cfinvoke component="#application.components.cmp_storage#"
	method="DeleteFile"
	returnVariable = "a_bool_addfile">
	<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext_upload_file#">
	<cfinvokeargument name="usersettings" value="#variables.stUserSettings_upload_file#">
	<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
</cfinvoke>