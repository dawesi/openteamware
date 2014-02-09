<cfinclude template="../dsp_inc_select_company.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfquery name="q_select_activate_code" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	activatecodes
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<cfif q_select_activate_code.activated is 1>
	<cfoutput>#GetLangVal('adm_ph_customer_already_activated')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<!--- restart trial phase ... --->

<!--- check if e-mail address is ok --->
<cfset a_str_code = ''>

<cfloop from="1" to="5" index="ii">
	<cfset a_int_num_or_char = RandRange(0,3)>
	
	<cfif a_int_num_or_char LTE 2>
		<cfset a_str_code = a_str_code & Chr(RandRange(49,57))>
	<cfelse>
		<cfset a_str_code = a_str_code & Chr(RandRange(97,122))>
	</cfif>
	
</cfloop>

<cfif q_select_activate_code.recordcount IS 0>
	<!--- insert code now --->
	<cfinclude template="queries/q_insert_code.cfm">
</cfif>

<br><br>

<table border="0" cellspacing="0" cellpadding="4">
<form action="act_activate_account.cfm" method="post">
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('cm_wd_code')#</cfoutput>:
	</td>
    <td style="font-size:20px;border:orange solid 1px;padding:10px;">
		<cfif q_select_activate_code.recordcount IS 0>
			<cfoutput>#a_str_code#</cfoutput>
		<cfelse>
			<cfoutput>#q_select_activate_code.code#</cfoutput>
		</cfif>
	</td>
  </tr>
  <cfif Len(q_select_company_data.email) GT 0>
  <tr>
    <td>&nbsp;</td>
    <td>
		<br><br><br>
		<cfoutput>#GetLangVal('adm_ph_activation_email_adr_ava')#</cfoutput>!
		<br><br>
		<a style="color:#CC0000; " href="activate/act_send_activate_mail.cfm?<cfoutput>#writeurltags()#</cfoutput>"><img src="/images/menu/img_icon_email_32x32.gif" align="absmiddle" border="0"> <cfoutput>#ReplaceNoCase(GetLangVal('adm_ph_activation_send_mail_to'), '%EMAILADDRESS%', q_select_company_data.email)#</cfoutput></a>
		
		<br><br>
		<cfif val(q_select_activate_code.emailsent) IS 0>
			<b><cfoutput>#GetLangVal('adm_ph_activation_not_Sended_yet')#</cfoutput></b>
		</cfif>
	</td>
  </tr>
  </cfif>
</form>  
</table>