<!--- //

	Module:		Storage
	Action:		EditFolder
	Description: 
	

// --->

<cfparam name="url.parentdirectorykey" default="" type="string">
<cfparam name="url.entrykey" default="" type="string">

<!--- do now allow special directories to be edited ... --->
<cfif ListFind('0A881FE5-C09F-24AD-0C47EBB2D0834101,0A881FE5-C09F-24AD-0C47EBB2D0834099', url.entrykey) GT 0>
	<cfoutput>#GetLangVal('sto_ph_error_upload_invalid_dir')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_editfolder')) />

<cfif Len(url.entrykey) IS 0>
	
 	<!--- Create a new directory ... get properties of parent --->
	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetDirectoryInformation"   
		returnVariable = "a_struct_dir"   
		directorykey = "#url.parentdirectorykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#">
	</cfinvoke>
	
	<cfset a_query_parentdirectory = a_struct_dir.q_select_directory />

	<cfset a_bool_newentry = true />
	<cfset a_query_directory=structnew() />
	<cfset a_query_directory.directoryname="">
	<cfset a_query_directory.description="">
	<cfset a_query_directory.displaytype=a_query_parentdirectory.displaytype>
	<cfset a_query_directory.versioning=0>
	<cfset a_query_directory.entrykey=CreateUUID()>
	<cfset a_query_directory.publicshare_directorykey="">
	<cfset a_query_directory.shared_directorykey="">
	<cfset a_query_directory.publicshare_directorykey="">
	<cfset a_query_directory.specialtype=0>
<cfelse>

	<!--- Edit an exiting directory --->
	<cfset a_bool_newentry = false />
	<cfinvoke   
		component = "#application.components.cmp_storage#"
		method = "GetDirectoryInformation"   
		returnVariable = "a_struct_dir"   
		directorykey = "#url.entrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#">
	</cfinvoke>
	
	<cfif NOT a_struct_dir.result>
		Access denied.
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset a_query_directory = a_struct_dir.q_select_directory />

</cfif>

<cfoutput>
	<cfif a_query_directory.shared_directorykey neq ""  or a_query_directory.publicshare_directorykey neq "">
		#getlangval('sto_ph_sharednamechange')#
	</cfif>
</cfoutput>

<cfsavecontent variable="a_str_content">

	
	<form action="index.cfm?action=savefolder" method="post" name="form_editcreate_folder" style="margin:0px; ">
	<cfif len(url.entrykey) eq 0>
		<input type="hidden" name="CreateNew" value="true">
	</cfif>	
	
	<input type="hidden" name="action" value="savefolder">
	<input type="hidden" name="frm_entrykey" value="<cfoutput>#a_query_directory.entrykey#</cfoutput>">
	<input type="hidden" name="frm_parentdirectorykey" value="<cfoutput>#url.parentdirectorykey#</cfoutput>">
	<input type="hidden" name="frm_currentdir" value="<cfoutput>#url.currentdir#</cfoutput>">
		
<table class="table table_details table_edit_form">
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_directoryname')#</cfoutput>:
		</td>
		<td>
			<cfif a_query_directory.specialtype gt 0 >
				<cfoutput>#a_query_directory.directoryname#</cfoutput>
				<input type="hidden" name="frm_directoryname" id="frm_directoryname" value="<cfoutput>#htmleditformat(a_query_directory.directoryname)#</cfoutput>">
			<cfelse>
				<input name="frm_directoryname" id="frm_directoryname" value="<cfoutput>#htmleditformat(a_query_directory.directoryname)#</cfoutput>">
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_description')#</cfoutput>:
		</td>
		<td>
			<input name="frm_description" value="<cfoutput>#htmleditformat(a_query_directory.description)#</cfoutput>">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_type')#</cfoutput>:
		</td>
		<td>
			<select name="frm_displaytype">
				<option value="0"><cfoutput>#getlangval('sto_wd_default')#</cfoutput>
				<option value="1" <cfif a_query_directory.displaytype gt 0 >selected</cfif>><cfoutput>#getlangval('sto_wd_graphics')#</cfoutput>
			</select>
		</td>
	<tr>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_ph_activeversioning')#</cfoutput>:
		</td>
		<td>
			<select name="frm_versioning">
				<option value="0" ><cfoutput>#getlangval('sto_wd_no')#</cfoutput>
				<option value="1" <cfif a_query_directory.versioning gt 0 >selected</cfif>><cfoutput>#getlangval('sto_wd_yes')#</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_ph_createworkgroupshare')#</cfoutput>:
		</td>
		<td>
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td id="idtdopenworkgorupiframe">
					<a href="javascript:OpenWorkgroupShareDialog('<cfoutput>#a_query_directory.entrykey#</cfoutput>');">Verzeichnis f&uuml;r Arbeitsgruppen freigeben ...</a>
				</td>
				<td id="idtdcloseworkgroupiframe" style="padding:6px;display:none;" class="mischeader bl br bt" align="center">
					<a href="javascript:CloseWorkgroupShareIframe();"><cfoutput>#GetLangVal('wg_ph_close_share_popup')#</cfoutput></a>
				
				</td>
			  </tr>
			</table>
		
			<div id="iddivworkgroups" style="display:none;width:100%;height:80px;" class="b_all">
				<iframe id="idiframeworkgroups" name="idiframeworkgroups" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" src="/tools/security/permissions/iframe/?servicekey=<cfoutput>#urlencodedformat(request.sCurrentServiceKey)#</cfoutput>&sectionkey=&entrykey=<cfoutput>#urlencodedformat(a_query_directory.entrykey)#</cfoutput>"></iframe>
			</div>	
		
		</td>
	</tr>
	<tr>
		<td class="field_name">
			
		</td>
		<td>
			<input type="submit" class="btn btn-primary" value="<cfoutput>#htmleditformat(getlangval('sto_wd_save'))#</cfoutput>" />
			
			<input type="button" onClick="CancelEditing();" value="<cfoutput>#GetLangVal('cm_wd_cancel')#</cfoutput> ..." class="btn" />
		</td>
	</tr>
	</form>
</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('sto_ph_editfolder'), a_str_buttons, a_str_content)#</cfoutput>

<cfif not a_bool_newentry>

<br />

<cfsavecontent variable="a_str_content">	

<cfif len(a_query_directory.publicshare_directorykey ) gt 0>
<form action="index.cfm?action=PublicShare" method="post" style="margin:0px;">
			<input type="hidden" name="action" value="PublicShare">
			<input type="hidden" name="frm_currentdir" value="<cfoutput>#url.currentdir#</cfoutput>">
			<input type="hidden" name="frm_entrykey" value="<cfoutput>#a_query_directory.entrykey#</cfoutput>">
			<input type="hidden" name="frm_parentdirectorykey" value="<cfoutput>#a_query_directory.parentdirectorykey#</cfoutput>">	
		<table class="table table_details table_edit_form">
		
		  <tr>
			<td colspan="2" class="bb">
				<b><cfoutput>#GetLangVal('sto_ph_edit_public_dir')#</cfoutput></b>
			</td>
		  </tr>
		  <tr>
			<td class="field_name">
				<cfoutput>#getlangval('sto_wd_password')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frm_password" value="<cfoutput>#htmleditformat(a_query_directory.publicshare_password)#</cfoutput>" />
			</td>
		  </tr>
		  <tr>
			<td class="field_name" />
			<td>
				<cfoutput>#GetLangVal('sto_ph_link_to_public_dir')#</cfoutput>:<br>
				
				<cfset a_str_domain = ListGetAt(request.stSecurityContext.myusername, 2, '@') />
				<cfset a_str_username = ListGetAt(request.stSecurityContext.myusername, 1, '@') />
				
				<cfset a_str_link = 'http://www.openTeamWare.com/storage/public.cfm/'&a_str_domain&'/'&a_str_username&'/'>
				
				<cfoutput>
				<a target="_blank" href="#a_str_link#">#a_str_link#</a>
				</cfoutput>
			
			</td>
		  </tr>
		  <tr>
			<td class="field_name"></td>
			<td>
			<input type="submit" name="frm_subaction_update" value="<cfoutput>#getlangval('sto_ph_savepassword')#</cfoutput>" class="btn btn-primary" />
			</td>
		  </tr>
		  <tr>
			<td colspan="2" class="bb">
				<cfoutput>#GetLangVal('sto_ph_deletepublicshare')#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td class="field_name"></td>
			<td>
				<input type="submit" name="frm_subaction_delete" value="<cfoutput>#getlangval('sto_ph_deletepublicshare')#</cfoutput>" class="btn btn-primary" />
			</td>
		  </tr>
		  </form>
		</table>	

	<cfelse>
	
		
		<form action="index.cfm?action=PublicShare" method="post" style="margin:0px; ">
			<input type="hidden" name="action" value="PublicShare">
			<input type="hidden" name="frm_entrykey" value="<cfoutput>#a_query_directory.entrykey#</cfoutput>">
			<input type="hidden" name="frm_parentdirectorykey" value="<cfoutput>#a_query_directory.parentdirectorykey#</cfoutput>">
		<table class="table table_details table_edit_form">
			<tr>
				<td colspan="2">
				<cfoutput>#GetLangVal('sto_ph_public_description')#</cfoutput>
				</td>
			</tr>
			<tr>
				<td class="field_name"><cfoutput>#GetLangVal('cm_wd_password')#</cfoutput>:</td>
				<td><input type="text" name="frm_password" /></td>
			</tr>
			<tr>
				<td class="field_name"></td>
				<td><input type="submit" value="<cfoutput>#getlangval('sto_ph_createpublicshare')#</cfoutput>" class="btn btn-primary" /></td>
			</tr>
		</table>
			 
			
		</form>
	</cfif>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('sto_ph_publicfiles'), a_str_buttons, a_str_content)#</cfoutput> 


</cfif>
<cfoutput>
	<script type="text/javascript">
		function CancelEditing() 
		{
			if (confirm('#getlangval('sto_ph_areyousure')#?') == true)
			{
				history.go(-1);
			}
		}
	</script>
</cfoutput>

