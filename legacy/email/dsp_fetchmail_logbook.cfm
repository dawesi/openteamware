<!--- //

	Module:		E-Mail
	Action:		FetchmailLogbook
	Description:display log book of fetching of external email accounts 
	
// --->

<cfinclude template="queries/q_select_all_pop3_data.cfm">

<cfparam name="url.detailemailaddress" default="" type="string">



<cfinclude template="queries/q_select_fetchmail_logbook.cfm">


<!--- fetchmail exitcodes --->

<cfscript>
	function ReturnExitCode(aexitcode) {
		var areturn = GetLangVal("mail_ph_fm_exitcode_unknown");
		switch(aexitcode)
			{
			case "0":
				{
				areturn = GetLangVal("mail_ph_fm_exitcode_0");
				break;
				}
			case "1":
				{
				areturn = GetLangVal("mail_ph_fm_exitcode_1");
				break;
				}
			case "3":
				{
				areturn = GetLangVal("mail_ph_fm_exitcode_3");
				break;
				}
			case "7":
				{
				areturn = GetLangVal("mail_ph_fm_exitcode_7");
				break;
				}
			case "11":
				{
				areturn = GetLangVal("mail_ph_fm_exitcode_11");
				break;
				}																

			}
		return areturn;
		}
</cfscript>

	
<cfset tmp = SetHeaderTopInfoString("Logbuch der &Uuml;berpr&uuml;fung externer Adressen") />



<cfif q_select_all_pop3_data.recordcount is 0>

	Sie haben keine externen Konten definiert.

	<br />

	<br />

	<a href="../settings/index.cfm?action=index.cfm?action=emailaccounts" class="simpelink">Klicken Sie hier, um nun externe E-Mail Adresse einzubinden (POP3-Sammeldienst)</a>

	<cfexit method="exittemplate">

</cfif>



<cfset SelectExternalAccounts.Confirmedonly = false>

<cfinclude template="queries/q_select_all_pop3_data.cfm">



Hier finden Sie die Resultate der letzten &Uuml;berpr&uuml;fungen Ihrer externen Konten.

<br /><br />


<!--- select now real external accounts --->
<cfquery name="q_select_external_accounts" dbtype="query" debug="yes">
SELECT
	emailadr,id,autocheckminutes,pop3server,pop3username
FROM
	variables.q_select_all_pop3_data
WHERE
	origin = 1
;
</cfquery>


<cfoutput query="q_select_external_accounts">



<div class="mischeader" style="width:450px;">

<div class="b_all" style="width:450px;padding:4px;font-weight:bold;">
#si_img('email')# #q_select_external_accounts.emailadr# (&Uuml;berpr&uuml;fung alle #q_select_external_accounts.autocheckminutes# min)
</div>

</div>

<br />



<!--- display certain data: 

	- lastcheck

	- number of checks succeeded

	- number of checks with errors

	

	--->

<cfif CompareNocase(url.detailemailaddress, q_select_external_accounts.emailadr) is 0>

	<cfset a_int_maxrows = 1000>

<cfelse>

	<cfset a_int_maxrows = 5>

</cfif>




<cfquery dbtype="query" name="q_select_lastchecks" maxrows="#a_int_maxrows#">

SELECT dt_check,exitcode FROM q_select_fetchmail_logbook

WHERE emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_external_accounts.pop3username#@#q_select_external_accounts.pop3server#">

ORDER BY dt_check DESC;

</cfquery>

<div style="padding-left:40px;width:410px;line-height:17px;"> 

	<table class="table table-hover"> 

	  <tr class="tbl_overview_header">

	  	<td colspan="2">Datum/Zeit</td>

		<td>Resultat</td>

	  </tr>

	  <cfloop query="q_select_lastchecks">

	  <tr>

		<td align="right" width="100" nowrap valign="top">

		#DateFormat(q_select_lastchecks.dt_check, "dd.mm.yy")# #TimeFormat(q_select_lastchecks.dt_check, "HH:mm")#

		</td>

		<td nowrap class="addinfotext" valign="top">

		vor #DateDiff("n", q_select_lastchecks.dt_check, now())# min

		</td>

		<td valign="top">

		#ReturnExitCode(q_select_lastchecks.exitcode)#

		</td>

	  </tr>

	  </cfloop>

	  <tr>

	  	<td colspan="3" class="bt">

		<a href="index.cfm?action=logbookexternalaccounts&detailemailaddress=#urlencodedformat(q_select_external_accounts.emailadr)#">#si_img('add')# mehr Log-Eintr&auml;ge anzeigen</a>

		&nbsp;|&nbsp;

		<a href="../settings/index.cfm?action=emailaccounts">#si_img('pencil')# Einstellungen anzeigen</a>

		</td>

	  </tr>

	</table>



 



</div>

<br />

</cfoutput>

<i>Die Eintr&auml;ge werden nach 48 Stunden automatisch gel&ouml;scht</i>