<!--- //

	Module:		Storage
	Action:		UploadFile
	Description:Confirmation window
	

// --->
<cfparam name="url.frm_AutoClose" default="false" type="string">
<cfparam name="form.frm_AutoClose" default="#url.frm_AutoClose#" type="string">
<cfparam name="url.frm_AudioHint" default="" type="string">
<cfparam name="form.frm_AudioHint" default="#url.frm_AudioHint#" type="string">

<cfif len(form.frm_AutoClose) gt 0 and not a_bool_loop_error_occurred>
	<!--- ja, automatisch schlie&szlig;en --->
	<!--- <body onLoad="setTimeout('DoClose()',5000)" > --->
</cfif>

<!--- <cfif len(form.frm_AudioHint) gt 0 >
	<!--- audio alert on finish? --->
	<!---<embed src="/download/files/sounds/tada.wav" width="0" height="0" hspace="0" vspace="0" hidden="true" autostart="true">--->
</cfif> --->

<cfif a_bool_loop_error_occurred>
	<cfset session.a_arr_fileinfos = a_arr_fileinfos />
	<cfoutput>
		#getlangval('sto_ph_overwritefiles')#
		<br />
		<a href="default.cfm?action=UploadFile&force=true&frm_AutoClose=#form.frm_AutoClose#&frm_AudioHint=#form.frm_AudioHint#"><img src="/images/si/accept.png" class="si_img" /> #getlangval('sto_wd_yes')#</a> /
		<a href="default.cfm?action=showfiles&directorykey=#form.frm_parentdirectorykey#"><img src="/images/si/cancel.png" class="si_img" /> #getlangval('sto_wd_no')#</a>
	</cfoutput>
	<cfabort>
</cfif>

<br />
<br />
<div style="text-align:center; ">
	<form style="margin:0px; ">
		<input onClick="window.close();" type="button" class="btn" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>"/>
	</form>
</div>


