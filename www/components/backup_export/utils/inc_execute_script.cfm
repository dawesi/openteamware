<cfsetting requesttimeout="20000">

<cfset variables.a_str_archive_name = variables.a_str_global_backup_dir & a_struct_load_userdata.query.companykey & request.a_str_dir_separator & a_struct_load_userdata.query.username & '_' & CreateUUID() & '.tar.gz'>

<cfif FileExists(variables.a_str_archive_name)>
	<!--- delete old files ... --->
	<cftry>
	<cffile action="delete" file="#variables.a_str_archive_name#">
	<cfcatch type="any">
	</cfcatch>
	</cftry>
</cfif>

<cfset a_str_sh_script = ''>

<cfif StructKeyExists(variables, 'a_str_cmd_make_links')>
	<!--- if we've got the script creating links for the storage ... use it ... --->
	<cfset a_str_sh_script = a_str_cmd_make_links>
</cfif>

<!--- the sh filename ... --->
<cfset variables.a_str_sh_file = request.a_str_temp_directory_local & request.a_str_dir_separator & createuuid() & '.sh'>

<!--- user-mode backup? --->
<cfif NOT arguments.companybackup>
	
	<!--- backup this user only ... --->	
	<cfset a_str_sh_script = a_str_sh_script & 'tar cvzfh ' & variables.a_str_archive_name &  ' ' & a_str_backup_directory & chr(10)>
	
	<!--- remove old backup directory --->
	<cfset a_str_sh_script = a_str_sh_script & 'rm ' & a_str_backup_directory & ' -R'>
	
	
	<!-- backup this user only and not a lot of users --->

	<cfset stReturn.script_name = a_str_sh_file />
	<cfset stReturn.user_backup_archive = variables.a_str_archive_name />
	
	<cfset LogMessage( 'sh file: ' & a_str_sh_file ) />
	<cfset LogMessage( 'archive name: ' & variables.a_str_archive_name ) />	

</cfif>

<cffile action="write" output="#a_str_sh_script#" file="#a_str_sh_file#">

<!--- debug mail ... --->
<cfif Len(trim(a_str_sh_script)) GT 0>
	
	<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="sh script backup" mimeattach="#a_str_sh_file#">#a_str_sh_script#</cfmail>--->
	
	<!--- execute
	
		a) fullfill backup (user mode)
		b) fullfill other operations (f.e. create links in company mode) 
		
		--->
	
	<cfexecute name="sh" arguments="#a_str_sh_file#" timeout="1000" variable="a_str_output"></cfexecute>

</cfif>