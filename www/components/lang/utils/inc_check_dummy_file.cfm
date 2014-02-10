<!--- //

	Component:	Lang
	Description:Create temp file which does not exist
	
	Header:		

	
	
	Write an empty default include file
	
// --->

<cfset a_str_temp_file = request.a_str_temp_directory_local & 'dummmy_template.cfm' />

<cfif NOT FileExists(a_str_temp_file)>
	<cffile action="write" addnewline="no" file="#a_str_temp_file#" output=" ">
</cfif>

