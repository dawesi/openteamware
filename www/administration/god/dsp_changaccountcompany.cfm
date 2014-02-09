

<h4>Company aendern</h4>

<cfinclude template="queries/q_select_all_companies.cfm">

<table border="0" cellspacing="0" cellpadding="4">
<form action="act_changeaccountcompany.cfm" method="post">
  <tr>
    <td align="right">Benutzername:</td>
    <td>
	<input type="text" name="frmusername" value="" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">Unternehmen:</td>
    <td>
	<input type="text" name="frmcustomerid" value="" size="10"> (Kunden-ID)
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="Zuordnung aendern ... "></td>
  </tr>
</form>
</table>