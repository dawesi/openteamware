<!--- //



	display the access data for this user

	

	// --->
<cfinclude template="queries/q_select_all_email_data.cfm">

<cfquery name="q_select_accessdata" dbtype="query">
SELECT
	pop3username,pop3password,pop3server,id,emailadr
FROM
	q_select_all_email_data 
WHERE
	(origin = 0)
ORDER BY
	id
;
</cfquery>

<cf_disp_navigation mytextleft="#GetLangVal('prf_ph_imap_pop3_smtp_data')#">
<br>

  <cfoutput>#GetLangVal('prf_ph_pop3_imap_smtp_Access_intro')#</cfoutput> 
  <br>
  <br>
  <table border="0" cellspacing="0" cellpadding="4">
    <cfoutput query="q_select_accessdata" startrow="1" maxrows="1"> 
      <tr> 
        <td align="right">Server (IMAP):</td>
        <td>mail.openTeamWare.com</td>
      </tr>
	  <tr>
	  	<td align="right">Server (POP3):</td>
		<td>mail.openTeamWare.com</td>
	  </tr>
	  <tr>
	  	<td align="right">Server (SMTP):</td>
		<td>mail.openTeamWare.com (#GetLangVal('prf_ph_access_enable_auth')#)</td>
	  </tr>
      <tr> 
        <td align="right">#GetLangVal('cm_wd_username')#:</td>
        <td>#q_select_accessdata.emailadr#</td>
      </tr>
      <tr> 
        <td align="right">#GetLangVal('cm_Wd_password')#:</td>
        <td>
		<a href="javascript:window.alert('#jsstringformat(q_select_accessdata.pop3password)#');">#GetLangVal('cm_wd_show')#</a>
		 [ <a href="default.cfm?action=editemailaccount&id=#q_select_accessdata.id#">#GetLangVal('cm_Wd_edit')#</a> ]</td>
      </tr>
	  <tr>
	  	<td></td>
		<td>
  <br>
  <i>
  <cfoutput>#GetLangVal('prf_ph_email_access_recommendations')#</cfoutput>
  </i>
		</td>
	  </tr>
    </cfoutput> 
  </table>
  <!---<br>
  <b>Wir empfehlen den Zugriff via IMAP, da in diesem Fall auch die Ordnerstruktur 
  erhalten bleibt!</b> <br>
  <b>Aktivieren Sie nach M&ouml;glichkeit auch den SSL Zugriff in Ihrem E-Mail 
  Client.</b> --->

<br>
<br>
<a href="default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('cm_Wd_back')#</cfoutput></a>