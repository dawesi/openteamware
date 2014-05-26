<!---

	Kunden sperren 
	
	
	--->
	
<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	companyname,entrykey,description,telephone,contactperson,email,resellerkey,customerid
FROM
	companies
ORDER BY
	companyname
;
</cfquery>

<!---<cfdump var="#q_select_companies#">--->

<form action="act_disable_customer.cfm" method="get">
	Kundennummer: <input type="text" name="frmcustomerid" size="20">&nbsp;
	
	<input type="submit" value="Sperren">
</form>


<br><br><br>
<b>Gesperrte Kunden</b>

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	companyname,entrykey,description,telephone,contactperson,email,resellerkey,customerid,disabled_reason,dt_disabled
FROM
	companies
WHERE
	disabled = 1
ORDER BY
	companyname
;
</cfquery>

<table border="0" cellspacing="0" cellpadding="4">
  <tr bgcolor="#CCCCCC">
    <td>Kundennummer</td>
    <td>Firma</td>
    <td>gesperrt am</td>
	<td>Grund</td>
	<td>Aktion</td>
  </tr>
  <cfoutput query="q_select_companies">
  <tr>
    <td>
		#q_select_companies.customerid#
	</td>
    <td>
		<a target="_blank" href="../index.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_companies.entrykey)#&resellerkey=#urlencodedformat(q_select_companies.resellerkey)#">#q_select_companies.companyname#</a>
	</td>
    <td>
		#q_select_companies.dt_disabled#
	</td>
	<td>
		#q_select_companies.disabled_reason#
	</td>
	<td>
		<a href="act_open_customer.cfm?companykey=#urlencodedformat(q_select_companies.entrykey)#">oeffnen ...</a>
	</td>
  </tr>
  </cfoutput>
</table>