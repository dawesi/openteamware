<!--- //

	Module:		E-Mail
	Action:		AddAttachment
	Description: 
	

	
	
	display the form for adding an attachment

	where to load the attachment from

	a) "local"
	b) "storage"
	
// --->

<cfparam name="url.source" type="string" default="local">

<!--- the id of the message --->
<cfparam name="url.id" type="numeric" default="0">

<!--- the folder name --->
<cfparam name="url.mailbox" type="string" default="INBOX.Drafts">

<cfparam name="url.downgradeuploader" type="string" default="false">

<cfif url.downgradeuploader IS 'true'>
	<cfmodule template="/common/person/saveuserpref.cfm"
		entrysection = "email"
		entryname = "attachments.useroldupload"
		entryvalue1 = 1>
</cfif>

<!--- check in which viewmode we're ... --->
<cfset a_int_user_old_upload = GetUserPrefPerson('email', 'attachments.useroldupload', '0', '', false) />

<!--- // datei wird nun hinzugef&uuml;gt ... formular anzeigen ... // --->
<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_add_attachments_header')) />

<script type="text/javascript">
	function DisplayProgress() {
		$('#AttachmentUploadProgress').show();
		}
</script>


<div style="padding:20px; ">
<div style="padding:5px; " class="bb"><cfoutput>#GetLangVal('mail_ph_add_attachments_select_source')#</cfoutput></div>
	
<cfset tmp = StartNewTabNavigation() />
<cfset tmp = AddTabNavigationItem(GetLangVal('mail_ph_add_attachments_localfile'), 'javascript:GotoLocHref(''index.cfm?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "source", "local")#'');', '')> 
<cfset tmp = AddTabNavigationItem(GetLangVal('mail_ph_add_attachments_from_storage'), 'javascript:GotoLocHref(''index.cfm?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "source", "storage")#'');', '')> 

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<div class="b_all div_module_tabs_content_box">

<table border="0" cellpadding="4" cellspacing="0">
<tr>
	<td colspan="2">

	<cfif CompareNoCase(url.source, "local") is 0>
		
<!--- use new or old upload? --->
<cfif NOT a_int_user_old_upload IS '1'>
<cfset a_str_url_token = ReplaceNoCase( '&' & session.URLToken , '&', '%26', 'ALL' ) />		

<cfset a_str_upload_url = "/email/actions/act_upload_attachment.cfm?uid=#url.id#%26foldername=#htmleditformat(url.mailbox)#%26subaction=uploadsinglefile%26#a_str_url_token#" />		
<cfset a_str_redirect_url = "/email/actions/act_upload_attachment.cfm?uid=#url.id#%26foldername=#htmleditformat(url.mailbox)#%26subaction=multiuploaddone%26#a_str_url_token#" />

<OBJECT id="FlashFilesUpload" codeBase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
		width="450" height="350" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" VIEWASTEXT>
		<!--- Replace symbols " with the &quot; at all parameters values and
		symbols "&" with the "%26" at URL values or &amp; at other values!
		The same parameters values should be set for EMBED object below. --->
	<PARAM NAME="FlashVars" VALUE="uploadUrl=<cfoutput>#a_str_upload_url#</cfoutput>
		&redirectUploadUrl=<cfoutput>#a_str_redirect_url#</cfoutput>			
		&labelUploadText=<cfoutput>#GetLangVal( 'mail_ph_add_attachments_localfile_select' )#</cfoutput>
		&uploadButtonText=<cfoutput>#GetLangVal( 'mail_ph_add_attachments_submit' )#</cfoutput>
		&browseButtonText=<cfoutput>#GetLangVal( 'cm_ph_select_now' )#</cfoutput>
		&removeButtonText=<cfoutput>#GetLangVal( 'mail_wd_compose_attachment_remove' )#</cfoutput>
		&totalSizeText=<cfoutput>#GetLangVal( 'cm_wd_size' )#</cfoutput>: <SIZE>
		&progressUploadingText=<cfoutput>#GetLangVal( 'sto_ph_uploadinprogress' )#</cfoutput>
		&progressMainText=<cfoutput>#UrlEncodedFormat( '<PERCENT>% ' )#</cfoutput><cfoutput>  #GetLangVal( 'tsk_wd_done' )# (<FILESNUM> #GetLangVal( 'cm_wd_files' )#) <PART2DIV><BR>Transfer: <RATEVALUE>/sec<BR>#GetLangVal( 'cal_wd_duration' )#: <LEFTMIN> min <LEFTSEC> sec</cfoutput>
		&showLink=false
		&useExternalInterface=true
		&clearButtonVisible=false
		&uploadButtonWidth=200
		&labelInfoX=240
		&backgroundColor=#FFFFFF
		&listBackgroundColor=#FFFFFF">
		
		<PARAM NAME="BGColor" VALUE="#FFFFFF">
		<PARAM NAME="Movie" VALUE="/include/flash/upload_files.swf">
		<PARAM NAME="Src" VALUE="/include/flash/upload_files.swf">
		<PARAM NAME="WMode" VALUE="Window">
		<PARAM NAME="Play" VALUE="-1">
		<PARAM NAME="Loop" VALUE="-1">
		<PARAM NAME="Quality" VALUE="High">
		<PARAM NAME="SAlign" VALUE="">
		<PARAM NAME="Menu" VALUE="-1">
		<PARAM NAME="Base" VALUE="">
		<PARAM NAME="AllowScriptAccess" VALUE="always">
		<PARAM NAME="Scale" VALUE="ShowAll">
		<PARAM NAME="DeviceFont" VALUE="0">
		<PARAM NAME="EmbedMovie" VALUE="0">
		<PARAM NAME="SWRemote" VALUE="">
		<PARAM NAME="MovieData" VALUE="">
		<PARAM NAME="SeamlessTabbing" VALUE="1">
		<PARAM NAME="Profile" VALUE="0">
		<PARAM NAME="ProfileAddress" VALUE="">
		<PARAM NAME="ProfilePort" VALUE="0">


	<!--- Embed for Netscape,Mozilla/FireFox browsers support. Flashvars parameters are the same.
		 Replace symbols " with the &quot; at all parameters values and
		symbols "&" with the "%26" at URL values or &amp; at other values! --->
	<embed bgcolor="#FFFFFF" id="EmbedFlashFilesUpload" src="/include/flash/upload_files.swf" quality="high"
			pluginspage="https://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"
			type="application/x-shockwave-flash" width="450" height="350"
	flashvars="uploadUrl=<cfoutput>#a_str_upload_url#</cfoutput>
&redirectUploadUrl=<cfoutput>#a_str_redirect_url#</cfoutput>
&labelUploadText=<cfoutput>#GetLangVal('mail_ph_add_attachments_localfile_select')#</cfoutput>
&uploadButtonText=<cfoutput>#GetLangVal( 'mail_ph_add_attachments_submit' )#</cfoutput>
&browseButtonText=<cfoutput>#GetLangVal( 'cm_ph_select_now' )#</cfoutput>
&totalSizeText=<cfoutput>#GetLangVal( 'cm_wd_size' )#</cfoutput>: <SIZE>
&browseButtonWidth=110
&uploadButtonWidth=200
&showLink=false
&useExternalInterface=true
&labelInfoX=240
&clearButtonVisible=false
&removeButtonText=<cfoutput>#GetLangVal( 'mail_wd_compose_attachment_remove' )#</cfoutput>
&progressUploadingText=<cfoutput>#GetLangVal( 'sto_ph_uploadinprogress' )#</cfoutput>
&progressMainText=<cfoutput>#UrlEncodedFormat( '<PERCENT>% ' )#</cfoutput><cfoutput>  #GetLangVal( 'tsk_wd_done' )# (<FILESNUM> #GetLangVal( 'cm_wd_files' )#) <PART2DIV><BR>Transfer: <RATEVALUE>/sec<BR>#GetLangVal( 'cal_wd_duration' )#: <LEFTMIN> min <LEFTSEC> sec</cfoutput>
&backgroundColor=#FFFFFF
&listBackgroundColor=#FFFFFF">
	</embed>
  </OBJECT>

<script type="text/javascript">
function MultiPowUpload_onCompleteAbsolute(type, uploadedBytes) {
	$('#AttachmentUploadProgress').show();
	}
</script>
	
	<br />
	<a href="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" target="_blank"><cfoutput>#si_img( 'information' )#</cfoutput> Im Falle von Problemen updaten Sie bitte hier auf die aktuelle Flash - Version</a>
	<br /><br />
	<a href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.query_string#</cfoutput>&downgradeuploader=true"><cfoutput>#si_img( 'cross' )#</cfoutput> Immer noch Probleme? Jetzt auf die alte Version wechseln ...</a>
<cfelse>

<cfoutput>#GetLangVal('mail_ph_add_attachments_localfile_select')#</cfoutput> 
	
		<form name="frmUpload" onSubmit="javascript:DisplayProgress();" action="actions/act_upload_attachment.cfm" method="POST" enctype="multipart/form-data">

		<input type="hidden" name="frmid" value="<cfoutput>#url.id#</cfoutput>" />

		<input type="hidden" name="frmmailbox" value="<cfoutput>#htmleditformat(url.mailbox)#</cfoutput>" />

		<table class="table_details table_edit_form">
		<cfloop from="1" to="5" index="ii">
		  <tr>
			<td class="field_name">
				<cfoutput>#ReplaceNocase(GetLangVal('mail_ph_add_attachments_file_number'), '%NUMBER%', ii)#</cfoutput>
			</td>
			<td>
				<input type="File" name="frmfileupload<cfoutput>#ii#</cfoutput>" style="width:600px;" />
			</td>
		  </tr>
		 </cfloop>
		  <tr>
		  <td class="field_name"> </td>
			<td><input class="btn" type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('mail_ph_add_attachments_submit')#</cfoutput>" /></td>
		  </tr>
		</table>

		<br />

		<b><cfoutput>#si_img('information')#</cfoutput> <cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput>:</b>&nbsp;
		
		<cfoutput>#GetLangVal('mail_ph_add_attachments_maxsize')#</cfoutput>

		<br />

		<cfoutput>#GetLangVal('mail_ph_add_attachments_add_further_atts_later')#</cfoutput>

		<br />
		
		</form>
</cfif>	

		
		<br /><br />
			
		<blockquote>
		

		
		<div id="AttachmentUploadProgress" class="mischeader b_all" style="padding:5px;display:none;width:250px;">

		<b><cfoutput>#GetLangVal('mail_ph_add_attachments_progress_msg')#</cfoutput></b><br />

		

		<br />

		<cfoutput>#GetLangVal('mail_ph_add_attachments_hint_duration')#</cfoutput>
		
		<br />
		<br />
		<img src="/images/img_bar_status_loading.gif" width="107" height="13" border="0">

		</div>

		</blockquote>	
		
	

	<cfelse>
	
		
			<form name="frmAddfromStorage" action="actions/act_add_attachment_from_storage.cfm" method="POST" enctype="multipart/form-data">
				<input type="hidden" name="frmid" value="<cfoutput>#url.id#</cfoutput>" />
				<input type="hidden" name="frmmailbox" value="<cfoutput>#htmleditformat(url.mailbox)#</cfoutput>" />
				<input type="Hidden" name="frmStorageUpload" value="1" />
				
				<!--- include loop from files ... --->
				<input type="submit" value="<cfoutput>#GetLangVal('mail_ph_add_attachments_submit')#</cfoutput>" class="btn" />
				<cfinclude template="../storage/dsp_mod_add_email_attachment.cfm">
				<input type="submit" value="<cfoutput>#GetLangVal('mail_ph_add_attachments_submit')#</cfoutput>" class="btn" />
			
			</form>	

	</cfif>

	</td>

</tr>
<tr>
	<td colspan="2" class="bt">
		<a href="index.cfm?action=composemail&draftid=<cfoutput>#url.id#</cfoutput>">&lt; <cfoutput>#GetLangVal('mail_ph_return_to_msg_without_adding_attachment')#</cfoutput></a>
	</td>
</tr>
</table>
</div>
</div>

<script type="text/javascript">
	function displayfolder(id)
		{
		obj1 = findObj('iddivdir' + id);
		obj1.style.display = "";		
		}
</script>


