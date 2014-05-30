<!--- //

	Module:		Preferences
	Action:		emailaccounts
	Description:display all email accounts 
	

// --->

<cfinclude template="queries/q_select_all_email_data.cfm">

<cfset a_str_default_address = GetUserPrefPerson('email', 'defaultemailaccount', request.stSecurityContext.myusername, '', false) />

<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_top_link_email_accounts')) />

<cfsavecontent variable="a_str_content">


<cfquery name="q_select_all_email_data" dbtype="query">

SELECT * FROM q_select_all_email_data

ORDER BY origin,emailadr;

</cfquery>


<cfif q_select_all_email_data.recordcount IS 0>
	<div class="status">
	<h1>No e-mail address defined yet.</h1>
	To enable all features, you've to integrate an existing email address.
	<br /><br />
	<a href="index.cfm?action=addemailaccount">Click here to continue with the setup ...</a>
	</div>
</cfif>


<table class="table table-hover">

  <tr class="tbl_overview_header">

  	<td>&nbsp;</td>

  	<td><cfoutput>#GetLangVal('odb_wd_type')#</cfoutput></td>

    <td class="bb"><b><cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput></b></td>

	<td><cfoutput>#GetLangVal('cm_wd_server')#</cfoutput></td>

    <!--- <td align="center" width="70"><cfoutput>#GetLangVal('adm_ph_email_address_delete_on_server')#</cfoutput></td> --->

	<td align="center" width="70"><cfoutput>#GetLangVal('prf_ph_email_autocheck_min')#</cfoutput></td>

    <td><cfoutput>#GetLangVal('prf_wd_email_address_confirmed')#</cfoutput></td>

    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>

  </tr>

  <cfoutput query="q_select_all_email_data">

  <tr>

  	<td  <cfif Len(q_select_all_email_data.markcolor) gt 0>bgcolor="#q_select_all_email_data.markcolor#"</cfif>>## #q_select_all_email_data.currentrow#</td>  

  	<td>

	<cfif q_select_all_email_data.origin is 0>

		#GetLangVal('cm_wd_head_title_product')#

	<cfelse>

		#GetLangVal('prf_wd_email_type_external')#

	</cfif>

	</td>

    <td>

	<a style="font-weight:bold;" href="index.cfm?action=editemailaccount&id=#q_select_all_email_data.id#">#htmleditformat(q_select_all_email_data.emailadr)#</a>


	<cfif (q_select_all_email_data.emailadr is a_str_default_address) OR

		  ((LEN(a_str_default_address) LTE 5) AND (q_select_all_email_data.emailadr is request.stSecurityContext.myusername))>

		  <br /><b>#GetLangVal('prf_ph_email_is_standard_adr')#</b>

	</cfif>
	
<!--- 	<cfif q_select_all_email_data.origin is 0>
		<!--- load possible forwarding targets ... --->
		<cfset SelectEmailForwardingRequest.emailadr = q_select_all_email_data.emailadr>
		<cfinclude template="queries/q_select_email_forwarding_settings.cfm">
		
		<cfif q_select_forwarding.recordcount IS 1>
		<br /><br />  
		<img src="/images/icon/arrow_r_yellow.gif" align="absmiddle" vspace="2" hspace="2"> #GetLangVal('cm_wd_forwarding')#: #GetLangVal('cm_wd_yes')#<br>
		#GetLangVal('cm_ph_forwarding_target')#: #q_select_forwarding.destination#<br>
		#GetLangVal('cm_ph_forwarding_leave_copy')#: <cfif q_select_forwarding.leavecopy IS 0>#GetLangVal('cm_wd_no')#<cfelse>#GetLangVal('cm_wd_yes')#</cfif>
		</cfif>
	</cfif>	 --->

	</td>

	<td class="bb">#q_select_all_email_data.pop3server#</td>

	<cfif q_select_all_email_data.origin is 0>

	<td colspan="2" class="bb addinfotext" align="center">

		<!--- <cfif (request.stSecurityContext.myusername is q_select_all_email_data.emailadr)>

			<a href="index.cfm?action=emailaccessdata">#GetLangVal('email_ph_imap_pop3_smtp_access')# ...</a>

		<cfelse>

			#GetLangVal('mail_ph_ibx_address')#

		</cfif> --->

	</td>

	<cfelse>	

    <!--- <td align="center"><cfif q_select_all_email_data.deletemsgonserver is 1>#GetLangVal('cm_wd_yes')#<cfelse>#GetLangVal('cm_wd_no')#</cfif></td> --->

	<td align="center">#Val( q_select_all_email_data.autocheckminutes )#</td>

    <td>

	<cfif q_select_all_email_data.confirmed is 1>#GetLangVal('cm_wd_yes')#<cfelse>

	<font color="red">#GetLangVal('cm_wd_no')#</font><br>

	<a href="index.cfm?action=Requestconfirmationcode&id=#q_select_all_email_data.id#"><b>#GetLangVal('prf_ph_email_re_request_confirmation_code')#</b></a>	

	</cfif>

	</td>

	</cfif>

    <td class="bb" nowrap>

	<a href="act_set_standard_address.cfm?emailaddress=#urlencodedformat(q_select_all_email_data.emailadr)#"><img src="/images/si/star.png" class="si_img" /></a>

	&nbsp;

	<!--- <a href="index.cfm?action=editemailaccount&id=#q_select_all_email_data.id#"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_wd_edit')#</a>

	&nbsp; --->

	<a href="index.cfm?action=deleteemailaccount&id=#q_select_all_email_data.id#"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('cm_wd_delete')#</a>

	</td>

  </tr>  

  </cfoutput>
  


</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<!--- 	<input class="btn btn-primary" onClick="OpenNewInBoxccAdrAssistent();" type="button" value="<cfoutput>#GetLangVal('adm_ph_new_alias_address')#</cfoutput>">
<input class="btn btn-primary" onClick="OpenNewAssistent();" type="button" value="<cfoutput>#GetLangVal('email_ph_pop3_collector')# (#GetLangVal('cm_wd_new')#)</cfoutput>">
 --->

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('prf_ph_email_addresses'), a_str_buttons, a_str_content)#</cfoutput>
<br>

<cfset a_str_text = GetLangVal('mail_ph_click_here_to_set_standard_adr')>
<cfset a_str_text = ReplaceNoCase(a_str_text, '%IMAGE%', '<img src="/images/si/star.png" class="si_img" />') />
<cfoutput>#a_str_text#</cfoutput>
