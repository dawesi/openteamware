<!--- //

	feedback form to partner

	// --->

<cfparam name="url.reason" type="string" default="">
<cfparam name="url.sent" type="numeric" default="0">

<cfinclude template="dsp_inc_select_company.cfm">

<br>

<cfif url.sent IS 1>
	<fieldset>
		<legend>Feedback Formular</legend>
		
		Ihre Anfrage wurde verschickt!
	</fieldset>
	<cfexit method="exittemplate">
</cfif>

<form style="margin:0px; " action="reseller/act_send_feedback_form.cfm" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
<fieldset>
	<legend>Feedback Formular</legend>
	
	
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td><cfoutput>#GetLangVal('cm_wd_subject')#</cfoutput>:</td>
		<td>
			<input type="text" name="frmsubject" size="40" value="<cfoutput>#htmleditformat(url.reason)#</cfoutput>">
		</td>
	  </tr>
	  <tr>
		<td valign="top">
			<cfoutput>#GetLangVal('cm_wd_Text')#</cfoutput>:
		</td>
		<td>
			<textarea name="frmbody" cols="40" rows="10"></textarea>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>
			<input type="submit" value="Absenden">
		</td>
	  </tr>
	</table>
	
</fieldset>

</form>