<!--- //

	Module:		SimpleSelectAttLoadFilesOfDirectory
	Action:		
	Description:Select files stored in a certain directory
	

// --->

<cfparam name="url.directorykey" type="string">
<cfparam name="url.input_name" type="string" default="frmFilesentrykeys">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "ListFilesAndDirectories"   
	returnVariable = "a_struct_files"   
	directorykey = "#url.directorykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>  

<cfset q_select_files = a_struct_files.files />

<cfquery name="q_select_files" dbtype="query">
SELECT
	entrykey,filesize,name,contenttype
FROM
	q_select_files
WHERE
	filetype = 'file'
ORDER BY
	name
;
</cfquery>

<cfif q_select_files.recordcount GT 0>
	<ul class="temp_list_files">
		<cfoutput query="q_select_files">
		<li>
			<input type="checkbox" class="noborder" value="#htmleditformat(q_select_files.entrykey)#" name="#url.input_name#" style="width:auto;" />
			<a href="/storage/?action=ShowFile&amp;entrykey=#q_select_files.entrykey#" target="_blank">#application.components.cmp_tools.GetImagePathForContentType(q_select_files.contenttype)# #htmleditformat(q_select_files.name)#</a> (#ByteConvert( q_select_files.filesize )#)
		</li>
		</cfoutput>
	</ul>
<cfelse>
	<p><cfoutput>#si_img( 'cross' )# #GetLangVal( 'cm_ph_no_data_found' )#</cfoutput></p>
</cfif>
		