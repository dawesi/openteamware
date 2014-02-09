<!--- //

	show userdata ...
	
	give the possibility to edit
	
	// --->
	
<cfparam name="url.entrykey" type="string" default="">

<cfset SelectUserdataRequest.entrykey = url.entrykey>

<cfinclude template="queries/q_select_user_data.cfm">

<h4>Benutzerdaten</h4>

<cfif q_select_user_data.recordcount is 0>
	<b>no record found.</b>
	<cfexit method="exittemplate">
</cfif>

<table border="0" cellspacing="0" cellpadding="4">
<cfoutput query="q_select_user_data">
  <tr>
  	<td align="right">Entry-Key:</td>
	<td>#url.entrykey#</td>
  </tr>
  <tr>
    <td align="right">Vorname:</td>
    <td>#q_select_user_data.firstname#</td>
  </tr>
  <tr>
    <td align="right">Nachname:</td>
    <td>#q_select_user_data.surname#</td>
  </tr>
  <tr>
    <td align="right">Firma:</td>
    <td>
	<cfset SelectCompanyNameByKey.Entrykey = q_select_user_data.companykey> 
	<cfinclude template="queries/q_select_company_by_key.cfm">
	<a href="default.cfm?action=customerproperties&entrykey=#urlencodedformat(q_select_user_data.companykey)#">#q_select_company_by_key.companyname#</a>
	&nbsp;&nbsp;
	
	</td>
  </tr>
  <tr>
    <td align="right">Gruppenmitgliedschaften:</td>
    <td>
	
	
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</cfoutput>
</table>