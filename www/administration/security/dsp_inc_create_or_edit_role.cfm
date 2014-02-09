
<cfparam name="CreateOrEditRole.action" type="string" default="create">
<cfparam name="CreateOrEditRole.Query" type="query" default="#QueryNew('entrykey,rolename,allow_ftp_access,description,,protocol_depth,allow_www_ssl_only,allow_pda_login,allow_wap_login,allow_outlooksync,allow_ftp_access,allow_mailaccessdata_access')#">



<table cellspacing="0" cellpadding="4" border="0">
<cfif CreateOrEditRole.action IS 'create'>
<form action="security/act_new_security_role.cfm" method="post">
<input type="hidden" name="frmentrykey" value="<cfoutput>#CreateUUID()#</cfoutput>">
<cfelse>
<form action="act_edit_security_role.cfm" method="post">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(CreateOrEditRole.Query.entrykey)#</cfoutput>">
</cfif>
<input type="Hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="Hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">

<cfif CreateOrEditRole.action IS 'create'>
	<cfset tmp = QueryAddRow(CreateOrEditRole.query, 1)>
	<cfset tmp = QuerySetCell(CreateOrEditRole.query, 'protocol_depth', 5, 1)>
	<cfset tmp = QuerySetCell(CreateOrEditRole.query, 'allow_ftp_access', 1, 1)>
	<cfset tmp = QuerySetCell(CreateOrEditRole.query, 'allow_pda_login', 1, 1)>
	<cfset tmp = QuerySetCell(CreateOrEditRole.query, 'allow_wap_login', 1, 1)>
	<cfset tmp = QuerySetCell(CreateOrEditRole.query, 'allow_outlooksync', 1, 1)>
	<cfset tmp = QuerySetCell(CreateOrEditRole.query, 'allow_mailaccessdata_access', 1, 1)>
</cfif>

<tr>
    <td align="right"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:</td>
    <td>
	<input type="Text"  name="frmrolename" size="30" value="<cfoutput>#htmleditformat(CreateOrEditRole.query.rolename)#</cfoutput>">
	</td>
</tr>
<tr>
    <td align="right"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:</td>
    <td>
	<input type="Text" name="frmdescription" size="30"  value="<cfoutput>#htmleditformat(CreateOrEditRole.query.description)#</cfoutput>">
	</td>
</tr>
<tr>
    <td align="right" valign="top" style="padding-top:6px;"><cfoutput>#GetLangVal('cm_wd_preferences')#</cfoutput></td>
    <td valign="top">
	
		<table border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="2">
				<cfoutput>#GetLangVal('adm_ph_security_role_protocol')#</cfoutput>: 
				<select name="frmprotocoldepth">
					<option value="10" <cfoutput>#WriteSelectedElement(CreateOrEditRole.query.protocol_depth, 10)#</cfoutput>><cfoutput>#GetLangVal('adm_ph_security_role_protocol_density_high')#</cfoutput>
					<option value="5" <cfoutput>#WriteSelectedElement(CreateOrEditRole.query.protocol_depth, 5)#</cfoutput>><cfoutput>#GetLangVal('adm_ph_security_role_protocol_density_default')#</cfoutput>
					<option value="1" <cfoutput>#WriteSelectedElement(CreateOrEditRole.query.protocol_depth, 1)#</cfoutput>><cfoutput>#GetLangVal('adm_ph_security_role_protocol_density_low')#</cfoutput>								
				</select>
			</td>
		</tr>
		<tr>
			<td align="right">
				<input type="Checkbox" name="frmcballow_www_ssl_only" value="1" <cfoutput>#WriteCheckedElement(CreateOrEditRole.query.allow_www_ssl_only, 1)#</cfoutput>>
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_security_role_ssl_only')#</cfoutput>
			</td>
		</tr>		
		<tr>
			<td align="right">
				<input type="Checkbox" name="frmcballowmailaccessdata" value="1" <cfoutput>#WriteCheckedElement(CreateOrEditRole.query.allow_mailaccessdata_access, 1)#</cfoutput>>
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_security_role_email_access_data')#</cfoutput>
			</td>
		</tr>				
		<tr>
			<td align="right">
				<input type="Checkbox" name="frmcballowpdalogin" value="1" <cfoutput>#WriteCheckedElement(CreateOrEditRole.query.allow_pda_login, 1)#</cfoutput>>
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_security_role_pda_access')#</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="right">
			<input type="Checkbox" name="frmcballowftpacces" value="1" <cfoutput>#WriteCheckedElement(CreateOrEditRole.query.allow_ftp_access, 1)#</cfoutput>>
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_security_role_storage_external')#</cfoutput>
			</td>
		</tr>		
		<tr>
			<td align="right">
			<input type="Checkbox" name="frmcballowwaplogin" value="1"  <cfoutput>#WriteCheckedElement(CreateOrEditRole.query.allow_wap_login, 1)#</cfoutput>>
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_security_role_wap_access')#</cfoutput>
			</td>
		</tr>			
		<tr>
			<td align="right">
			<input type="Checkbox" name="frmcballowoutlooksync" value="1"  <cfoutput>#WriteCheckedElement(CreateOrEditRole.query.allow_outlooksync, 1)#</cfoutput>>
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_security_role_outlooksync')#</cfoutput>
			</td>
		</tr>		

		<tr>
			<td></td>
			<td></td>
		</tr>
		</table>

	
	</td>
</tr>
<tr>
    <td align="right" valign="top"><cfoutput>#GetLangVal('adm_ph_security_role_restrict_ip_access')#</cfoutput>:</td>
    <td valign="top">
	<input type="text" name="frmip" size="40">
	<br>
	<cfoutput>#GetLangVal('adm_ph_current_address')#</cfoutput>: <cfoutput>#cgi.REMOTE_ADDR#</cfoutput>
	<br>
	<font color="gray"><cfoutput>#GetLangVal('cm_wd_example')#</cfoutput>: 80.90.100.120,80.90.11.121</font>
	</td>
</tr>
<tr>
    <td align="right"></td>
    <td><input type="Submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
</tr>
</form>
</table>