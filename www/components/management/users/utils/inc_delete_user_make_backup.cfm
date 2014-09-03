<!--- //

	Module:
	Action:		Delete a user and make backup
	Description:


// --->

<cfset a_str_backup_directory = getTempDirectory() & request.a_str_dir_separator & createUUID()>

<cfdirectory action="create" directory="#a_str_backup_directory#">

<cfset request.A_STR_DATAREP_LOG_COMPANYKEY  = a_str_company_key_of_user>
<cfset request.A_STR_DATAREP_LOG_USERKEY = arguments.entrykey>
<cfset request.A_STR_DATAREP_LOG_JOBKEY  = CreateUUID()>

<cfset a_struct_backup_user = CreateObject('component', '/components/backup_export/cmp_backup_export').BackupUserAccountData(userkey = arguments.entrykey, companybackup = false, basedirectory = a_str_backup_directory)>


<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="a_struct_export_securitycontext">
	<cfinvokeargument name="userkey" value="#arguments.actionfordata_userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_export_usersettings">
	<cfinvokeargument name="userkey" value="#arguments.actionfordata_userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_storage#" method="AddFile" returnVariable = "a_struct_addfile">
	<cfinvokeargument name="filename" value="Export Data User #q_select_user.username#.tar.gz">
	<cfinvokeargument name="location" value="#a_struct_backup_user.USER_BACKUP_ARCHIVE#">
	<cfinvokeargument name="description" value="">
	<cfinvokeargument name="contenttype" value="application/zipped">
	<cfinvokeargument name="directorykey" value="">
	<cfinvokeargument name="securitycontext" value="#a_struct_export_securitycontext#">
	<cfinvokeargument name="usersettings" value="#a_struct_export_usersettings#">
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="filesize" value="#FileSize(a_struct_backup_user.USER_BACKUP_ARCHIVE)#">
</cfinvoke>


<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="delete user export data" type="html">
<cfdump var="#arguments#">
<cfdump var="#a_struct_backup_user#">
<cfdump var="#a_struct_addfile#">
</cfmail>

