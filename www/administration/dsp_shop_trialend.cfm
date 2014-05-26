
<cfinclude template="dsp_inc_select_company.cfm">

<!--- load company data ... still in trial phase? --->

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfif q_select_company_data.status IS 0>
	<!--- already a customer ... --->
	<cflocation addtoken="no" url="index.cfm?action=shop#WriteURLTags()#">
</cfif>


<table border="0" cellspacing="0" cellpadding="4" class="lightbg b_all" style="margin:10px;margin-left:0px;">
  <tr>
    <td>
		<b>1. Konten auswahlen</b>
	</td>
    <td>
		2. Bestaetigen
	</td>
    <td>
		3. Fertigstellung
	</td>
  </tr>
</table>

<cfset SelectAccounts.CompanyKey = url.companykey>
<cfinclude template="queries/q_select_accounts.cfm">
<br>
<b>Wichtige Hinweise</b>
<br>
<ul style="line-height:18px;">
	<li><b>Wenden Sie sich bei allfaelligen Fragen bitte an Ihren Betreuer -<br>
		Sie finden die Kontaktdaten am Ende der Seite.</b></li>
	<li>Nun muessen Sie sich entscheiden welches Produkt<br>Sie fuer welches Konto bestellen moechten.<br>
		(Die Zuordnung ist spaeter natuerlich abaenderbar)</li>
	<li>Wenn Sie testweise eingerichtete Konten nicht bezahlen moechten,<br>waehlen Sie als Option "Loeschen" aus.</li>
	<li>Pruefen Sie bitte - falls zutreffend - ob Sie als EU-Unternehmen Ihre<br>
		UID-Nummer angegeben haben [ <a href="index.cfm?action=masterdata<cfoutput>#WriteURLTags()#</cfoutput>">Stammdaten anzeigen/editieren...</a> ]</li>
</ul>
	<div id="iddivshowbasket" style="padding-left:40px;">
	<input type="button" onClick="ShowBasket();" value="Weiter ..." style="font-weight:bold;">
	</div>
<br>

<script type="text/javascript">
	function ShowBasket()
		{
		var obj1,obj2;
		obj1 = findObj('idtableorder');
		obj2 = findObj('iddivshowbasket');
		
		obj1.style.display = '';
		obj2.style.display = 'none';
		}
</script>

<table border="0" cellspacing="0" cellpadding="8" id="idtableorder" style="display:none;">
<form action="index.cfm?action=shop.trialphaseend.addtobasket" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
  <tr>
    <td class="bb"><b>Konto</b></td>
    <td class="bb"><b>Aktion</b></td>
	<cfset a_int_rowspan = 3 + q_select_accounts.recordcount>
	<td valign="top" nowrap style="border-left:silver solid 1px;line-height:20px;" rowspan="<cfoutput>#a_int_rowspan#</cfoutput>">

	<br>
	<cfoutput>#si_img('page_white_acrobat')#</cfoutput> <b>Downloads</b>
	<br>
	<a href="/rd/pricelist/" target="_blank">Preisliste</a>
	<br>
	<a href="/rd/scopeofservices/" target="_blank">Leistungsumfang</a>
	<br>
	<a href="/rd/agb/" target="_blank">AGB</a>
	</td>
  </tr>
  <tr>
  	<td colspan="2" align="center">
		<input type="submit" name="frmsubmit" value="In den Warenkorb ...">
	</td>
  </tr>
  <cfoutput query="q_select_accounts">
  <tr <cfif q_select_accounts.currentrow mod 2 is 0>class="lightbg"</cfif>>
    <td valign="top">
		<b>#q_select_accounts.username#</b>
		<br>
		#q_select_accounts.surname#, #q_select_accounts.firstname#
	</td>
    <td valign="top">
		<select name="frmproductkey_#htmleditformat(q_select_accounts.entrykey)#">
			<option value="AE79D26D-D86D-E073-B9648D735D84F319">Mobile CRM</option>
			<option value="AD4262D0-98D5-D611-4763153818C89190">Mobile Office</option>
			<option value="delete" style="background-color:red;color:white;">Konto loeschen</option>
		</select>
	</td>
  </tr>
  </cfoutput>
  <tr>
  	<td colspan="2" align="center">
		<input type="submit" name="frmsubmit" value="In den Warenkorb ...">
	</td>
  </tr> 
  <tr>
  	<td colspan="3" style="padding-top:10px;">
	<img src="/images/shop/card_logos.gif" align="absmiddle"/>&nbsp;ELV / EPS / <b>Ueberweisung</b>
	</td>
  </tr> 
</table>