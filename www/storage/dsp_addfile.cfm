<!--- //

	Module:		Storage
	Action:		AddFile
	Description: 
	

// --->

<cfparam name="url.parentdirectorykey" default="" type="string">

<cfif ListFind('0A881FE5-C09F-24AD-0C47EBB2D0834101,0A881FE5-C09F-24AD-0C47EBB2D0834099', url.parentdirectorykey) GT 0>
	<cfoutput>#GetLangVal('sto_ph_error_upload_invalid_dir')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>
		
<form action="default.cfm?action=UploadFile" method="POST" enctype="multipart/form-data" onSubmit="DisplayPleaseWaitMsgOnLocChange()" style="margin:0px;">
<input type="hidden" name="frm_parentdirectorykey" value="<cfoutput>#url.parentdirectorykey#</cfoutput>" />
			

<cfoutput>#WriteSimpleHeaderDiv(getlangval('sto_ph_addfiles'))#</cfoutput>


	
	<table class="table_details table_edit_form" style="margin-top:14px; ">
	<tr>
		<td colspan="2">
			<cfoutput>#getlangval('sto_ph_chooseuploadfiles')#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_file')#</cfoutput> 1:</td>
		<td>
			<input type="file" name="frm_File1" style="width:340px;">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_file')#</cfoutput> 2:
		</td>
		<td>
			<input type="file" name="frm_File2" style="width:340px;">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_file')#</cfoutput> 3:
		</td>
		<td>
			<input type="file" name="frm_File3" style="width:340px;">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_file')#</cfoutput> 4:
		</td>
		<td>
			<input type="file" name="frm_File4" style="width:340px;">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_file')#</cfoutput> 5:
		</td>
		<td>
			<input type="file" name="frm_File5" style="width:340px;">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_wd_directory')#</cfoutput>:
		</td>
		<td>
			<cfset q_select_dir = application.components.cmp_storage.GetDirectoryInformation(directorykey = url.parentdirectorykey, securitycontext = request.stSecurityContext, usersettings = request.stUserSettings).q_select_directory />
			<cfoutput>#q_select_dir.directoryname#</cfoutput>
		</td>
	</tr>
	<!---<tr>
		<td class="field_name">
			<input class="noborder" type="checkbox" name="frm_AudioHint" value="true">
		</td>
		<td>
			<cfoutput>#getlangval('sto_ph_playsound')#</cfoutput>
		</td>
	</tr>--->
	<tr>
		<td class="field_name">
			<input class="noborder" type="checkbox" name="frm_AutoClose" value="true" >
		</td>
		<td>
			<cfoutput>#getlangval('sto_ph_closeafterupload')#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>&nbsp;
			
		</td>
		<td id="tdSubmit">
			<input type="submit" name="frm_Submit" class="btn" value="<cfoutput>#getlangval('sto_wd_upload')#</cfoutput>">
		</td>
	</tr>
	<tr>
		<td  align="center" colspan="2" id="tdUploadProgress" class="b_all mischeader" style="display:none;">
			<b><cfoutput>#getlangval('sto_ph_uploadinprogress')#</cfoutput></b>
			<br>
			<br>
			<img src="/images/img_bar_status_loading.gif" width="107" height="13" border="0"/>
		</td>
	</tr>
</table>
</form>



