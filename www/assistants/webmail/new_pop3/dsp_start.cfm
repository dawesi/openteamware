<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="4">
<tr>
	<td colspan="2" height="45" style="font-size:15px;font-weight:bold;color:white;" bgcolor="#004080">
	&nbsp;&nbsp;<cfoutput>#GetLangVal('ass_ph_pop3_header1')#</cfoutput></td>
</tr>
<tr>
	<td width="200" bgcolor="#EEEEEE" align="right"  valign="bottom" >
	<img src="/images/assistants/webmail/new_email/email.jpg">
	<br>
	<br>
	<br>
	<br>
	<br>
	
	</td>

	<td valign="bottom"  style="background-color:white;">
	
	<div style="line-height:21px;">
	<cfoutput>#GetLangVal('ass_ph_pop3_page1_description')#</cfoutput>
	<br>
	<br>
	<br><br>

	<cfoutput>#GetLangVal('ass_ph_pop3_please_click_to_proceed')#</cfoutput>
	</div>
	</td>
</tr>
<form action="default.cfm" method="GET" enablecab="No">
<input type="hidden" name="action" value="step2">
<tr>
	<td  colspan="2" height="35" bgcolor="silver" align="right" style="border-top:gray solid 1px;">
	&nbsp;
	<input type="Submit" value="<cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput>">
	
	</td>
</tr>
</form>
</table>