<!--- //

	Module:		E-Mail
	Action:		Extras
	Description: 
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_extras')) />

<div class="b_all mischeader" style="width:500px;padding:10px;margin-top:14px;">

<cfinvoke component="#application.components.cmp_email_tools#" method="GetQuotaDataForUser" returnvariable="a_struct_quota">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>

<cfset a_int_one_percent = a_struct_quota.maxsize / 100 />
<cfif a_int_one_percent IS 0>
	<cfset a_int_one_percent = 1 />
</cfif>
<cfset a_int_percent = Int(val(a_struct_quota.currentsize / a_int_one_percent))>

<table border="0" cellspacing="0" cellpadding="5" width="100%">
  <tr>
    <td colspan="2">
	<b><cfoutput>#GetLangVal('mail_ph_mailbox_usage')#</cfoutput></b>
	<br />
	<div class="b_all" style="width:400px;margin-top:10px;">
	<span class="br" style="background-color:silver;width:<cfoutput>#(a_int_percent * 4)#</cfoutput>%;">&nbsp;</span>
	</div>
	</td>
  </tr>
  <cfoutput>
  <tr>
    <td align="center" width="50%">
	<cfoutput>#GetLangVal('mail_ph_mailbox_usage_current_size')#</cfoutput>: #byteConvert(a_struct_quota.currentsize)#
	</td>
    <td align="center" width="50%">
	<cfoutput>#GetLangVal('mail_ph_mailbox_usage_max_size')#</cfoutput>: #byteConvert(a_struct_quota.maxsize)#
	</td>
  </tr>
  </cfoutput>
</table>



</div>
<br />

<table class="table_details">
	<tr>
		<td class="field_name">
			<a style="font-weight:bold; "  href="../settings/default.cfm?action=spamguard"><cfoutput>#GetLangVal("mail_wd_extras_spamguard")#</cfoutput></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_wd_extras_spamguard_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a  href="default.cfm?action=filter"><b><cfoutput>#GetLangVal("mail_wd_filter")#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_wd_extras_filter_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a href="/signedmail/" ><b><cfoutput>#GetLangVal("mail_ph_extras_encryptsign")#</cfoutput></b></a>
			<!---<img src="/images/email/img_signedmail_32x32.gif" width="32" height="32" border="0">--->
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_extras_encryptsign_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a href="../mobile/" ><b><cfoutput>#GetLangVal("mail_ph_extras_mobileaccess")#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_extras_mobileaccess_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a href="default.cfm?action=alerts"><b><cfoutput>#GetLangVal("mail_wd_extras_reminder")#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_wd_extras_reminder_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a href="default.cfm?action=autoanswer" ><b><cfoutput>#GetLangVal('email_ph_autoreply')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_autoreply_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a href="../settings/default.cfm?action=emailaccessdata" ><b><cfoutput>#GetLangVal('email_ph_imap_pop3_smtp_access')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_imap_access_description")#</cfoutput>
		</td>
	</tr>	
	<tr>
		<td class="field_name">
			<a href="../settings/default.cfm?action=emailaccounts" ><b><cfoutput>#GetLangVal('email_ph_pop3_collector')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_pop3_coll_description")#</cfoutput>
			<ul>
				<li><a href="default.cfm?action=pop3check"><cfoutput>#GetLangVal('mail_ph_pop3_coll_manual_check')#</cfoutput></a></li>

				<li><a href="default.cfm?action=logbookexternalaccounts"><cfoutput>#GetLangVal('mail_ph_pop3_coll_logbook')#</cfoutput></a></li>

			</ul>
		</td>
	</tr>	
	<tr>
		<td class="field_name">
			<a href="../settings/default.cfm?action=mailaccessdata" ><b><cfoutput>#GetLangVal('mail_ph_further_ibx_addresses')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_further_ibx_addresses_description")#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a href="../settings/default.cfm?action=signatures" ><b><cfoutput>#GetLangVal('mail_ph_email_signatures')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_email_signatures_description")#</cfoutput>
		</td>
	</tr>		
	<tr>
		<td class="field_name">
			<a href="../settings/default.cfm?action=emailaccounts"><b><cfoutput>#GetLangVal('mail_ph_standard_address')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("mail_ph_standard_address_description")#</cfoutput>
		</td>
	</tr>		
	<tr>
		<td class="field_name">
			<a href="/administration/?action=shop" target="_blank"><b><cfoutput>#GetLangVal('cm_ph_shop_increase_space')#</cfoutput></b></a>
		</td>
		<td>
			<cfoutput>#GetLangVal("cm_ph_shop_increase_space_description")#</cfoutput>
		</td>
	</tr>			
</table>

