<!--- //

	Module:		Storage
	Action:		EditFile
	Description:Edit file properties
	

// --->
<cfparam name="url.parentdirectorykey" default="" type="string">
<cfparam name="url.entrykey" default="" type="string">
<cfparam name="url.version" default="-1" type="numeric">
<cfparam name="url.liveedit" default="false" type="boolean">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	version="#url.version#"
	LoadSecurityPermissions = true>
</cfinvoke>

<cfif NOT a_struct_file_info.result>
	File not found.
	<cfexit method="exittemplate">
</cfif>

<cfif NOT a_struct_file_info.a_struct_security_permissions.edit>
	Edit is not allowed.
	<cfexit method="exittemplate">
</cfif>

<cfset q_query_file = a_struct_file_info.q_select_file_info />

<cfset tmp = SetHeaderTopInfoString(q_query_file.filename & ' ' & GetLangVal('cm_wd_edit')) />

<cfsavecontent variable="a_str_content">
<cfoutput>
<form action="index.cfm?action=savefileinformation" method="post" name="form_edit_file" style="margin:0px; ">
<input type="hidden" name="frm_entrykey" value="#q_query_file.entrykey#" />
<input type="hidden" name="frm_parentdirectorykey" value="#q_query_file.parentdirectorykey#" />


<table class="table table_details table_edit_form">
<tr>
	<td class="field_name">
		#getlangval('sto_wd_filename')#
	</td>
	<td>
		<input id="frm_filename" name="frm_filename" value="#htmleditformat(q_query_file.filename)#" />
	</td>
</tr>
<tr>
	<td class="field_name">
		#getlangval('sto_wd_description')#
	</td>
	<td>
		<input id="frm_description" name="frm_description" value="#htmleditformat(q_query_file.description)#" />
	</td>
</tr>
<tr>
	<td class="field_name">
		#getlangval('sto_wd_contenttype')#
	</td>
	<td>
		<input id="frm_description" name="frm_contenttype" value="#htmleditformat(q_query_file.contenttype)#" />
	</td>
</tr>
<!--- <tr>
	<td class="field_name">
		#getlangval('cm_wd_categories')#
	</td>
	<td>
		<input id="frmcategories" name="frmcategories" value="#htmleditformat(q_query_file.categories)#" />
	</td>
</tr> --->
<cfif (q_query_file.contenttype IS 'text/html')>

	<cfif url.liveedit>
	<tr>
		<td class="field_name">#GetLangVal('cm_wd_text')#</td>
		<td>
			<cffile action="read" charset="utf-8" file="#q_query_file.storagepath##request.a_str_dir_separator##q_query_file.storagefilename#" variable="a_str_filecontent">
						
			<cfscript>
				fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
				fckEditor.instanceName	= "frmfilecontent";
				fckEditor.value			= a_str_filecontent;
				fckEditor.width			= "100%";
				fckEditor.height		= 350;
				fckEditor.toolbarSet	= 'INBOX_Default';
				fckEditor.create(); // create the editor.
			</cfscript>						
			
		</td>
	</tr>
	<cfelse>
		<tr>
			<td class="field_name">
				<img src="/images/si/pencil.png" class="si_img" />
			</td>
			<td>
				<a href="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&liveedit=true">#GetLangVal('sto_ph_do_live_edit_now')#</a>
				<img src="/images/space_1_1.gif" class="si_img" />
			</td>
		</tr>
	</cfif>
</cfif>
<tr>
	<td class="field_name">
		
	</td>
	<td>
		<input style="font-weight:bold; " name="submit" id="submit" class="btn btn-primary" type="submit" value="#getlangval('sto_wd_save')#" />
	</td>
</tr>

<tr>
	<td></td>
	<td>
		<a href="javascript:history.go(-1);">#GetLangVal('sto_ph_back_without_edit')#</a>
	</td>
</tr>
</table>
</form>	
</cfoutput>
</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(q_query_file.filename, a_str_buttons, a_str_content)#</cfoutput>

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetVersionInformation"   
	returnVariable = "q_query_versions"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"></cfinvoke>
	 
<cfif q_query_versions.recordcount GT 0>
<br /> 
<fieldset class="default_fieldset">
	<legend><cfoutput>#GetLangVal('sto_wd_versions')#</cfoutput></legend>
	<div>

	
		<cfoutput>
		<a href="index.cfm?action=delete_oldversions&frm_entrykey=#url.entrykey#&frm_parentdirectorykey=#q_query_file.parentdirectorykey#"><img src="/images/del.gif" align="absmiddle" border="0"> #GetLangVal('sto_ph_delete_old_version')#</a><br>

		<table cellpadding="4" cellspacing="0" border="0" width="90%">
			<tr>
				<td class="bb mischeader">
					##
				</td>
				<td class="bb mischeader">
					#GetLangVal('cm_Wd_Created')#
				</td>
				<td class="bb mischeader">
					#GetLangVal('cm_wd_action')#
				</td>
			</tr>
			<tr>
				<td class="bb" align="center">
					<a href="index.cfm?action=ShowFile&entrykey=#url.entrykey#">#GetLangVal('sto_wd_current')#</a>
				</td>
				<td class="bb">&nbsp;
					
				</td>
				<td class="bb">
					<a href="index.cfm?action=EditFile&entrykey=#url.entrykey#">#si_img('pencil')#</a>
					<a href="index.cfm?action=FileInfo&entrykey=#url.entrykey#"><img src="/images/info.jpg" border="0"></a>
					<a href="index.cfm?action=MailFile&entrykey=#url.entrykey#"><img src="/images/btn_folder_inbx2.gif" border="0"></a>
				</td>
			</tr>
			<cfloop query="q_query_versions">
				<tr>
					<td class="bb" align="center">
						<a href="index.cfm?action=ShowFile&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#">#version#</a>
					</td>
					<td class="bb">
						#LSDateFormat(q_query_versions.dt_created, request.stUserSettings.default_Dateformat)# #TimeFormat(q_query_versions.dt_created, request.stUserSettings.default_timeformat)#
					</td>
					<td class="bb">
						<a href="index.cfm?action=EditFile&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#">#si_img('pencil')#</a>
						<a href="index.cfm?action=FileInfo&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#"><img src="/images/info.jpg" border="0"></a>
						<a href="index.cfm?action=MailFile&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#"><img src="/images/btn_folder_inbx2.gif" border="0"></a>
					</td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>

</div>
</fieldset>
</cfif>


