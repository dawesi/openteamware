<!--- //

	Module:		Storage
	Description:Display thumbnails
	

// --->

<cfparam name="url.directorykey" type="string" default="">
<cfparam name="a_bool_publicview" type="boolean" default="false">
<cfparam name="url.startrow" default="1" type="numeric">

<cfif not a_bool_publicview>

	<cfset a_int_default_pagesize = GetUserPrefPerson('storage', 'pagesize_thumbnails', '9', '', false) />
	<cfparam name="request.a_int_thmpagesize" default="#a_int_default_pagesize#" type="numeric">
	<cfparam name="form.frm_pagesize" default="-1" type="numeric">
	
	<cfif form.frm_pagesize neq -1>
		<cfset request.a_int_thmpagesize=form.frm_pagesize>
	</cfif>
	
<cfelse>
	<cfset request.a_int_thmpagesize = 15 />
</cfif>

<cfset request.a_bool_msie = (FindNoCase("MSIE",CGI.HTTP_USER_AGENT) GT 0)>


<cfinvoke component="#application.components.cmp_tools#" method="GeneratePageScroller" returnvariable="a_str_page_scroller">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="current_url" value="#cgi.QUERY_STRING#">
	<cfinvokeargument name="url_tag_name" value="startrow">
	<cfinvokeargument name="step" value="#request.a_int_thmpagesize#">
	<cfinvokeargument name="recordcount" value="#a_struct_files.files.recordcount#">
	<cfinvokeargument name="current_record" value="#url.startrow#">
	<cfinvokeargument name="main_template_filename" value="">
</cfinvoke>

<cfoutput>#a_str_page_scroller#</cfoutput>

<cfif not request.a_bool_msie>
	<table border="0" cellspacing="0" cellpadding="10" width="500">
	
	  	<tr>
</cfif>

<cfset a_int_counter=0>

<cfoutput query="a_struct_files.files" startrow="#url.startrow#" maxrows="#request.a_int_thmpagesize#">
	<cfif not request.a_bool_msie>
		    <td valign="top" align="center" height="100%">
	<cfelse>
			    <div style="vertical-align:top;display:inline;width:160;">
	</cfif>
	<cfif not request.a_bool_msie>
					<table cellspacing="0" cellpadding="4" class="bb bt" height="100%" border="0" width="160">
	<cfelse>
					<table cellspacing="0" cellpadding="4" class="table_details" height="100%" border="0" width="160"
						style="margin:5px;">
	</cfif>
					  	<tr class="mischeader">
	
							<td style="font-weight:bold; ">
								#htmleditformat(shortenstring(a_struct_files.files.name, 14))#
							</td>
	
							<td align="right"  nowrap>
	<cfif a_bool_publicview>
		<cfset a_str_fileurl="#a_struct_files.files.name#">
		<cfset a_str_dirurl="#a_struct_files.files.name#/">
		<cfset a_str_thumbnailurl="#a_struct_files.files.name#?thumbnail=1">
		<cfset a_str_infourl="#a_struct_files.files.name#?info=1">
		<cfif request.a_bool_msie>
			<cfset a_str_onClick_action = 'return ShowPreviewTemplate(''#a_struct_files.files.name#?preview_box=1'');'>
		<cfelse>
			<cfset a_str_onClick_action = ''>
		</cfif>
	<cfelse>
		<cfset a_str_fileurl="default.cfm?action=ShowFile&entrykey=#a_struct_files.files.entrykey#">
		<cfset a_str_dirurl="default.cfm?action=ShowFiles&directorykey=#a_struct_files.files.entrykey#">
		<cfset a_str_thumbnailurl="dsp_show_file_thumbnail.cfm?entrykey=#a_struct_files.files.entrykey#">
		<cfset a_str_infourl="default.cfm?action=FileInfo&entrykey=#a_struct_files.files.entrykey#">
		<cfset a_str_onClick_action = ''>
	</cfif>
	<cfswitch expression="#a_struct_files.files.filetype#">
		<cfcase value="special">
		</cfcase>
		<cfcase value="directory">
			<cfif specialtype lte 0 >
				<cfif not a_bool_publicview>
					<a href="default.cfm?action=EditFolder&entrykey=#a_struct_files.files.entrykey#&currentdir=#url.directorykey#"><img src="/images/si/pencil.png" class="si_img" />
					</a>
					<a href="default.cfm?action=DeleteFolder&entrykey=#a_struct_files.files.entrykey#&parentdirectorykey=#url.directorykey#&currentdir=#url.directorykey#"><img src="/images/si/delete.png" class="si_img" /></a>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="file">
			<nobr>
				<cfif not a_bool_publicview>
					<a class="nl" href="default.cfm?action=EditFile&entrykey=#a_struct_files.files.entrykey#&currentdir=#url.directorykey#"><img src="/images/si/pencil.png" class="si_img" /></a>
				</cfif>
				<a class="nl" href="#a_str_infourl#"><img src="/images/si/information.png" class="si_img" /></a>
				<cfif not a_bool_publicview>
					<!---<a href="default.cfm?action=MailFile&entrykey=#a_struct_files.files.entrykey#&currentdir=#url.directorykey#"><img width="15" height="11" alt="folder" src="/images/btn_folder_inbx2.gif" border="0" align="absmiddle"></a>
					|--->
					<a class="nl" href="default.cfm?action=DeleteFile&frm_entrykey=#a_struct_files.files.entrykey#&frm_parentdirectorykey=#url.directorykey#&currentdir=#url.directorykey#"><img src="/images/si/delete.png" class="si_img" /></a>
				</cfif>
			</nobr>
		</cfcase>
	</cfswitch>
							</td>
					  	</tr>
			 		 	<tr>
							<td align="center" colspan="2">
							
<cfswitch expression="#a_struct_files.files.filetype#">
	<cfcase value="special">
		<a href="#a_str_dirurl#"><img align="absmiddle"  width=140 height=100 alt="folder" border="0" src="/storage/images/smallfolder.gif"></a>
	</cfcase>
	<cfcase value="directory">
		<a href="#a_str_dirurl#"><img align="absmiddle"  width=140 height="100" alt="folder" border="0" src="/storage/images/smallfolder.gif"></a>
	</cfcase>
	<cfcase value="file">
		
		<cfif (FindNoCase("image/", a_struct_files.files.contenttype) GT 0)>
			<a onClick="#a_str_onClick_action#" href="#a_str_fileurl#"><img alt="#htmleditformat(a_struct_files.files.description)#" src="#a_str_thumbnailurl#" width="160" hspace="5" vspace="5" border="0" align="absmiddle"></a>
		<cfelse>
			<a href="#a_str_fileurl#"><img src="/storage/images/icon_txt.gif" width="160" hspace="5" vspace="5" border="0" align="absmiddle"></a>
		</cfif>
	</cfcase>
</cfswitch>
			
							</td>
			  			</tr>
			  			<tr>
							<td class="addinfotext" align="center" colspan="2">
								#lsdateformat(a_struct_files.files.dt_created, "dd.mm.yy")#
								-
								#byteConvert(a_struct_files.files.filesize)#
								<cfif Len(a_struct_files.files.description) GT 0>
								<br />
								#htmleditformat(shortenstring(a_struct_files.files.description, 30))#
								</cfif>
							</td>
			  			</tr>
					</table>
	<cfif not request.a_bool_msie>
				</td>
		<cfset a_int_counter=a_int_counter+1>
		<cfif a_int_counter mod 3 is 0>
	  		</tr>
			<tr>
		</cfif>
	<cfelse>
		</div>
	</cfif>  
</cfoutput>

<cfif not request.a_bool_msie>
  		</tr>
	</table>
</cfif>
<br>

<cfoutput>#a_str_page_scroller#</cfoutput>


