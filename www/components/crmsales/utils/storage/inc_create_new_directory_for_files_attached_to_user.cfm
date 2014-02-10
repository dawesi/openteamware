<!--- //

	create a new directory ...
	
	// --->
	
<cfset arguments.directoryname = trim(arguments.directoryname)>

<cfif Len(arguments.directoryname) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset sEntrykey = CreateUUID()>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stSecurityContext_upload_file = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stUserSettings_upload_file = a_struct_settings>

<cfinvoke
	component = "#application.components.cmp_storage#"   
	method = "CreateDirectory"   
	returnVariable = "a_bool_success"   
	securitycontext="#variables.stSecurityContext_upload_file#"
	usersettings="#variables.stUserSettings_upload_file#"
	directoryname="#arguments.directoryname#"
	parentdirectorykey="#arguments.parentdirectorykey#"
	entrykey="#sEntrykey#">
</cfinvoke>