<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.contactkey" type="string">
<cfparam name="url.directorykey" type="string">

<html>
<head>
	<cfinclude template="/common/js/inc_js.cfm">
	<script type="text/javascript">
		function DisplayUploadStatus()
			{
			var obj1 = findObj('id_tr_status_upload');
			obj1.style.display = '';
			
			findObj('id_tr_upload_button').style.display = 'none';
			}
	</script>
	<title><cfoutput>#GetLangVal('cm_wd_add')#</cfoutput></title>
	<cfinclude template="/style_sheet.cfm">
</head>

<body style="padding:10px; ">

<form action="act_upload_file_attached_to_contact.cfm" style="margin:0px; " method="post" enctype="multipart/form-data" onSubmit="DisplayUploadStatus();">

<input type="hidden" name="frmcontactkey" value="<cfoutput>#url.contactkey#</cfoutput>">
<input type="hidden" name="frmdirectorykey" value="<cfoutput>#url.directorykey#</cfoutput>">

<fieldset class="default_fieldset">
	<legend class="addinfotext" style="font-weight:bold; ">
		<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput>
	</legend>
	<div>
	
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td>			
				<cfoutput>#GetLangVal('cm_wd_file')#</cfoutput>:
			</td>
			<td>
				<input type="file" name="frmfile" size="40">
			</td>
		  </tr>
		  <tr>
			<td>
				<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmdescription" size="40">
			</td>
		  </tr>
		  <tr>
			<td>
				<cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmcategories" size="40">
			</td>
		  </tr>
		  <tr id="id_tr_upload_button">
		  	<td></td>
			<td>
				<input type="submit" value="<cfoutput>#GetLangVal('sto_wd_upload')#</cfoutput>" name="frmsubmit">
			</td>
		  </tr>
		  <tr id="id_tr_status_upload" style="display:none; ">
		  	<td></td>
			<td style="font-weight:bold; ">
				<cfoutput>#GetLangVal('sto_ph_uploadalertmsg')#</cfoutput>
				<br><br>
				<img src="/images/Wait.gif">
			</td>
		  </tr>
		</table>
	
	</div>
</fieldset>

</form>
</body>
</html>
