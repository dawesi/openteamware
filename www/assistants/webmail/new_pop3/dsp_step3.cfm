<!--- // check if this address is already in use // --->
<cfquery name="q_select_email_exists" datasource="#request.a_str_db_users#">
SELECT
	count(id) AS count_id
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmEmailAdr#">
;
</cfquery>

<cfif q_select_email_exists.count_id neq 0>
	<br>
	<br>
	<p><cfoutput>#GetLangVal('ass_ph_pop3_already_included')#</cfoutput></p>
	
	<a href="default.cfm"><cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput></a>
	<cfabort>
</cfif>

<cfif len(extractemailadr(form.frmEmailAdr)) is 0>
	<br><br>
	<b><cfoutput>#GetLangVal('ass_ph_pop3_invalid_address')#</cfoutput></b>
	<br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>


<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="4">
<form action="default.cfm?action=step4" method="POST" enablecab="No">
<cfoutput>
<input type="Hidden" name="frmDisplayName" value="#htmleditformat(form.frmDisplayName)#">
<input type="Hidden" name="frmEmail" value="#htmleditformat(form.frmEmailAdr)#">
</cfoutput>
<tr>
	<td colspan="2" height="45" style="font-size:15px;font-weight:bold;color:white;" bgcolor="#004080">
	&nbsp;&nbsp;<cfoutput>#GetLangVal('ass_ph_pop3_email_address_data')#</cfoutput></td>
</tr>
<tr>
	<td colspan="2" bgcolor="#ffffff">

	
		<table border="0" cellspacing="0" cellpadding="6" align="center">
		<tr>
			<td align="right">
				<cfoutput>#GetLangVal('ass_ph_pop3_email_address')#</cfoutput>
			</td>
			<td><b><cfoutput>#form.frmEmailAdr#</cfoutput></b></td>
		</tr>
		<tr>
			<td colspan="2" style="border-top:silver solid 1px;line-height:16px;">
			<cfoutput>#GetLangVal('ass_ph_pop3_enter_access_data')#</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="right"><cfoutput>#GetLangVal('ass_ph_pop3_pop3server')#</cfoutput></td>
			<td><input tabindex="1" type="text" name="frmPOPServer" size="25" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right"><cfoutput>#GetLangVal('ass_ph_pop3_pop3username')#</cfoutput></td>
			<td><input tabindex="2" type="text" name="frmPOPUsername" size="25" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right"><cfoutput>#GetLangVal('ass_ph_pop3_pop3password')#</cfoutput></td>
			<td><input tabindex="3" type="password" name="frmPOPPassword" size="25" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right"></td>
			<td><input type="Checkbox" tabindex="4"  name="frmLeaveMsgOnServer" value="on"> <cfoutput>#GetLangVal('ass_ph_pop3_leavemessagesonserver')#</cfoutput></td>
		</tr>
		</table>

	
	</td>
</tr>

<tr>
	<td align="35" bgcolor="silver" style="border-top:gray solid 1px;">
	<input type="button" value="Abbrechen" onclick="javascript:CancelAssistant();">
	</td>
	<td  height="35" bgcolor="silver" align="right" style="border-top:gray solid 1px;">
	<input type="button" value="zur&uuml;ck" onclick="javascript:history.go(-1);">
	&nbsp;
	<input type="Submit" style="font-weight:bold;" tabindex="5"  value="<cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput>">
	
	</td>
</tr>
</form>
</table>