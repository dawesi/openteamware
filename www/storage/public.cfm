<!--- //

	Module:        Storage
	Description:   Show public folders
	

// --->

<cfparam name="url.orderby" type="string" default="name">			  
<cfparam name="url.ordertype" type="string" default="">
<cfparam name="client.publicshare_password" type="string" default="">
<cfparam name="form.frm_password" type="string" default="">

<cfparam name="url.info" default="0" type="numeric">
<cfparam name="url.thumbnail" default="0" type="numeric">
<cfparam name="url.view" default="0" type="numeric">
<cfparam name="url.download" default="0" type="numeric">

<!--- preview: the image itself --->
<cfparam name="url.preview_image" default="0" type="numeric">
<!--- the box --->
<cfparam name="url.preview_box" default="0" type="numeric">
<cfparam name="url.preview_width" type="numeric" default="800">
<cfparam name="url.preview_height" type="numeric" default="600">

<cfset variables.a_cmp_users = application.components.cmp_user>

<cftry>
<cfquery name="q_insert_public_traffic" datasource="#request.a_str_db_tools#">
INSERT INTO
	publicshares_traffic
	(
	ip,
	dt_created,
	query_string,
	script_name,
	userkey,
	http_referer
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(cgi.QUERY_STRING, 1, 250)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.PATH_INFO#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">
	)
;
</cfquery>
<cfcatch type="any"> </cfcatch>
</cftry>

<!---<cfinclude template="../login/check_logged_in.cfm">--->
<cfif len(form.frm_password) gt 0 >
	<cfset client.publicshare_password=form.frm_password>
</cfif>

<cfinclude template="/common/scripts/script_utils.cfm">
<html>
	<head>
		<script type="text/javascript" src="/common/js/storage.js"></script>
		<script type="text/javascript" src="/common/js/display.js"></script>
		<cfinclude template="../style_sheet.cfm">
		<title>Storage</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	
	<body>
		
		
		
		<!--- Interesting Content types --->
		<cfset a_arr_contenttypes=ArrayNew(1)>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'text/html')>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'text/plain')>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'applicaton/pdf')>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'application/x-zip-compressed')>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'application/msexcel')>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'application/mspowerpoint')>
		<cfset temp=ArrayAppend(a_arr_contenttypes,'application/msword')>
		
				
		<cfset a_int_idx1=0>
		<cfset a_int_idx2=1>
		<cfset lc=0>
		<cfset a_arr_path_arguments=ArrayNew(1)>
		<cfset a_str_url_string=urldecode(urlencodedformat(CGI.PATH_INFO,'iso-8859-1'),'utf-8')>
		<!---<cfset a_str_url_string= cgi.PATH_INFO>--->
		<cfloop condition="lc le 100">
			<cfset a_int_idx1=Find("/",a_str_url_string,a_int_idx2)>
			<cfif a_int_idx1 gt 0>
			
			  	<cfset a_int_idx2=Find("/",a_str_url_string,a_int_idx1+1)>
			  	<cfif a_int_idx2 eq 0>
			    	<cfset a_int_idx2 = len(a_str_url_string)+1>
			    	<cfset lc=100>
			  	</cfif>
			  	<cfset a_str_value=mid(a_str_url_string,a_int_idx1+1,a_int_idx2-a_int_idx1-1)>
			  	<cfset temp=ArrayAppend(a_arr_path_arguments,a_str_value)>
			  	<cfset lc=lc+1>
			<cfelse>
			  	<cfset lc=101>
			</cfif>
		</cfloop>
<!---		
		<cfif Arraylen(a_arr_path_arguments)  gt 0 and Right(CGI.PATH_INFO,1) neq "/">
			<cfset temp=ArrayAppend(a_arr_path_arguments,'')>
		</cfif>
--->		
		<cfif Arraylen(a_arr_path_arguments)  eq 2>
			<cflocation url="#a_arr_path_arguments[ArrayLen(a_arr_path_arguments)]#/" addtoken="no">
		</cfif>		
		<cfif Arraylen(a_arr_path_arguments) lte 2>
			Invalid Request	
			<cfabort>
		</cfif>
		
		
		
		
		<cfif Arraylen(a_arr_path_arguments) eq 3>
			<cfset a_str_username=a_arr_path_arguments[2] & "@" & a_arr_path_arguments[1]>
			
			<cfinvoke component = "#variables.a_cmp_users#"   
					method="getentrykeyfromusername"   
					returnvariable="a_str_userkey">  
				 <cfinvokeargument name="username" value="#a_str_username#">
			</cfinvoke>
			
			<cfif Len(a_str_userkey) IS 0>
				<cfabort>
			</cfif>
			
			<cfinvoke component="#variables.a_cmp_users#" method="GetAllowLoginStatus" returnvariable="a_bol_allow_login">
				<cfinvokeargument name="userkey" value="#a_str_userkey#">
			</cfinvoke>
						
			<cfif NOT a_bol_allow_login>
				This user has been disabled.
				<cfabort>
			</cfif>
			
			<cfif a_str_userkey IS 'FF1B4FBD-D35C-E1D0-A4D9318E050315C2'>
				<div style="padding:6px;" class="bb">
					<a href="http://www.artoflife.tv/" target="_blank"><img src="/images/external/artoflife/artoflife_logo.gif" border="0" alt="Art of Life"/></a>
				</div>
			<cfelse>
				<cfinclude template="../menu/dsp_inc_top_header.cfm">
				
				<cfoutput>
					<div  style="padding:20px;padding-top:5px;">
					<font style="font-weight:bold;"><img src="/images/menu/img_world_19x16.gif" align="absmiddle" vspace="4" hspace="4"> Sie befinden sich in den &ouml;ffentlichen Ordnern von #a_str_username#</font>
					<br>
				</cfoutput>

			</cfif>
			
			<cfinvoke   
				component = "#application.components.cmp_storage#"   
				method = "ListAllPublicFolders"   
				returnVariable = "a_query_folders"
				userkey="#a_str_userkey#"
				 >  
			</cfinvoke>
						
			<cfset a_query_userkeys=QueryNew('userkey')>
			<cfset a_bool_publicview=true>
			<cfset a_query_displayfiles=a_query_folders>
			
			<cfinclude template="dsp_display_files.cfm">
		
		</cfif>

		
		<cfif ArrayLen(a_arr_path_arguments) gt 3>
			<cfset a_str_username=a_arr_path_arguments[2] & "@" & a_arr_path_arguments[1]>
			<cfinvoke   
				component = "#variables.a_cmp_users#"   
				method="getentrykeyfromusername"   
				returnvariable="a_str_userkey"
				 >  
				 <cfinvokeargument name="username" value="#a_str_username#">
			</cfinvoke>
			
			<cfif Len(a_str_userkey) IS 0>
				<cfabort>
			</cfif>
			
			<cfinvoke component="#variables.a_cmp_users#" method="GetAllowLoginStatus" returnvariable="a_bol_allow_login">
				<cfinvokeargument name="userkey" value="#a_str_userkey#">
			</cfinvoke>
						
			<cfif NOT a_bol_allow_login>
				This user has been disabled.
				<cfabort>
			</cfif>			
			
			<!--- special treatment for artoflife --->
			<cfif a_str_userkey IS 'FF1B4FBD-D35C-E1D0-A4D9318E050315C2'>
				<div style="padding:6px;" class="bb">
					<a href="http://www.artoflife.tv/" target="_blank"><img src="/images/external/artoflife/artoflife_logo.gif" border="0" alt="Art of Life"/></a>
				</div>
			<cfelse>
				<cfinclude template="../menu/dsp_inc_top_header.cfm">
				
				<cfoutput>
					<div  style="padding:20px;padding-top:5px;">
					<font style="font-weight:bold;"><img src="/images/menu/img_world_19x16.gif" align="absmiddle" vspace="4" hspace="4"> Sie befinden sich in den &ouml;ffentlichen Ordnern von #a_str_username#</font>
					<br>
				</cfoutput>

			</cfif>			

			<!---<cfoutput>
				<div  style="padding:20px;padding-top:5px;">
				<font style="font-weight:bold;"><img src="/images/menu/img_world_19x16.gif" align="absmiddle" vspace="4" hspace="4"> Sie befinden sich in den &ouml;ffentlichen Ordnern von #a_str_username#</font>
				<br>
			</cfoutput>				 --->
			
			<cfset request.securitycontext=structnew()>
			<cfset request.usersettings=StructNew()>
			<!--- Get current directorykey --->
			<cfset current_directorykey="">
			<cfoutput>
				<cfset a_str_url="./">
				<cfloop index="a_int_dummyindex" from="4" to="#arraylen(a_arr_path_arguments)#">
					<cfset a_str_url=a_str_url&"../">
				</cfloop>
				<a href="#a_str_url#"><b><img src="/storage/images/smallfolder.gif" align="absmiddle" border="0" vspace="4" hspace="4"> Home - &Uuml;bersicht</b></a>
			</cfoutput>
			<!---  Get public root dirs from user --->
			<cfinvoke   
				component = "#application.components.cmp_storage#"   
				method = "ListAllPublicFolders"   
				returnVariable = "a_query_folders"
				userkey="#a_str_userkey#"
				 >  
			</cfinvoke>
			<cfset found=false>
			<cfloop query="a_query_folders">
				<cfif a_query_folders.name eq a_arr_path_arguments[3]>
					<cfset current_directorykey=a_query_folders.entrykey>
					<cfinvoke   
						component = "#application.components.cmp_storage#"   
						method = "PublicGetDirectoryInformation"   
						returnVariable = "a_query_publicdirectory"   
						directorykey = "#current_directorykey#"
					></cfinvoke>
					
					

					<cfif len(a_query_publicdirectory.publicshare_password) gt 0 >
						<cfif not client.publicshare_password eq a_query_publicdirectory.publicshare_password>
							<cfoutput>
								<form action="?" method="post">
									#GetLangVal('cm_wd_password')#:
									<input type="password" name="frm_password" value="">
									<input class="btn" type="submit" value="#htmleditformat(getlangval('sto_wd_submit'))#">
									
								</form>
								<cfabort>
							</cfoutput>
						</cfif>
					</cfif>
					<cfset found=true>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not found >
				<br><br>
				<b>Path not found</b>
				<cfabort>
			</cfif>
			<cfoutput>
				<cfset a_str_url="./">
				<cfloop index="a_int_dummyindex" from="5" to="#arraylen(a_arr_path_arguments)#">
					<cfset a_str_url=a_str_url&"../">
				</cfloop>
				&nbsp;
				#request.a_str_dir_separator#
				&nbsp;
				
				<a href="#a_str_url#">
					<img src="/storage/images/smallfolder.gif" align="absmiddle" border="0" vspace="4" hspace="4"> #a_arr_path_arguments[3]#
				</a>
			</cfoutput>
			<cfloop index="a_int_index" from="4" to="#arraylen(a_arr_path_arguments)#">
				<cfif  len(a_arr_path_arguments[a_int_index]) gt 0>
					
					<cfinvoke   
						component = "#application.components.cmp_storage#"   
						method = "FindPublicFolder"   
						parentdirectorykey="#current_directorykey#"
						directoryname="#a_arr_path_arguments[a_int_index]#"
						returnVariable = "a_query_folder"
					 >  
					</cfinvoke>
					<cfif a_query_folder.recordcount lte 0 >
						<!--- Nothing found, try to find a File --->
						<cfoutput></cfoutput>
						<cftry>
							<cfinvoke   
								component = "#application.components.cmp_storage#"   
								method = "PublicFindFile"   
								directorykey="#current_directorykey#"
								filename="#a_arr_path_arguments[a_int_index]#"
								returnVariable = "a_query_file"
								download="true"
							 >  
							</cfinvoke>
							<cfcatch type="Any">
								<cfif cfcatch.errorcode eq 99>
									
									
									Traffic Limit Reached.
									<cfabort>
									
								
								</cfif>
								<cfrethrow>
							</cfcatch>
						</cftry>

						<cfif  a_query_file.recordcount lte 0 >
							<cfthrow detail="Public File or Directory not found" errorcode=201>
						</cfif>
						<cfif url.info gt 0>
							<br><br>
							<cfoutput>
								
								<table class="table_details" cellpadding="4" cellspacing="0" border="0">
									<tr>
										<td class="field_name">
											#getlangval('sto_wd_filename')#
										</td>
										<td style="font-weight:bold; ">
											#htmleditformat(a_query_file.name)#
										</td>
									</tr>
									<tr>
										<td align="right">
											#getlangval('sto_wd_description')#
										</td>
										<td>
											#htmleditformat(a_query_file.description)#
										</td>
									</tr>
									<tr>
										<td align="right">
											#getlangval('sto_wd_contenttype')#
										</td>
										<td>
											#htmleditformat(a_query_file.contenttype)#
										</td>
									</tr>
									<tr>
										<td align="right">
											#getlangval('sto_wd_filesize')#
										</td>
										<td>
											#ByteConvert(a_query_file.filesize)#
										</td>
									</tr>
								</table>
							</cfoutput>
							<cfabort>
						</cfif>
						
						
						<!--- display the preview image --->
						<cfif url.preview_image IS 1>
							<!--- display preview --->
							<cfset a_str_newfilename = Hash(a_query_file.storagepath & a_query_file.storagefilename)>
							
							<cfset a_str_thumbnail_filename = "#request.a_str_temp_directory_local##request.a_str_dir_separator##a_str_newfilename#">
							<cfset sFilename = "#a_query_file.storagepath##request.a_str_dir_separator##a_query_file.storagefilename#">
							
							<cfset myImage = CreateObject("Component",'/components/tools/cmp_image') />

							<!--- open the image to resize --->
							<cfset myImage.readImage(path = sFilename, givenfileext = ListLast(a_query_file.name, '.')) />
							<!--- resize the image to a specific width and height --->
							<cfset myImage.scalePixels(600, 460) />
							<!--- output the image in JPG format --->
							<cfset myImage.writeImage(a_str_thumbnail_filename, "jpg", 75) />
							
							<!---<cfset a_str_arguments = "-size 140x140 "&sFilename&" -resize 140x140 +profile ""*"" -quality 65 "&a_str_thumbnail_filename>
							<cfexecute timeout="30" name="convert" arguments="#a_str_arguments#"></cfexecute>--->
							
							<!--- delive the thumbnail directly --->
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
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_thumbnail_filename#">
								)
							;
							</cfquery>	
							
							<cflocation addtoken="yes" url="/tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat('image/jpeg')#&filename=#urlencodedformat(a_query_file.name)#&app=#urlencodedformat(application.applicationname)#">
							
						</cfif>
						
						<!--- display the preview box --->
						<cfif url.preview_box IS 1>
						
							<cfset a_str_img_file = GetFileFromPath(cgi.PATH_INFO)>
							
							<cfsavecontent variable="a_str_info_box">
							<cfoutput>
							<div style="padding:4px;text-align:center;">
								<b>#htmleditformat(a_query_file.name)#</b>
								<cfif Len(a_query_file.description) GT 0>
									<br>
									#htmleditformat(a_query_file.description)#
								</cfif>
							</div>
							<div>
								<img src="#a_str_img_file#?preview_image=1" width="600" alt="#GetLangVal('cm_wd_close_btn_caption')#" height="460" border="0" style="border:gray solid 1px;cursor:hand;" onClick="CloseSimpleModalDialog();">
							</div>
							<div style="padding:4px;text-align:center; ">
							<form style="margin:0px; ">
								<input type="button" class="btn" value="#GetLangVal('cm_wd_close_btn_caption')#" onClick="CloseSimpleModalDialog();"/>
								<input type="button" class="btn" value="#GetLangVal('cm_wd_download')# (#byteconvert(a_query_file.filesize)#)" onClick="window.open('#a_str_img_file#', '_blank');"/>
							</form>
							</div>
							</cfoutput>
							</cfsavecontent>
							
							<cfset a_str_newfilename = CreateUUID() & '.html'>
							<cfset a_str_info_filename = request.a_str_temp_directory & request.a_str_dir_separator & a_str_newfilename>
							<cfset sEntrykey_dl = CreateUUID()>
							
							<cffile action="write" addnewline="no" charset="iso-8859-1" file="#a_str_info_filename#" output="#a_str_info_box#">
							
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
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_info_filename#">
								)
							;
							</cfquery>	
							
							<cflocation addtoken="yes" url="/tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat('text/html')#&filename=#urlencodedformat('info.html')#&app=#urlencodedformat(application.applicationname)#">
														
						</cfif>
						
						<cfif url.thumbnail gt 0 >
							<cfset url.download=1>
							
							<cfset a_tmp_thumbnail_file = request.a_str_storage_datapath & request.a_str_dir_separator & 'thumbnails' & request.a_str_dir_separator & a_query_file.storagefilename & '.jpg'>

							<!--- generate thumbnail file --->
							<cfif FileExists(a_tmp_thumbnail_file)>
								<cfcontent file="#a_tmp_thumbnail_file#" deletefile="no" type="image/jpeg">
							</cfif>
							
							<!---<cfset a_str_newfilename = createUUID()>--->
							<cfset a_str_newfilename = Hash(a_query_file.storagepath & a_query_file.storagefilename)>
							
							<cfset a_str_thumbnail_filename = "#request.a_str_temp_directory_local##request.a_str_dir_separator##a_str_newfilename#">
							<cfset sFilename = "#a_query_file.storagepath##request.a_str_dir_separator##a_query_file.storagefilename#">
							
							<!--- // check if thumbnail exists // --->
							<cfif FileExists(a_str_thumbnail_filename)>
							
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
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_thumbnail_filename#">
									)
								;
								</cfquery>	
								
								<cflocation addtoken="yes" url="/tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(a_query_file.contenttype)#&filename=#urlencodedformat(a_query_file.name)#&app=#urlencodedformat(application.applicationname)#">
															
							</cfif>
							
							<cfset myImage = CreateObject("Component",'/components/tools/cmp_image') />

							<!--- open the image to resize --->
							<cfset myImage.readImage(path = sFilename, givenfileext = ListLast(a_query_file.name, '.')) />
							<!--- resize the image to a specific width and height --->
							<cfset myImage.scalePixels(160, 140) />
							<!--- output the image in JPG format --->
							<cfset myImage.writeImage(a_str_thumbnail_filename, "jpg", 75) />
							
							<!---<cfset a_str_arguments = "-size 140x140 "&sFilename&" -resize 140x140 +profile ""*"" -quality 65 "&a_str_thumbnail_filename>
							<cfexecute timeout="30" name="convert" arguments="#a_str_arguments#"></cfexecute>--->
							
							<!--- delive the thumbnail directly --->
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
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_thumbnail_filename#">
								)
							;
							</cfquery>	
							
							<cflocation addtoken="yes" url="/tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(a_query_file.contenttype)#&filename=#urlencodedformat(a_query_file.name)#&app=#urlencodedformat(application.applicationname)#">
															
						<cfelse>
							<!--- Copy File to temporary position --->
							<cfset a_str_newfilename=createUUID()>
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
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_query_file.storagepath##request.a_str_dir_separator##a_query_file.storagefilename#">
								)
							;
							</cfquery>	
							
							
							<cflocation addtoken="yes" url="/tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(a_query_file.contenttype)#&filename=#urlencodedformat(a_query_file.name)#&app=#urlencodedformat(application.applicationname)#">
								
							<!---<cffile action="COPY" source="#a_query_file.storagepath##request.a_str_dir_separator##a_query_file.storagefilename#" destination="#request.a_str_temp_directory##request.a_str_dir_separator##a_str_newfilename#">--->
						</cfif>
						
						<cfif find("image",a_query_file.contenttype)>
							<!---  OR (FindNoCase('.jpg', a_query_file.filename) GT 0) --->
							<cfif not url.download eq 1 and not url.view eq 1>
								<!--- Retreive next and prev item --->
								<cfinvoke   
									component = "#application.components.cmp_storage#"   
									method = "Public_ListFilesAndDirectories"   
									returnVariable = "a_struct_files"   
									directorykey = "#a_query_file.parentdirectorykey#"
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
									<cfif a_query_file.entrykey eq a_struct_files.files.entrykey>
										<cfset a_str_prev_key=a_str_last_key>
										<cfset a_str_prev_name=a_str_last_name>
										<cfset a_bool_found=true>
									</cfif>
									<cfset a_str_last_name=a_struct_files.files.name>
									<cfset a_str_last_key=a_struct_files.files.entrykey>
								</cfloop>	
								<cfoutput>
									<cfif len(a_str_prev_key) gt 0  or len(a_str_next_key) gt 0 >
										<br>
										<div class="bb bt" align="center" style="padding:4px; ">
										<cfif len(a_str_prev_key) gt 0 >
											<a href="#a_str_prev_name#">
												#getlangval('sto_wd_prev')#
											</a>
											&nbsp;|&nbsp;&nbsp;
										</cfif>
										<cfif len(a_str_next_key) gt 0 >
											<a href="#a_str_next_name#">
												<img src="/images/arrows/img_green_button_16x16.gif" align="absmiddle" vspace="4" hspace="4" border="0"> #getlangval('sto_wd_next')#
											</a>
										</cfif>
										</div>
										<br>		
									</cfif>
								</cfoutput>
								<cfoutput>
									<br>
									<div align="center">
									<img class="b_all" src="#a_arr_path_arguments[arraylen(a_arr_path_arguments)]#?view=1">
									<br>
									<a href="#a_arr_path_arguments[arraylen(a_arr_path_arguments)]#?download=1"><img src="/images/menu/img_tree_download_19x16.gif" align="absmiddle" border="0" vspace="3" hspace="3">Download der Datei starten ...</a>
									</div>
								</cfoutput>
								<cfabort>
							</cfif>
							<cfif url.download eq 1>
								<!---
									<cfheader name="Content-disposition" value="attachement; filename=""#a_query_file.name#""">
								--->
							<cfelse>
								<cfheader name="Content-disposition" value="filename=""#a_query_file.name#""">
							</cfif>
						<cfelse>
							<cfheader name="Content-disposition" value="attachment;filename=""#a_query_file.name#""">
						</cfif>
						
						<cfif url.download eq 1>
							<cflocation addtoken="yes" 
								url="/tools/download/dl.cfm?source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(a_query_file.contenttype)#&filename=#urlencodedformat(a_query_file.name)#&app=#urlencodedformat(application.applicationname)#">
						<cfelse>
							<cftry>
				  			<cfcontent type="#a_query_file.contenttype#" 
								file="#request.a_str_temp_directory##request.a_str_dir_separator##a_str_newfilename#" 
								deletefile="yes">
							<cfcatch>
								Server überlastet. Bitte die Seite <a href="javascript:document.location.reload()">neuladen</a>.
							</cfcatch>
							</cftry>
						</cfif>
						<cfabort>
					<cfelse>
						<cfoutput>
							<cfset a_str_url="./">
							<cfloop index="a_int_dummyindex" from="#a_int_index+2#" to="#arraylen(a_arr_path_arguments)#">
								<cfset a_str_url=a_str_url&"../">
							</cfloop>
							&nbsp;
							#request.a_str_dir_separator#
							&nbsp;
							<a href="#a_str_url#">
								 #a_arr_path_arguments[a_int_index]#
							</a>
						</cfoutput>

					</cfif>
					<cfset current_directorykey=a_query_folder.entrykey>
				</cfif>
			</cfloop>
			<cfinvoke   
				component = "#application.components.cmp_storage#"   
				method = "Public_ListFilesAndDirectories"   
				returnVariable = "a_struct_files"
				directorykey="#current_directorykey#"
				 >  
			</cfinvoke>
			<cfinvoke   
				component = "#application.components.cmp_storage#"   
				method = "PublicGetDirectoryInformation"   
				returnVariable = "a_query_publicdirectory"   
				directorykey = "#current_directorykey#"
			>
			<cfif len(url.orderby ) gt 0 >
				<cfset url.orderby=REReplaceNoCase(url.orderby,"[^a-z]","","all")>
				<cfset url.ordertype=REReplaceNoCase(url.ordertype,"[^a-z]","","all")>
				<cfquery dbtype="query" name="a_struct_files.files">
					SELECT 
						*,upper(#url.orderby#) as sortcol
					FROM 
						a_struct_files.files
					ORDER BY
						filetype,
						sortcol #url.ordertype#
				</cfquery>
			</cfif>

			<br>
			<cfoutput>
				#a_query_publicdirectory.description#<br>
			</cfoutput>

			<cfset a_bool_publicview=true>
			<cfif a_query_publicdirectory.displaytype eq 1 >
			
				<!--- display status msg on top ... --->
				<div id="id_div_thumbnails_waiting_loading" style="padding:10px;text-align:center;">
					<div style="color:white;padding:4px;background-color:#CC0000;width:600px;font-weight:bold; " align="center">
						<cfoutput>#GetLangVal('sto_ph_please_wait_loading_thumbnails')#</cfoutput>
					</div>
				</div>
				<cfinclude template="dsp_showfiles_thumbnails.cfm">
				
				<cfsavecontent variable="a_str_js">
					function DoRemoveWaitingStatusMsg() {
						var obj1 = findObj('id_div_thumbnails_waiting_loading');
						obj1.style.display = 'none';
						}
					addEventEx(window, "load", DoRemoveWaitingStatusMsg);
				</cfsavecontent>
				
				<cfscript>
					AddJSToExecuteAfterPageLoad('', a_str_js);
				</cfscript>
				
			<cfelse>
				<cfset a_query_displayfiles=a_struct_files.files>
				<cfinclude template="dsp_display_files.cfm">
			</cfif>
		
		</cfif>
		
		</div>
	</body>
</html>

