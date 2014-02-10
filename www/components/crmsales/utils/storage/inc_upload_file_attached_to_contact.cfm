<!--- //

	Module:		CRMSales
	Function.	AddFileAttachedToUser
	Description: 
	

// --->

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stSecurityContext_upload_file = stReturn />

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stUserSettings_upload_file = a_struct_settings />

<cfinvoke component="/components/tools/cmp_vc" method="checkfileforvirus" returnvariable="a_struct_virus_check">
	<cfinvokeargument name="filename" value="#arguments.file_on_disk#">
</cfinvoke>

<cfset stReturn.v = a_struct_virus_check />

<cfset sEntrykey_file = CreateUUID()>

<cfinvoke component="#application.components.cmp_storage#"
	method="AddFile"
	returnVariable = "a_bool_addfile">
	<cfinvokeargument name="filename" value="#arguments.filename#">
	<cfinvokeargument name="location" value="#arguments.file_on_disk#">
	<cfinvokeargument name="description" value="#arguments.description#">
	<cfinvokeargument name="categories" value="#arguments.categories#">
	<cfinvokeargument name="contenttype" value="#arguments.contenttype#">
	<cfinvokeargument name="directorykey" value="#arguments.directorykey#">
	<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext_upload_file#">
	<cfinvokeargument name="usersettings" value="#variables.stUserSettings_upload_file#">
	<cfinvokeargument name="entrykey" value="#sEntrykey_file#">
	<cfinvokeargument name="filesize" value="#arguments.filesize#">
	<cfinvokeargument name="forceoverwrite" value="true">
</cfinvoke>


