<cfparam name="url.entrykey" type="string" default="">
<cfparam name="form.frmcbeditemailpwd" type="numeric" default="0">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>
<cfinclude template="../dsp_inc_select_company.cfm">


<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset a_str_text = GetLangVal('adm_ph_set_new_password_for_user')>
<cfset a_str_text = ReplaceNoCase(a_str_text, '%USERNAME%', stReturn.query.username)>

<h4><cfoutput>#GetLangVal('a_str_text')#</cfoutput></h4>

<cfif IsDefined("form.frmpwd1")>

<cfif Len(form.frmpwd1) IS 0>
	<cfoutput>#GetLangVal('adm_ph_change_password_empty')#</cfoutput>
	<br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfif CompareNoCase(form.frmpwd1, form.frmpwd2) NEQ 0>
	<cfoutput>#GetLangVal('adm_ph_change_password_invalid')#</cfoutput>
	<br><br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfif form.frmcbeditemailpwd IS 1>
	<!--- update email password ... --->
	<cfset a_bol_update_email_pwd = true>
<cfelse>
	<cfset a_bol_update_email_pwd = false>
</cfif>

<cfinvoke component="#application.components.cmp_user#" method="UpdatePassword" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="password" value="#form.frmpwd1#">
	<cfinvokeargument name="updatepop3password" value="#a_bol_update_email_pwd#">
</cfinvoke>

<b><cfoutput>#GetLangVal('adm_ph_password_has_been_changed')#</cfoutput></b><br><br>
<br>
<a href="index.cfm?action=userproperties&entrykey=<cfoutput>#url.entrykey##writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>

<cfelse>

<table border="0" cellspacing="0" cellpadding="4">
<form method="post" action="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>">
  <tr>
    <td align="right"><cfoutput>#GetLangVal('adm_ph_new_password')#</cfoutput>:</td>
    <td>
		<input type="password" name="frmpwd1" size="30">
	</td>
  </tr>
  <tr>
    <td align="right"><cfoutput>#GetLangVal('adm_ph_new_password_repeat')#</cfoutput>:</td>
    <td>
		<input type="password" name="frmpwd2" size="30">
	</td>
  </tr>
  <tr>
		<td align="right">
			<input type="checkbox" name="frmcbeditemailpwd" value="1" checked>
		</td>
		<td>
			<cfoutput>#GetLangVal('adm_ph_new_password_edit_imap_too')#</cfoutput>
		</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
  </tr>
</form>
</table>

</cfif>