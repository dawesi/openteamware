<!--- //

	Module:		EMail
	Action:		ShowMessage
	Description:new way of displaying attachments
	

// --->

<cfif q_select_real_attachments.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<br />
 
<cfsavecontent variable="a_str_content">
<table class="table table-hover">
	<tr class="tbl_overview_header">
	<cfoutput>
		<td>
		
		</td>
		<td>
			#getlangval("cm_wd_name")# (#getlangval("cm_wd_size")#)
		</td>
		<td>
			#getlangval("cm_wd_action")#
		</td>
	</cfoutput>
	</tr>
	<cfoutput query="q_select_real_attachments">
		<tr>
			<td align="center">
				&nbsp;
			</td>
			<td>
				
				#application.components.cmp_tools.GetImagePathForContentType(q_select_real_attachments.contenttype)#
				
				<a style="font-weight:bold;" href="index.cfm?action=loadattachment&filename=#urlencodedformat(q_select_real_attachments.afilename)#&contenttype=#urlencodedformat(q_select_real_attachments.contenttype)#&mailbox=#urlencodedformat(url.mailbox)#&id=#url.id#&partid=#q_select_real_attachments.contentid#&userkey=#urlencodedformat(url.userkey)#" target="_blank">#CheckZeroString(q_select_real_attachments.afilename)#</a>
				
		 	 	(#byteconvert(q_select_real_attachments.asize)# )
		 	 	
		 	 	<cfif ListFindNoCase("image/pjpeg,image/jpeg,image/gif,image/jpg,image/x-png", q_select_real_attachments.contenttype, ",") gt 0
		  			AND (Len(q_select_real_attachments.tempfilename) gt 0)>
					<cfset sFilename = GetFileFromPath(q_select_real_attachments.tempfilename)>
						<br /> 
						<a target="_blank" href="index.cfm?action=loadattachment&filename=#urlencodedformat(q_select_real_attachments.afilename)#&contenttype=#urlencodedformat(q_select_real_attachments.contenttype)#&mailbox=#urlencodedformat(url.mailbox)#&id=#url.id#&partid=#q_select_real_attachments.contentid#&userkey=#urlencodedformat(url.userkey)#"><img class="b_all" width="140" vspace="6" hspace="6" src="show_load_saved_att_img.cfm?thumbnail=0&amp;src=#urlencodedformat(sFilename)#&contenttype=#urlencodedformat(q_select_real_attachments.contenttype)#&userkey=#urlencodedformat(url.userkey)#" /></a>
			
		 	 	</cfif>
		 	 	
		 	 	<cfif (q_select_real_attachments.contenttype IS 'application/ms-tnef') AND FileExists( q_select_real_attachments.tempfilename )>
			 	 	
			 	 	<!--- try to init stream --->
			 	 	<cftry>
			 	 	<cfset a_input_stream = createObject( 'java', 'net.freeutils.tnef.TNEFInputStream').init( q_select_real_attachments.tempfilename ) />
			 	 	<cfset a_tnef = createObject( 'java', 'net.freeutils.tnef.TNEF' ).init() />
			 	 	
			 	 	<cfset a_str_target_dir = request.a_str_temp_directory & 'winmail_dat/' & CreateUUID() />
			 	 	
			 	 	<cfdirectory action="create" directory="#a_str_target_dir#">
			 	 	
			 	 	<!--- extract content --->
			 	 	<cfset a_extract = a_tnef.extractContent( a_input_stream, a_str_target_dir ) />
			 	 	
			 	 	<!--- find files --->
			 	 	<cfdirectory action="list" directory="#a_str_target_dir#" name="q_select_winmail">
					
						<div style="padding:20px" class="mischeader">
						<b>Content of this winmail.dat - file</b>
						<br /><br />
						<cfloop query="q_select_winmail">
							
							<cfset a_str_downloadkey = CreateUUID() />
							
							<cfquery name="q_insert_dl_link" datasource="#request.a_str_db_tools#">
							INSERT INTO
								download_links
								(
								filelocation,
								entrykey
								)
							VALUES
								(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_winmail.directory#/#q_select_winmail.name#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_downloadkey#">
								)
							;
							</cfquery>
							
							
							<a target="_blank" href="/tools/download/dl.cfm?dl_entrykey=#a_str_downloadkey#&filename=#urlencodedformat( q_select_winmail.name )#&app=#urlencodedformat(application.applicationname)#&#client.urltoken#">#si_img( 'page_attach' )# #htmleditformat( q_select_winmail.name )#</a>
							<br />
	
							
						</cfloop>
						
					</div>		 	 	
			 	 	<cfcatch type="any">
					</cfcatch>
			 	 	</cftry>
					
				</cfif>
		 	 	
			</td>
			<td style="line-height:20px;">
				<!--- <a href="index.cfm?action=loadattachment&filename=#urlencodedformat(q_select_real_attachments.afilename)#&contenttype=#urlencodedformat(q_select_real_attachments.contenttype)#&mailbox=#urlencodedformat(url.mailbox)#&id=#url.id#&partid=#q_select_real_attachments.contentid#&userkey=#urlencodedformat(url.userkey)#" target="_blank">#GetLangVal('cm_wd_download')#</a>
				<br /> --->
				<cfswitch expression="#q_select_real_attachments.contenttype#">
					<cfcase  value="text/calendar">
						<img align="absmiddle" src="/images/si/calendar_add.png" /> Add to calendar
					</cfcase>
				</cfswitch>
				
				<a href="index.cfm?action=loadattachment&filename=#urlencodedformat(q_select_real_attachments.afilename)#&contenttype=#urlencodedformat(q_select_real_attachments.contenttype)#&mailbox=#urlencodedformat(url.mailbox)#&id=#url.id#&partid=#q_select_real_attachments.contentid#&userkey=#urlencodedformat(url.userkey)#" target="_blank"><img src="/images/si/disk.png" border="0" align="absmiddle" vspace="4" hspace="4" alt="" />#GetLangVal('cm_wd_download')#</a> 
				&nbsp; 
				<a href="javascript:OpenNewWindowWithParams('/storage/show_popup_save_attachment.cfm?filename=#urlencodedformat(q_select_real_attachments.afilename)#&contenttype=#urlencodedformat(q_select_real_attachments.contenttype)#&mailbox=#urlencodedformat(url.mailbox)#&id=#url.id#&partid=#q_select_real_attachments.contentid#&userkey=#urlencodedformat(url.userkey)#');"><img align="absmiddle" vspace="4" hspace="4" src="/images/si/folder_add.png" alt="" border="0" />#GetLangVal('mail_ph_save_attachment_to_storage')#</a>
				

			
			</td>
		</tr>
	</cfoutput>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('mail_wd_attachments') &' (' & q_select_real_attachments.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>

