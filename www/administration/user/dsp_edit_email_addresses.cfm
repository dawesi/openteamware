<!--- //

	Component:	Admintool
	Action:		EmailAddresses
	Description:
		Header:		

// --->

<!--- load addresses ... --->
<cfinvoke component="/components/email/cmp_accounts" method="GetEmailAccounts" returnvariable="q_select_pop3_data">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
</cfinvoke>

<cfinvoke component="/components/email/cmp_accounts" method="GetAliasAddresses" returnvariable="q_select_alias_addresses">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
</cfinvoke>

<cfoutput>#GetLangVal('cm_wd_mail')#</cfoutput>
<hr size="1" noshade />
<b><img src="/images/si/email.png" class="si_img" /> <cfoutput>#GetLangVal('cm_wd_forwarding')#</cfoutput></b>
<br />

<cfinvoke component="/components/email/cmp_accounts" method="GetForwarding" returnvariable="stReturn_forwarding">
	<cfinvokeargument name="emailaddress" value="#q_userdata.username#">
</cfinvoke>

<cfif stReturn_forwarding.exists IS FALSE>
	<cfoutput>#GetLangVal('cm_ph_forwarding_none_exists')#</cfoutput>
<cfelse>
	<cfoutput>#GetLangVal('cm_ph_forwarding_target')#</cfoutput>: <cfoutput>#stReturn_forwarding.destination#
	<br>
	<cfoutput>#GetLangVal('cm_ph_forwarding_leave_copy')#</cfoutput>: #YesNoFormat(stReturn_forwarding.leavecopy)#
</cfoutput>
</cfif>

<form action="user/act_create_forwarding.cfm" method="post">
<input type="hidden" name="frmuserkey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
<input type="hidden" name="frmusername" value="<cfoutput>#htmleditformat(q_userdata.username)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td align="right"><cfoutput>#GetLangVal('adm_ph_forwarding_target_address')#</cfoutput>:</td>
    <td>
		<input type="text" name="frmdestinationaddress" size="30" value="<cfoutput>#stReturn_forwarding.destination#</cfoutput>">
	</td>
  </tr>
  <tr>
    <td align="right"><cfoutput>#GetLangVal('cm_ph_forwarding_leave_copy')#</cfoutput>: </td>
    <td>
		<input type="checkbox" name="frmleavecopy" value="1" <cfoutput>#WriteCheckedElement(stReturn_forwarding.leavecopy, 1)#</cfoutput>>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
  </tr>
</table>
</form>

<hr size="1" noshade />
<b><img src="/images/si/email.png" class="si_img" /> <cfoutput>#GetLangVal('email_ph_imap_pop3_smtp_access')#</cfoutput></b>
<br><br>

<hr size="1" noshade />
<!--- select aliases ... --->
<b><img src="/images/si/email.png" class="si_img" /> <cfoutput>#GetLangVal('prf_ph_email_alias_addresses')#</cfoutput> (<cfoutput>#q_select_alias_addresses.recordcount#</cfoutput>)</b><br>
<cfoutput>#GetLangVal('adm_ph_alias_address_explanation')#</cfoutput>
<br /><br />  

<table border="0" cellspacing="0" cellpadding="4">
<cfoutput query="q_select_alias_addresses">
  <tr>
    <td>
	<li>#htmleditformat(q_select_alias_addresses.aliasaddress)#</li>
	</td>
    <td>
	<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="user/act_remove_alias_address.cfm?address=#urlencodedformat(q_select_alias_addresses.aliasaddress)#&userkey=#urlencodedformat(url.entrykey)##writeurltags()#">#GetLangVal('cm_wd_delete')#</a>
	</td>
  </tr>
</cfoutput>
</table>

<br /><br />  

<form action="user/act_create_alias.cfm" method="post" name="formnewalias">
<input type="hidden" name="frmuserkey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
<input type="hidden" name="frmusername" value="<cfoutput>#htmleditformat(q_userdata.username)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<i><cfoutput>#GetLangVal('adm_ph_new_alias_address')#</cfoutput></i><br>

<cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput>:

<input type="text" name="frmaliasusername" size="14" maxlength="50">
@

<select name="frmdomain">
	<cfloop list="#q_select_company_data.domains#" delimiters="," index="a_str_domain">
		<cfoutput>
		<option value="#a_str_domain#">#a_str_domain#</option>
		</cfoutput>
	</cfloop>
</select>

&nbsp;
<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_submit_btn_create')#</cfoutput>">

</form>

<cfquery name="q_select_external_addresses" dbtype="query">
SELECT
*
FROM
q_select_pop3_data
WHERE
origin = 1
;	
</cfquery>

<br><hr size="1" noshade />
<b><img src="/images/si/email.png" class="si_img" /> <cfoutput>#GetLangVal('adm_ph_external_addresses_pop3_collector')#</cfoutput> (<cfoutput>#q_select_external_addresses.recordcount#</cfoutput>)</b><br>



<cfif q_select_external_addresses.recordcount GT 0>
	<br /> 
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <cfoutput query="q_select_external_addresses">
	  <tr>
		<td>###q_select_external_addresses.currentrow#</td>
		<td>#q_select_external_addresses.emailadr#</td>
		<td>
			#q_select_external_addresses.pop3server#
		</td>
		<td>
			#q_select_external_addresses.pop3username#
		</td>
	  </tr>
	  
	  <cfquery name="q_select_exitcodes" datasource="#request.a_str_db_mailusers#">
	  	SELECT
	  		exitcode,dt_check
		FROM
			fetchmailexitcodes
		WHERE
			account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_userdata.username#">
			AND
			emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_external_addresses.emailadr#@#q_select_external_addresses.pop3server#">
		ORDER BY
			dt_check DESC
		LIMIT
			0,20
		;
	  </cfquery>
	  	  
	  <tr>
	  	<td></td>
		<td colspan="3">
			<cfloop query="q_select_exitcodes">
				#DateFormat(q_select_exitcodes.dt_check, 'dd.mm.yy')#&nbsp;#TimeFormat(q_select_exitcodes.dt_check, 'HH:mm')#
				&nbsp;
				<cfswitch expression="#q_select_exitcodes.exitcode#">
					<cfcase value="1">#GetLangVal('adm_ph_pop3_collector_result_no_new_messages')#</cfcase>
					<cfcase value="0">#GetLangVal('adm_ph_pop3_collector_result_messages_downloaded')#</cfcase>
					<cfcase value="3">#GetLangVal('adm_ph_pop3_collector_result_wrong_username_pwd')#</cfcase>
					<cfdefaultcase>#q_select_exitcodes.exitcode#</cfdefaultcase>
				</cfswitch>
				<br>
			</cfloop>
		</td>
	  </tr>
	  
	  </cfoutput>
	</table>
	
</cfif>

<br /><br />  
<hr size="1" noshade />
<cfoutput>
<a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(url.entrykey)#&companykey=#urlencodedformat(url.companykey)#&resellerkey=#urlencodedformat(url.resellerkey)#"><cfoutput>#GetLangVal('adm_ph_back_to_user_properties')#</cfoutput></a>
</cfoutput>

<SCRIPT type="text/javascript">
<!--//
// initialize the qForm object
objForm = new qForm("formnewalias");

// make these fields required
objForm.required("frmusername");
//-->
</SCRIPT> 

