<!--- //

	Module:		EMail
	Function:	ShowAddAttachmentDialog
	Description:Add attachment in inpage dialog
	
	Header:		

	
	
	TODO hp: finish email upload
	
// --->

<cfparam name="url.id" type="string" default="">
<cfparam name="url.mailbox" type="string" default="">

<cfset tmp = StartNewTabNavigation() />
<cfset a_str_id_local = AddTabNavigationItem(GetLangVal('mail_ph_add_attachments_localfile'), '', '') /> 
<cfset a_str_id_storage = AddTabNavigationItem(GetLangVal('mail_ph_add_attachments_from_storage'), '', '') /> 

<div id="id_div_upload_status_msg" style="display:none;">
	<h4>please wait</h4>
	<iframe name="idiframeupload" name="idiframeupload" src="/content/dummy/dummy.html"></iframe>
	<input type="button" value="cancel" onclick="CancelEmailAttachmentUpload()" class="btn" />
</div>

<div id="id_email_upload_div">
<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<div id="<cfoutput>#a_str_id_local#</cfoutput>" class="div_module_tabs_content_box">
	
<script type="text/javascript">
	function DisplayUploadProgress() {
		$('#id_div_upload_status_msg').fadeIn();
		$('#id_email_upload_div').hide();
		
		}
	function CancelEmailAttachmentUpload() {
		findObj('idiframeupload').location.href = 'ww.orf.at';
		}
</script>

<form name="frmUpload" target="idiframeupload" onSubmit="DisplayUploadProgress();" action="act_upload_attachment.cfm" method="POST" enctype="multipart/form-data">

		<input type="hidden" name="frmid" value="<cfoutput>#url.id#</cfoutput>" />
		<input type="hidden" name="frmmailbox" value="<cfoutput>#htmleditformat(url.mailbox)#</cfoutput>" />

		<table class="table_details" id="id_table_upload_fields">
		  <cfloop from="1" to="5" index="ii">
		  <tr>
			<td class="field_name">
				<cfoutput>#ReplaceNocase(GetLangVal('mail_ph_add_attachments_file_number'), '%NUMBER%', ii)#</cfoutput>
			</td>
			<td>
				<input type="File" name="frmfileupload<cfoutput>#ii#</cfoutput>" style="width:500px;" />
			</td>
		  </tr>
		  </cfloop>
		  <tr>
		  	<td class="field_name">&nbsp;</td>
			<td>
				<input class="btn btn-primary" type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('mail_ph_add_attachments_submit')#</cfoutput>" />
			</td>
		  </tr>
		</table>

		<br />

		<b><cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput>:</b>&nbsp;
		
		<cfoutput>#GetLangVal('mail_ph_add_attachments_maxsize')#</cfoutput>

		<br />

		<cfoutput>#GetLangVal('mail_ph_add_attachments_add_further_atts_later')#</cfoutput>

		<br />
		
		</form>
		


</div>

<div id="<cfoutput>#a_str_id_storage#</cfoutput>" class="div_module_tabs_content_box">
upload from storage
</div>

</div>




