<!--- // 
	show resized image of entry ID
	// --->


<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfcontent type="image/gif" file="#request.a_str_img_1_1_pixel_location#" deletefile="no">
</cfif>	

<cfparam name="url.parentdirectorykey" default="" type="string">
<cfparam name="url.entrykey" default="" type="string">
<cfparam name="url.version" default="-1" type="numeric">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	version="#url.version#"
	 >
</cfinvoke>


<cfset q_query_file = a_struct_file_info.q_select_file_info />

<cfif q_query_file.recordcount IS 0>
	<!--- file does not exist / no access --->
	<cfcontent type="image/gif" file="#request.a_str_img_1_1_pixel_location#" deletefile="no">
</cfif>

<!--- try to deliver already generated thumbnail --->
<cfset a_tmp_thumbnail_file = request.a_str_storage_datapath & request.a_str_dir_separator & 'thumbnails' & request.a_str_dir_separator & q_query_file.storagefilename & '.jpg'>

<cfif FileExists(a_tmp_thumbnail_file)>
	<cfcontent file="#a_tmp_thumbnail_file#" deletefile="no" type="image/jpeg">
</cfif>

<cfset a_str_thumbnail_filename = request.a_str_temp_directory & createuuid()&".gif">
<cfset sFilename = q_query_file.storagepath&request.a_str_dir_separator&q_query_file.storagefilename>

<cfset a_str_arguments = "-size 140x140 "&sFilename&" -resize 140x140 +profile ""*"" -quality 30 "&a_str_thumbnail_filename>
<cfexecute timeout="30" name="convert" arguments="#a_str_arguments#"></cfexecute>

<!--- deliver file --->
<cfif FileExists(a_str_thumbnail_filename)>
	<cfcontent type="image/gif" file="#a_str_thumbnail_filename#" deletefile="yes">
<cfelse>
	<cfcontent type="image/gif" file="#request.a_str_img_1_1_pixel_location#" deletefile="no">
</cfif>