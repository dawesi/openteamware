<!--- //

	Module:		Main script for creating huge archive
	Function:	BackupWholeCompany
	Description:	
	

// --->
<cfsetting requesttimeout="20000">

<!--- execute the final script ... --->
<cfset a_str_sh_script = 'cd ' & a_str_backup_directory & chr(10) />

<!--- -C ' & a_str_backup_directory & '  --->
<cfset a_str_sh_script = a_str_sh_script & 'tar cvzfh ' & a_str_replication_file />

<cfloop list="#StructKeyList(stReturn.users)#" index="a_str_userkey">

	<cfif StructKeyExists(stReturn.users[a_str_userkey], 'directory')>
		
		<cfset a_str_current_user_dir = stReturn.users[a_str_userkey].directory>
		
		<cfset a_str_current_user_dir = ReplaceNoCase(a_str_current_user_dir, a_str_backup_directory, '', 'ONE') />
		<cfset a_str_current_user_dir = ReplaceNoCase(a_str_current_user_dir, '/', '', 'ONE') />
	
		<cfset a_str_sh_script = a_str_sh_script & ' ' & a_str_current_user_dir />
		
	<cfelse>
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="#a_str_userkey# directory does not exist" type="html">
			<cfdump var="#stReturn.users#">
			#a_str_userkey#
		</cfmail>
	</cfif>

</cfloop>


<cfset a_str_sh_script = a_str_sh_script & chr(10) />

<!--- now add the commands to delete the temp directories --->
<cfloop list="#StructKeyList(stReturn.users)#" index="a_str_userkey">

	<cfset a_str_sh_script = a_str_sh_script & 'rm ' & stReturn.users[a_str_userkey].directory & ' -R' & chr(10) />

</cfloop>

<cfset a_str_sh_file = request.a_str_temp_directory_local & request.a_str_dir_separator & createuuid() & '.sh' />

<cffile action="write" addnewline="no" file="#a_str_sh_file#" output="#a_str_sh_script#">

<cfset a_str_tar_output = request.a_str_temp_directory_local & request.a_str_dir_separator & createuuid() & '.log' />

<cfset LogMessage('sh file to execute: ' & a_str_sh_file) />

<cfexecute timeout="5000" name="sh" arguments="#a_str_sh_file#" outputfile="#a_str_tar_output#"></cfexecute>

<cfset LogMessage('sh file executed (done): ' & a_str_sh_file) />

<cfset a_str_tar_output = '' />

<cfif FileExists(a_str_tar_output)>
	<cffile action="read" file="#a_str_tar_output#" variable="a_str_tar_output">
</cfif>

