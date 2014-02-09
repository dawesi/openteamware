
<cfinvoke component="#request.a_str_component_licence#" method="GetAvailableQuota" returnvariable="a_int_quota">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfinvoke component="#request.a_str_component_licence#" method="GetAvailablePoints" returnvariable="a_int_points">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_email_tools#" method="GetQuotaDataForUser" returnvariable="a_struct_quota">
	<cfinvokeargument name="username" value="#q_userdata.username#">
</cfinvoke>

<h4><cfoutput>#GetLangVal('adm_ph_edit_quota')#</cfoutput></h4>

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td colspan="2" class="bb">
		<cfoutput>#GetLangVal('adm_ph_edit_quota_current_data')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_edit_quota_current_size')#</cfoutput>:
	</td>
    <td>
		<cfoutput>#byteConvert(a_struct_quota.currentsize)#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_edit_quota_maximal')#</cfoutput>:
	</td>
    <td>
		<cfoutput>#byteConvert(a_struct_quota.maxsize)#</cfoutput>
	</td>
  </tr>
</table>

<br>

<cfif a_int_quota GT 0>
 


<table border="0" cellspacing="0" cellpadding="4">
  <form action="user/act_edit_quota.cfm" method="post">
  
  <cfoutput>
  <input type="hidden" name="frmuserkey" value="#url.entrykey#">
  <input type="hidden" name="frmcompanykey" value="#url.companykey#">
  <input type="hidden" name="frmresellerkey" value="#url.resellerkey#">
  <input type="hidden" name="frmusername" value="#htmleditformat(q_userdata.username)#">
  </cfoutput>
  
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_edit_quota_add')#</cfoutput>:
	</td>
    <td>
	<select name="frmaddquota">
		<cfloop from="100" to="#a_int_quota#" index="ii" step="50">
			<cfoutput>
			<option value="#ii#">#ii#</option>
			</cfoutput>
		</cfloop>
	</select> MB
	</td>
	</tr>
	<tr>
	<td align="right">
		<cfoutput>#GetLangVal('adm_ph_edit_quota_type')#</cfoutput>:
	</td>
	<td>
		<select name="frmtype">
			<option value="email">E-Mail</option>
			<!---<option value="storage">Dateiablage</option>--->
		 </select>
	</td>
	</tr>
	<tr>
		<td></td>
    <td>
		<input type="submit" value="<cfoutput>#GetLangVal('adm_wd_add')#</cfoutput>">
	</td>
  </tr>
  </form>
</table>

<cfelse>
	<b><cfoutput>#GetLangVal('adm_ph_edit_quota_buy')#</cfoutput></b>
	<br><br><br>
	<a href="default.cfm?action=shop<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_goto_shop')#</cfoutput></a>
</cfif>

<!---<br><br><br>
<h4>Punkte editieren</h4>--->