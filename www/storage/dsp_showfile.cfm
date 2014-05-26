<!--- //

	Module:		Storage
	Action:		ShowFile
	Description:	
	

// --->

<cfparam name="url.parentdirectorykey" default="" type="string">
<cfparam name="url.entrykey" default="" type="string">
<cfparam name="url.version" default="-1" type="numeric">
<cfparam name="url.displayimage" default="false" type="boolean">
<cfparam name="url.fullsize" default="false" type="boolean">
<cfparam name="url.download" default="false" type="boolean">

<cfsetting requesttimeout="20000">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	version="#url.version#"
	download=true
	 >
</cfinvoke>

<cfif NOT a_struct_file_info.result>
	File not found.
	<cfexit method="exittemplate">
</cfif>
	
<cfset q_query_file = a_struct_file_info.q_select_file_info />
	

<cfif Find('image',q_query_file.contenttype ) gt 0  and not url.displayimage>
	<!--- Retreive next and prev item --->
	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "ListFilesAndDirectories"   
		returnVariable = "a_struct_files"   
		directorykey = "#q_query_file.parentdirectorykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		>
	</cfinvoke> 
	 
	<cfquery dbtype="query" name="a_struct_files.files">
		SELECT 
			*
		FROM 
			a_struct_files.files
		WHERE
			contenttype like '%image%'
	</cfquery>
	
	<cfset a_bool_found=false>
	<cfset a_str_prev_key="">
	<cfset a_str_prev_name="">
	<cfset a_str_next_key="">
	<cfset a_str_next_name="">
	<cfset a_str_last_key="">
	<cfset a_str_last_name="">
	
	<cfloop query="a_struct_files.files">
		<!---
		<cfoutput>
			#url.entrykey# = #a_struct_files.files.entrykey#<br>
		</cfoutput>
		--->
		<cfif a_bool_found>
			<cfset a_str_next_key=a_struct_files.files.entrykey>
			<cfset a_str_next_name=a_struct_files.files.name>
			<cfbreak>
		</cfif>
		<cfif url.entrykey eq a_struct_files.files.entrykey>
			<cfset a_str_prev_key=a_str_last_key>
			<cfset a_str_prev_name=a_str_last_name>
			<cfset a_bool_found=true>
		</cfif>
		<cfset a_str_last_name=a_struct_files.files.name>
		<cfset a_str_last_key=a_struct_files.files.entrykey>
	</cfloop>	
	<cfoutput>
	
			<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_image_display'))>
			<br>
			
			<a href="index.cfm?action=showfiles&directorykey=#q_query_file.parentdirectorykey#">#GetLangVal('sto_ph_back_to_the_directory')# ...</a><br>

		<cfif len(a_str_prev_key) gt 0 >
			<a href="index.cfm?action=showfile&entrykey=#a_str_prev_key#">
				#getlangval('sto_wd_prev')#
			</a>
		</cfif>
		<cfif len(a_str_next_key) gt 0 >
			<a href="index.cfm?action=showfile&entrykey=#a_str_next_key#">
				<img src="/images/arrows/img_green_button_16x16.gif" align="absmiddle" vspace="4" hspace="4" border="0"> #getlangval('sto_wd_next')#
			</a>
		</cfif>
		<br>		
		<!---Picturetype: #q_query_file.contenttype#<br>--->
		<!---<cfdump var="#q_query_file#">--->
		<a target="_blank" href="index.cfm?#ReplaceOrAddURLParameter(QUERY_STRING,"displayimage",true)#"><img align="absmiddle" class="b_all" src="index.cfm?#ReplaceOrAddURLParameter(QUERY_STRING,"displayimage",true)#"></a>
		<br>
		<a href="index.cfm?#ReplaceOrAddURLParameter(ReplaceOrAddURLParameter(QUERY_STRING,"displayimage",true),"download",true)#"><img src="/images/menu/img_tree_download_19x16.gif" align="absmiddle" border="0" vspace="3" hspace="3">#GetLangVal('cm_wd_download')# ...</a><br>
	</cfoutput>
	
<cfelse>

	<cfif Find('image',q_query_file.contenttype ) lte 0  and find('pdf',q_query_file.contenttype) lte 0 >
		<cfheader name="Content-Disposition" value="attachment;filename=#q_query_file.filename#">
	</cfif>
	
	<cfif Find('image',q_query_file.contenttype ) gt 0   >
		<cfif url.fullsize>
			<cfcontent type="#q_query_file.contenttype#" file="#q_query_file.storagepath##request.a_str_dir_separator##q_query_file.storagefilename#">
		<cfelse>
			
			<cfset a_str_newfilename = CreateUUID()>
			<cfset a_str_thumbnail_filename = request.a_str_temp_directory_local&a_str_newfilename&".gif">
			<cfset sFilename = q_query_file.storagepath&request.a_str_dir_separator&q_query_file.storagefilename>

			<cfoutput>
				#sFilename#
				--> #a_str_thumbnail_filename#
			</cfoutput>

<!---
			<cfset a_str_arguments = "-size 400x400 "&sFilename&" -resize 400x400 +profile ""*"" -quality 10 "&a_str_thumbnail_filename>
			<cfexecute timeout="30" name="convert" arguments="#a_str_arguments#"></cfexecute>
--->
			<cffile action="copy" source="#sFilename#" destination="#a_str_thumbnail_filename#">
			<!--- deliver file --->
			<cfif url.download>
				<cflocation addtoken="yes" url="../tools/download/dl.cfm?source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(q_query_file.contenttype)#&filename=#urlencodedformat(q_query_file.filename)#&app=#urlencodedformat(application.applicationname)#&local=true">
				<cfabort>
			</cfif>
			<cfif FileExists(a_str_thumbnail_filename)>
				<cftry>
					<cfcontent type="image/gif" file="#a_str_thumbnail_filename#" deletefile="yes">
					<cfcatch>
						Image Error.
					</cfcatch>
				</cftry>
			<cfelse>
				<cfcontent type="image/gif" file="#request.a_str_img_1_1_pixel_location#" deletefile="no">
			</cfif>
		</cfif>
	<cfelse>

	
		<cfset a_str_newfilename=createUUID()>
		<!--- save the file ... --->
<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="download file storage" type="html">
		<cfdump var="#url#">
		<cfdump var="#q_query_file#">
		
		
		</cfmail>		--->
		<cfset sEntrykey_dl = CreateUUID()>
		
		<cfquery name="q_insert_dl_link" datasource="#request.a_str_db_tools#">
		INSERT INTO
			download_links
			(
			entrykey,
			filelocation
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey_dl#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_query_file.storagepath##request.a_str_dir_separator##q_query_file.storagefilename#">
			)
		;
		</cfquery>
		
		<!--- redirect ... --->
		<cflocation addtoken="yes" url="../tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(q_query_file.contenttype)#&filename=#urlencodedformat(q_query_file.filename)#&app=#urlencodedformat(application.applicationname)#">
		
		<cfabort>
		
	</cfif>
</cfif>
