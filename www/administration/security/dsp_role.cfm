
<cfinclude template="../dsp_inc_select_company.cfm"/>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityRole" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfset q_select_role = stReturn.q_select_security_role>
<cfset q_select_securityroles_ip_restrictions = stReturn.q_select_securityroles_ip_restrictions>

<br>
<a href="index.cfm?action=security<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_security_roles_goto_overview')#</cfoutput></a>
<br><br>
<table border="0" cellspacing="0" cellpadding="4">
<cfoutput query="q_select_role">
  <tr>
    <td align="right"><b>#GetLangVal('cm_wd_subject')#:</b></td>
    <td>
		<b>#htmleditformat(q_select_role.rolename)#</b>
	</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_description')#:</td>
    <td>
		#q_select_role.description#
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_protocol')#:</td>
	<td>
		#q_select_role.protocol_depth#
	</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_created')#:</td>
    <td>
		#DateFormat(q_select_role.dt_created, 'dd.mm.yy')#
	</td>
  </tr>
  <tr>
    <td colspan="2" class="bb">#GetLangVal('cm_wd_preferences')#</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_storage_external')#:</td>
	<td>
		#YesNoFormat(q_select_role.allow_ftp_access)#
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_ssl_only')#:</td>
	<td>
		#YesNoFormat(q_select_role.allow_www_ssl_only)#
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_pda_access')#:</td>
	<td>
		#YesNoFormat(q_select_role.allow_pda_login)#
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_wap_access')#:</td>
	<td>
		#YesNoFormat(q_select_role.allow_wap_login)#
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_outlooksync')#:</td>
	<td>
		#YesNoFormat(q_select_role.allow_outlooksync)#
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adm_ph_security_role_email_access_data')#:</td>
	<td>
		#YesNoFormat(q_select_role.ALLOW_MAILACCESSDATA_ACCESS)#
	</td>
  </tr>    
 </cfoutput>
 <tr>
 	<td align="right" valign="top">#GetLangVal('adm_ph_security_role_restrict_ip_access')#:</td>
	<td>
	<cfoutput>#YesNoFormat(q_select_securityroles_ip_restrictions.recordcount)#</cfoutput>
	<br>
	
	
	</td>
 </tr>
 <cfinvoke component="#application.components.cmp_security#" method="GetUsersUsingRole" returnvariable="q_select_users"
 	entrykey=#url.entrykey#
	companykey=#url.companykey#>	
 </cfinvoke>
 <tr>
 	<td colspan="2" class="bb"><cfoutput>#GetLangVal('adm_ph_security_role_apply_to')#</cfoutput> (<cfoutput>#q_select_users.recordcount#</cfoutput>)</td>
 </tr>

		
 <tr>
 	<td></td>
	<td>
	<cfoutput query="q_select_users">
	#q_select_users.surname#, #q_select_users.firstname# (#q_select_users.username#) <a href="index.cfm?action=securityrole.removeuser&rolekey=#urlencodedformat(url.entrykey)#&userkey=#urlencodedformat(q_select_users.entrykey)##WriteURLTags()#">#si_img('delete')#</a><br>
	</cfoutput>
	</td>
 </tr>
</table>
<br><br>

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="../queries/q_select_company_users.cfm">

<cfquery name="q_select_company_users" dbtype="query">
SELECT
	*
FROM
	q_select_company_users
WHERE
	<cfloop query="q_select_users">
	(
		NOT entrykey = '#q_select_users.entrykey#'
	)
	AND
	</cfloop>
	(1=1)
;
</cfquery>

<br>

<table border="0" cellspacing="0" cellpadding="4">
<form action="security/act_add_user_to_role.cfm" method="post">
<input type="hidden" name="frmrolekey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
  <tr class="lightbg">
    <td>
		<b><cfoutput>#GetLangVal('adm_ph_security_role_apply_to_new')#</cfoutput></b>
	</td>
  </tr>
  <tr>
    <td>
	<select name="frmuserkey">
		<option value=""><cfoutput>#GetLangVal('cm_ph_please_select')#</cfoutput></option>
		<cfoutput query="q_select_company_users">
			<option value="#q_select_company_users.entrykey#">#q_select_company_users.surname#, #q_select_company_users.firstname# (#q_select_company_users.username#)</option>
		</cfoutput>
	</select>
	</td>
  </tr>
  <tr>
    <td>
	<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_wd_add')#</cfoutput>">
	</td>
  </tr>
</form>
</table>