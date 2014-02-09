<!--- //

	Module:		E-Mail
	Action:		Alerts
	Description: 
	

// --->
<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_wd_alerts')) />

<cfset q_select_all_pop3_data = request.stSecurityContext.q_select_all_email_addresses />

<cfif NOT StructKeyExists(url, 'accountid')>
	
  <!--- der user soll einmal den account ausw&auml;hlen, dessen einstellungen

		  er &auml;ndern will --->
  <form action="default.cfm" method="get">
    <input type="hidden" name="action" value="Alerts">
    <b><cfoutput>#GetLangVal('mail_ph_alerts_select_address')#</cfoutput></b><br />
    <br />
    <select name="accountid">
      <cfoutput query="q_select_all_pop3_data"> 
        <option value="#q_select_all_pop3_data.id#">#htmleditformat(q_select_all_pop3_data.emailadr)# 
      </cfoutput> 
    </select>
    <br />
    <br />
    <input type="Submit" value="<cfoutput>#GetLangVal('mail_ph_alerts_show_settings')#</cfoutput>" class="btn" />
  </form>
  <cfexit method="EXITTEMPLATE">
</cfif>

<!--- daten holen --->
<cfparam name="url.accountid" type="numeric">

<cfquery name="q_select_account" datasource="#request.a_str_db_users#">
SELECT
	emailadr
FROM
	pop3_data
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
	AND
	(id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.accountid#">)
; 
</cfquery>

<cfif q_select_account.recordcount IS 0>
	no address found.
	<cfexit method="exittemplate">
</cfif>

<form action="act_save_alert_settings.cfm" method="POST">
  <input type="Hidden" name="frmaccountid" value="<cfoutput>#url.accountid#</cfoutput>">
  <table>
    <tr> 
      <td valign="top">
	  
	  	<cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput>: <b><cfoutput><font color="##004080">#htmleditformat(q_select_account.emailadr)#</font></cfoutput></b>
		
		[<a href="default.cfm?action=Alerts"><cfoutput>#GetLangVal('mail_ph_enable_sms_alerts_select_other')#</cfoutput></a>]
		
		<br /><br />
		
		<cfset SelectSMSAlertSettings.Accountid = url.accountid> 
        <cfinclude template="queries/q_select_sms_alert_settings.cfm">
		
		<table border="0" cellspacing="0" cellpadding="5" style="border:silver solid 1px;">
          <tr> 
            <td style="font-weight:bold; "> <input type="Checkbox" name="frmsms_alert_enabled" <cfif q_select_sms_alert_settings.recordcount gt 0>checked</cfif> class="noborder">
              <cfoutput>#GetLangVal('mail_ph_enable_sms_alerts')#</cfoutput> </td>
          </tr>
          <tr> 
            <td>
			  <cfoutput>#GetLangVal('cm_wd_maximal')#</cfoutput> 
              <select name="frmsms_alerts_per_day">
                <cfoutput> 
                  <option value="1" #WriteSelectedElement(q_select_sms_alert_settings.maxperday, 1)#>1 
                  <option value="2" #WriteSelectedElement(q_select_sms_alert_settings.maxperday, 2)#>2 
                  <option value="3" #WriteSelectedElement(q_select_sms_alert_settings.maxperday, 3)#>3 
                  <option value="5" #WriteSelectedElement(q_select_sms_alert_settings.maxperday, 5)#>5 
                  <option value="10" #WriteSelectedElement(q_select_sms_alert_settings.maxperday, 10)#>10 
                  <option value="20" #WriteSelectedElement(q_select_sms_alert_settings.maxperday, 20)#>20 
                </cfoutput> 
              </select>
              <cfoutput>#GetLangVal('mail_ph_enable_sms_alerts_max_per_day')#</cfoutput>
			  
			</td>
          </tr>
          <tr> 
            <td> <font color="#004080"><cfoutput>#GetLangVal('mail_ph_sms_alerts_exclude_list')#</cfoutput>:</font><br />
			  
			  <textarea cols="45" rows="5" name="frmadr_sms_no_alerts"><cfoutput>#trim(q_select_sms_alert_settings.excludeadr)#</cfoutput></textarea> 
			  	<br />
				<div style="width:400px; ">
					 <cfoutput>#GetLangVal('mail_ph_alert_exception')#</cfoutput>
				</div>
            </td>
          </tr>
          <tr> 
            <td style="font-weight:bold; ">
			  <input class="noborder" <cfoutput>#writecheckedelement(q_select_sms_alert_settings.nonightalerts, 1)#</cfoutput> type="checkbox" name="FRMNONIGHTALERTS" value="1"> 
              <cfoutput>#GetLangVal('mail_ph_enable_sms_alerts_no_night_alerts')#</cfoutput> </td>
          </tr>
        </table>
        <br /> 
        <!--- // alert to external email address // --->
        <cfset SelectEmailAlertSettings.accountid = url.accountid> <cfinclude template="queries/q_select_email_alert_settings.cfm"> 
        <table border="0" cellspacing="0" cellpadding="5" style="border:silver solid 1px;">
          <tr> 
            <td>
				<input class="noborder" type="Checkbox" <cfif q_select_email_alert_settings.recordcount gt 0>checked</cfif> name="frmemail_alert_enabled">
              <cfoutput>#GetLangVal('mail_ph_enable_alerts_ext_emailadr')#</cfoutput>
			  				
			 </td>
          </tr>
          <tr> 
            <td> <table border="0" cellspacing="0" cellpadding="4">
                <tr> 
                  <td align="right"><cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput>:</td>
                  <td>
				  	<input type="text" name="frmalertexternaladdress" value="<cfoutput>#htmleditformat(q_select_email_alert_settings.emailaddress)#</cfoutput>" size="30" maxlength="150">

				  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td class="addinfotext"><cfoutput>#GetLangVal('mail_ph_alerts_email_adr_example')#</cfoutput></td>
                </tr>
              </table></td>
          </tr>
        </table>
        <br /> <input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"> </td>
      <td valign="top" style="line-height:16px;" width="200">
	  
	   
		<br /> <br />
		
		<b><cfoutput>#GetLangVal('mail_ph_alert_current_data')#</cfoutput></b><br />
        <cfoutput>#GetLangVal('mail_ph_alert_mobile_nr')#</cfoutput>:<br /> <cfoutput>#request.a_struct_personal_properties.myMobileTelNr#</cfoutput> <br /> <br />
        [<a href="/settings/"><cfoutput>#GetLangVal('mail_ph_alerts_edit_settings')#</cfoutput></a>]
		
		<br /> <br /> 
        <b><cfoutput>#GetLangVal('mail_ph_alerts_costs')#</cfoutput></b><br />
        <a href="/rd/pricelist/" target="_blank"><cfoutput>#GetLangVal('mail_ph_alerts_costs_pricelist')#</cfoutput></a>
        

		</td>
    </tr>
  </table>
</form>



