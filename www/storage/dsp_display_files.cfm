<!--- //

	Module:		Storage
	Action:		ShowFiles, display mode
	Description: 
	

// --->


<cfparam name="request.stUserSettings.DEFAULT_DATEFORMAT" type="string" default="dd.mm.yy">
<cfparam name="url.directorykey" default="" type="string">
<cfparam name="request.a_bool_disable_search" default=false type="boolean">
<cfparam name="a_bool_publicview" type="boolean" default="false">
<cfparam name="url.startrow" default="1" type="numeric">
<cfparam name="url.view" type="string" default="">

<cfif not a_bool_publicview>
	<cfset a_int_default_pagesize = GetUserPrefPerson('storage', 'pagesize', 30, '', false) />
	<cfset request.a_int_pagesize = a_int_default_pagesize />
<cfelse>
	<cfset request.a_int_pagesize = 30 />
</cfif>	

<cfinvoke component="#application.components.cmp_tools#" method="GeneratePageScroller" returnvariable="a_str_page_scroller">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="current_url" value="#cgi.QUERY_STRING#">
	<cfinvokeargument name="url_tag_name" value="startrow">
	<cfinvokeargument name="step" value="#request.a_int_pagesize#">
	<cfinvokeargument name="recordcount" value="#a_query_displayfiles.recordcount#">
	<cfinvokeargument name="current_record" value="#url.startrow#">
</cfinvoke>

<cfoutput>#a_str_page_scroller#</cfoutput>

<!--- no files found? --->
<cfif a_query_displayfiles.recordcount IS 0>
       
	<br />			
	<div style="padding:40px;text-align:center;">
	<form style="margin:0px; ">
	<cfoutput>
    #getlangval('odb_ph_nodatafound')#.
	<br /><br />  
	<input class="btn" type="button" value="#getlangval('sto_ph_addfiles')#" onClick="window.open('/storage/index.cfm?action=AddFile&parentdirectorykey=#url.directorykey#','_blank','toolbar=no,location=no,directories=no,status=no,copyhistory=no,scrollbars=yes,resizable=yes,height=400,width=600');return false;" />
	
	</cfoutput>
	</form>
	</div>
	<cfexit method="exittemplate">
       
</cfif>

<cfset a_str_displayed_userkeys = ValueList(a_query_displayfiles.userkey) />

<cfif StructKeyExists(request, 'stSecurityContext')>
	<!--- remove own entrykeys ... --->
	<cfset a_str_displayed_userkeys = ReplaceNoCase(a_str_displayed_userkeys, request.stSecurityContext.myuserkey, '', 'ALL') />
</cfif>

<cfset a_int_listlen_displayed_userkeys = ListLen(a_str_displayed_userkeys) />

<cfset QS = CGI.QUERY_STRING />
<cfset QS  =ReplaceOrAddURLParameter(QS,"ordertype","ASC")>
<cfif url.ordertype eq "ASC">
   <cfset QS = ReplaceOrAddURLParameter(QS,"ordertype","DESC")>
</cfif>

<cfoutput>
<form action="#CGI.SCRIPT_NAME##CGI.PATH_INFO#" method="get" name="fileform" id="fileform" style="margin:0px;">
<table class="table_overview">
	<tr class="tbl_overview_header">
		<td>
			<input onClick="AllFiles();" type="checkbox" name="frmcbselectall" class="noborder" />
		</td>
		<td>
			<cfif not request.a_bool_disable_search>
				<a href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?#ReplaceOrAddURLParameter(QS,"orderby","name")#">
			</cfif>
			#getlangval('sto_wd_filename')#
			<cfif not request.a_bool_disable_search>
				</a>
			</cfif>
		</td>
		<td>
			<cfif not request.a_bool_disable_search>
				<a href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?#ReplaceOrAddURLParameter(QS,"orderby","dt_lastmodified")#">
			</cfif>
			#getlangval('cm_wd_modified')#
			<cfif not request.a_bool_disable_search>
				</a>
			</cfif>		
		</td>
		<td>
			<cfif not request.a_bool_disable_search>
				<a href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?#ReplaceOrAddURLParameter(QS,"orderby","filetype")#">
			</cfif>
			</a>
			#getlangval('sto_wd_type')#
			<cfif not request.a_bool_disable_search>
				</a>
			</cfif>
		</td>
		<td align="right">
			<cfif not request.a_bool_disable_search>
				<a  href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?#ReplaceOrAddURLParameter(QS,"orderby","filesize")#">
			</cfif>
			#getlangval('sto_wd_filesize')#
			<cfif not request.a_bool_disable_search>
				</a>
			</cfif>
		</td>
		<cfif a_int_listlen_displayed_userkeys GT 0>
		<td>
			<cfif not request.a_bool_disable_search>
				<a  href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?#ReplaceOrAddURLParameter(QS,"orderby","userkey")#">
			</cfif>
				#getlangval('sto_wd_username')#
				
			<cfif not request.a_bool_disable_search>
				</a>
			</td>
		</cfif>
		
		</cfif>
		<td align="right">
			#getlangval('sto_wd_actions')#
		</td>
	</tr>
</cfoutput>

<cfoutput query="a_query_displayfiles" startrow="#url.startrow#" maxrows="#(request.a_int_pagesize + 1)#">
	<cfif a_bool_publicview>
		<cfset a_str_fileurl= a_query_displayfiles.name />
		<cfset a_str_dirurl= a_query_displayfiles.name&'/' />
		<cfset a_str_infourl= a_query_displayfiles.name&'?info=1' />
	<cfelse>
		<cfset a_str_fileurl = "index.cfm?action=ShowFile&entrykey=#a_query_displayfiles.entrykey#" />
		<cfset a_str_dirurl = "index.cfm?action=ShowFiles&directorykey=#a_query_displayfiles.entrykey#" />
		<cfset a_str_infourl = "index.cfm?action=FileInfo&entrykey=#a_query_displayfiles.entrykey#" />
	</cfif>
	
	<cfswitch expression="#a_query_displayfiles.filetype#">
		<cfcase value="special">
		<tr>
			<td>
			</td>
			<td>
				<img src="/images/si/folder.png" class="si_img" /> <a href="#a_str_dirurl#">#htmleditformat(a_query_displayfiles.name)#</a>
			</td>
			<td>
				#htmleditformat(a_query_displayfiles.filetype)#
			</td>
			<td>
			</td>
			<cfif a_int_listlen_displayed_userkeys GT 0>
			<td>
				<cfif NOT StructKeyExists(request, 'stSecurityContext') OR  Compare(a_query_displayfiles.userkey, request.stSecurityContext.myuserkey) NEQ 0>
					#a_query_displayfiles.userkey#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			</cfif>
		</tr>
		</cfcase>
		<cfcase value="directory">
		<tr>
			<td></td>
			<td>
				
				<cfif a_query_displayfiles.specialtype IS 1>
					<img src="/images/si/folder_user.png" class="si_img" />
				<cfelseif a_query_displayfiles.shared IS 0>
					<img src="/images/si/folder.png" class="si_img" />
				<cfelse>
					<img src="/images/si/folder_user.png" class="si_img" />
				</cfif>
				
				<cfif not a_bool_publicview>
					<a href="#a_str_dirurl#" title="#htmleditformat(a_query_displayfiles.description)#">#htmleditformat(a_query_displayfiles.name)# <cfif a_query_displayfiles.specialtype lte 0>(#a_query_displayfiles.filescount#)</cfif></a>
				<cfelse>
					<a href="#a_str_dirurl#" title="#htmleditformat(a_query_displayfiles.description)#">#htmleditformat(a_query_displayfiles.name)# <cfif a_query_displayfiles.specialtype lte 0>(#a_query_displayfiles.filescount#)</cfif></a>
				</cfif>
				
			</td>
			<td class="addinfotext">
				#FormatDateTimeAccordingToUserSettings(a_query_displayfiles.dt_lastmodified)#
			</td>
			<td>
				#GetLangVal('sto_wd_type_'&a_query_displayfiles.filetype)#
			</td>
			<td>										
			</td>
			
			<cfif (a_int_listlen_displayed_userkeys GT 0)>
			<td>
			<cfif NOT StructKeyExists(request, 'stSecurityContext') OR Compare(request.stSecurityContext.myuserkey, a_query_displayfiles.userkey) NEQ 0>
				#application.components.cmp_user.GetUsernamebyentrykey(entrykey=a_query_displayfiles.userkey)#
			</cfif>
			</td>
			</cfif>
			
			<td class="addinfotext" align="right">
				<cfif a_query_displayfiles.specialtype lte 0 >
					<cfif not a_bool_publicview >
						<a class="nl" href="index.cfm?action=EditFolder&entrykey=#a_query_displayfiles.entrykey#&currentdir=#url.directorykey#"><img src="/images/si/pencil.png" class="si_img" /></a>
						
						<a class="nl" href="index.cfm?action=DeleteFolder&entrykey=#a_query_displayfiles.entrykey#&parentdirectorykey=#url.directorykey#&currentdir=#url.directorykey#"><img src="/images/si/delete.png" class="si_img" /></a>
					</cfif>
				</cfif>
			</td>
		</tr>
		</cfcase>
			<cfcase value="file">
				<tr>
					<td>
						<input  class="noborder" type="checkbox" name="frm_entrykey" value="#a_query_displayfiles.entrykey#" />
					</td>
					<td style="white-space:nowrap; ">
						#application.components.cmp_tools.GetImagePathForContentType(a_query_displayfiles.contenttype)#
						<a href="#a_str_fileurl#" target="_blank" title="#htmleditformat(a_query_displayfiles.name & ' ' & a_query_displayfiles.description)#">#htmleditformat(shortenstring(a_query_displayfiles.name, 90))#</a>
						
						<cfif a_query_displayfiles.locked IS 1>
						<a href="##" onclick="ShowLockShortInformation('#a_query_displayfiles.entrykey#');return false;"><img src="/images/si/lock.png" class="si_img" /></a>
						</cfif>
						
						<cfif ListFindNoCase(a_query_displayfiles.contenttype, 'audio', '/') IS 1>
							<a href="##" onclick="PlayAudioFile('#JsStringFormat(a_query_displayfiles.entrykey)#');"><img src="/images/si/control_play_blue.png" class="si_img" /> PLAY</a>
						</cfif>
						
						<cfif DateDiff('d', a_query_displayfiles.dt_lastmodified, Now()) LTE 2>
							<img src="/images/si/new.png" class="si_img" />
						</cfif>
						
					</td>
					<td class="addinfotext">
						#FormatDateTimeAccordingToUserSettings(a_query_displayfiles.dt_lastmodified)#
					</td>
					
					<td title="#htmleditformat(a_query_displayfiles.contenttype)#">
						#ShortenString(a_query_displayfiles.contenttype, 20)#
					</td>
					<td align="right">
						#byteConvert(a_query_displayfiles.filesize)#
					</td>
					<cfif a_int_listlen_displayed_userkeys GT 0>
						<td class="bb">	
						<cfif  NOT StructKeyExists(request, 'stSecurityContext') OR Compare(request.stSecurityContext.myuserkey, a_query_displayfiles.userkey) NEQ 0>
							#application.components.cmp_user.GetUsernamebyentrykey(entrykey = a_query_displayfiles.userkey)#
						</cfif>
						</td>
					</cfif>
					<td align="right">
					<cfif not a_bool_publicview>
							
						<cfif FindNoCase('audio/', a_query_displayfiles.contenttype) GT 0>
							<a target="_blank" onclick="window.open('/storage/show_play_audio.cfm?directorykey=#url.directorykey#&entrykey=#a_query_displayfiles.entrykey#','_blank','toolbar=no,location=no,directories=no,status=no,copyhistory=no,scrollbars=yes,resizable=yes,height=300,width=400');return false;" href="##"><img src="/images/si/control_play_blue.png" class="si_img" /></a>
						</cfif>
						<a class="nl" href="##" onclick="ShowLockShortInformation('#a_query_displayfiles.entrykey#');return false;"><img src="/images/si/lock.png" class="si_img" /></a>
						<a class="nl" href="index.cfm?action=FileInfo&entrykey=#a_query_displayfiles.entrykey#"><img src="/images/si/information.png" class="si_img" /></a>
						<a class="nl" href="index.cfm?action=EditFile&entrykey=#a_query_displayfiles.entrykey#"><img src="/images/si/pencil.png" class="si_img" /></a>
						<a class="nl" href="##" onclick="ConfirmDeleteFile('#a_query_displayfiles.entrykey#');return false;"><img src="/images/si/delete.png" class="si_img" /></a>
	
					</cfif>
					</td>
				</tr>
			</cfcase>
		</cfswitch>
	</cfoutput>
</table>

<!--- display page scroller again --->
<cfoutput>#a_str_page_scroller#</cfoutput>


<cfif NOT a_bool_publicview>
	<br />
	<cfoutput>
	
		<input type="hidden" name="frm_parentdirectorykey" id="frm_parentdirectorykey" value="#url.directorykey#">
		<input type="hidden" name="action" id="id_form_action_action_name" value="" />
		
		<div class="b_all" style="padding:6px;">
		#getlangval('sto_ph_choosenfiles')#:
				
		<input type="button" class="btn2" value="#getlangval('sto_wd_move')#" onClick="SetStorageMultiAction('movefiles');" />
		<input type="button" class="btn2" value="#getlangval('sto_wd_delete')#" onClick="SetStorageMultiAction('DeleteFile');" />
		<!--- <input type="button" class="btn2" value="#getlangval('sto_ph_sendviamail')#" onClick="SetStorageMultiAction('sendviamail');" /> --->
					
		</div>
	
		</form>
	</cfoutput>
</cfif>




