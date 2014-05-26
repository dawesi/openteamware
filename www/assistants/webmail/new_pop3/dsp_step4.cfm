<!--- checks durchf&uuml;hren --->

<!--- check inputs ... --->
<cfparam name="form.frmPOPUsername" type="string" default="">
<cfparam name="form.frmPOPPassword" type="string" default="">
<cfparam name="form.frmPOPServer" type="string" default="">

<cfif Len(form.frmPOPServer) is 0>
	<br><br>
	<cfoutput>#GetLangVal('ass_ph_pop3_invalid_pop3server')#</cfoutput>
	<br><br>
	<a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfif Len(form.frmPOPUsername) is 0>
	<br><br>
	<cfoutput>#GetLangVal('ass_ph_pop3_invalid_pop3username')#</cfoutput>
	<br><br>
	<a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfif Len(form.frmPOPPassword) is 0>
	<br><br>
	<cfoutput>#GetLangVal('ass_ph_pop3_invalid_pop3password')#</cfoutput>
	<br><br>
	<a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfset AConfirmCode = "">
	
	<cfloop index="ii" from="1" to="11" step="1">
		<cfset i = RandRange(97, 122)>
		<cfset AConfirmCode = AConfirmCode & Chr(i)>
	</cfloop>
	
<cfif IsDefined("form.frmLeaveMsgOnServer")>
	<cfset ADelMsgOnServer = 0>
<cfelse>
	<cfset ADelMsgOnServer = 1>
</cfif>

<!--- try to connect to this address ... --->
<cfinvoke component="/components/email/cmp_tools" method="TestPOP3Account" returnvariable="sReturn">
	<cfinvokeargument name="server" value="#form.frmPOPServer#">
	<cfinvokeargument name="username" value="#form.frmPOPUsername#">
	<cfinvokeargument name="password" value="#form.frmPOPPassword#">
</cfinvoke>

<cfif sReturn is "ERROR">
	<br><br>
	<cfoutput>#GetLangVal('ass_ph_pop3_invalid_access_data')#</cfoutput>
	<br><br>
	<a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfinclude template="queries/q_insert_pop3_data.cfm">

<cfset a_int_accountid = q_select_newid.id>

<cfinclude template="queries/q_insert_fetchmail.cfm">

<!--- id holen --->
	
<!--- email mit der best&auml;tigung usw schicken --->
<cfmodule template="../../../settings/mod_send_email_confirm.cfm" id=#a_int_accountid# userid=#request.stSecurityContext.myuserid# username=#request.stSecurityContext.myuserid#>


<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="4">
<tr>
	<td colspan="2" height="45" style="font-size:15px;font-weight:bold;color:white;" bgcolor="#004080">
	&nbsp;&nbsp;<cfoutput>#GetLangVal('ass_ph_pop3_done')#</cfoutput>&nbsp;</td>
</tr>
<tr>
	<td colspan="2" bgcolor="#ffffff" style="line-height:16px;padding:5px;">
<br>
<br>
	<cfoutput>#GetLangVal('ass_ph_pop3_done_text')#</cfoutput>
	
	</td>
</tr>
<form>
<tr>
	<td  colspan="2" height="35" bgcolor="silver" align="right" style="border-top:gray solid 1px;">

	&nbsp;
	<input onclick="window.close();" type="Submit" style="font-weight:bold;" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>">
	
	</td>
</tr>
</form>
</table>