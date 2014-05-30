<!--- //

	Module:		Address Book
	Action:		SetPhotoForContact
	Description: 
	

// --->

<cfparam name="url.entrykey" type="string">

<form action="index.cfm?action=UploadPhotoForContact" method="post" enctype="multipart/form-data">
<input type="hidden" name="frmentrykey" value="<cfoutput>#url.entrykey#</cfoutput>" />
<table class="table_details table_edit_form">
<tr>
	<td class="field_name"></td>
	<td>
		<cfoutput>#GetLangVal('adm_ph_photo_big_recommended_width')#</cfoutput>
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_file')#</cfoutput>
	</td>
	<td>
		<input type="file" name="frmfile" value="" />
	</td>
</tr>
<tr>
	<td class="field_name">
	</td>
	<td>
		<input type="submit" value="<cfoutput>#GetLangVal('adm_ph_save_photos')#</cfoutput>" class="btn btn-primary" />
	</td>
</tr>
<tr>
	<td class="field_name">
	</td>
	<td>
		<input type="submit" name="frmsubmit_removephoto" value="<cfoutput>#GetLangVal('adrb_ph_remove_photo_completly')#</cfoutput>" class="btn btn-primary" />
	</td>
</tr>
</table>
</form>




