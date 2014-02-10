<!--- //

	prepare the template
	
	// --->
	
<!--- write to request.a_str_temp_directory_local ...
		
			logical path is otw_temp --->

<cfset a_str_file_content = q_select_template_properties.content>


<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, 'https://www.openTeamWare.com/common/js/fckeditor/editor/', '', 'ALL')>
<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, 'http://www.openTeamWare.com/common/js/fckeditor/editor/', '', 'ALL')>
<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, 'https://www.openTeamWare.com/common/js/fckeditor', '', 'ALL')>

<cfif FindNoCase('<cfoutput>', a_str_file_content) IS 0>
	<!--- add cfoutput --->
	<cfset a_str_file_content = '<cfoutput>' & a_str_file_content & '</cfoutput>'>
</cfif>

<cfif FindNoCase('<cfprocessingdirecti', a_str_file_content) IS 0>
	<!--- add utf-8 prcessing directive --->
	<cfset a_str_file_content = '<cfprocessingdirective pageencoding="UTF-8">' & a_str_file_content>
</cfif>

<!---<cflog text="replacing data in template arguments.section : #arguments.section#" type="Information" log="Application" file="ib_replace">--->

<cfif CompareNoCase(arguments.section, 'emails') IS 0>
	<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '="##', '="####', 'ALL')>
	<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '<br/>', '<br>', 'ALL')>
	<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, 'or=##', 'or=####', 'ALL')>
	<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '-COLOR: ##', 'o-COLOR: ####', 'ALL')>
	
<cfelse>
	<!--- test ... --->
	<!---<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '=##', '=####', 'ALL')>--->
</cfif>

<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '<p>&nbsp;</p>', '', 'ALL')>
<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '<p>&nbsp;&nbsp;</p>', '', 'ALL')>

<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '<tbody>', '', 'ALL')>
<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, '</tbody>', '', 'ALL')>
<cfset a_str_file_content = ReplaceNoCase(a_str_file_content, 'class="MsoNormal"', ' ', 'ALL')>

<cffile action="write" output="#a_str_file_content#" charset="utf-8" file="#sFilename#">