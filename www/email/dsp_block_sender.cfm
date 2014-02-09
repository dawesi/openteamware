<!--- //

	block a sender
	
	ask for some properties of this user ... 
	
	// --->
<cfparam name="url.emailadr" type="string" default="">
<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.id" type="numeric" default="0">
	
<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_block_sender')) />

<cfset url.emailadr = extractemailadr(url.emailadr)>

<cfif len(url.emailadr) is 0>
	<h4><cfoutput>#GetLangVal('mail_ph_error_no_address_provided')#</cfoutput></h4>
	<cfexit method="exittemplate">
</cfif>

<table border="0" cellspacing="0" cellpadding="4">
<form action="act_block_sender.cfm" method="post">
<input type="hidden" name="frmmailbox" value="<cfoutput>#htmleditformat(url.mailbox)#</cfoutput>">
<input type="hidden" name="frmuid" value="<cfoutput>#url.id#</cfoutput>">
  <tr class="mischeader">
    <td colspan="2"><b><cfoutput>#GetLangVal('mail_wd_block_header')#</cfoutput></b></td>
  </tr>
  <tr>
    <td align="right"><input checked type="radio" name="frmcbstring" value="<cfoutput>#htmleditformat(url.emailadr)#</cfoutput>" class="noborder"></td>
	
	<cfset a_str_text = GetLangVal("mail_ph_block_address_only")>
	<cfset a_str_text = Replacenocase(a_str_text, "%EMAIL%", htmleditformat(url.emailadr))>
    <td><cfoutput>#a_str_text#</cfoutput></td>
  </tr>
  
  <cfset ii = FindNoCase("@", url.emailadr)>
  <cfset a_str_domain = Mid(url.emailadr, ii+1, len(url.emailadr))>
  <tr>
    <td align="right"><input type="radio" name="frmcbstring" value="<cfoutput>#htmleditformat(a_str_domain)#</cfoutput>" class="noborder"></td>
	<cfset a_str_text = GetLangVal("mail_ph_block_whole_domain")>
	<cfset a_str_text = replacenocase(a_str_text, "%DOMAIN%", a_Str_domain)>
    <td><cfoutput>#a_str_text#</cfoutput></td>
  </tr>
  <tr class="mischeader">
    <td colspan="2"><b><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></b></td>
  </tr>
  <tr>
    <td align="right"><input checked type="radio" name="frmcbaction" value="move" class="noborder"></td>
    <td><cfoutput>#GetLangVal('mail_ph_block_move_to_trash')#</cfoutput></td>
  </tr>
  <tr>
    <td align="right"><input type="radio" name="frmcbaction" value="delete" class="noborder"></td>
    <td><cfoutput>#GetLangVal('mail_ph_block_delete_at_once')#</cfoutput></td>
  </tr>
  <tr class="mischeader">
    <td colspan="2"><b><cfoutput>#GetLangVal('mail_ph_block_original_message')#</cfoutput></b></td>
  </tr>
  <tr>
    <td align="right"><input class="noborder" type="checkbox" name="frmdeleteoriginalmessage" value="1" checked></td>
    <td ><cfoutput>#GetLangVal('mail_ph_block_delete_original_message')#</cfoutput></td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>"></td>
  </tr>
</form>
</table>