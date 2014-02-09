<!--- // 

	search user

	// --->
	
<!--- entrykey of the company --->
<cfparam name="url.company" type="string" default="">
<cfparam name="url.reseller" type="string" default="">
<cfparam name="url.firstname" type="string" default="">
<cfparam name="url.username" type="string" default="">
<cfparam name="url.surname" type="string" default="">

<cfinclude template="queries/q_search_users.cfm">

<h4><img src="/images/admin/img_people.png" width="32" height="32" hspace="2" vspace="2" border="0" align="absmiddle"> Benutzerverwaltung</h4>

<a href="default.cfm?action=newaccount&company=<cfoutput>#urlencodedformat(url.company)#</cfoutput>">Einen <b>neuen Benutzer</b> hinzf&uuml;gen ...</a>
<br>
<form action="default.cfm" method="get">
<input type="hidden" name="action" value="searchuser">
<input type="hidden" name="company" value="<cfoutput>#htmleditformat(url.company)#</cfoutput>">
<table border="0" cellpadding="4" cellspacing="0">
	<tr>
		<td align="right">Benutzername:</td>
		<td><input type="text" name="username" value="<cfoutput>#htmleditformat(url.username)#</cfoutput>" size=30></td>
	</tr>
	<tr>
		<td align="right">Vorname:</td>
		<td><input type="text" name="firstname" value="<cfoutput>#htmleditformat(url.firstname)#</cfoutput>" size=30></td>
	</tr>
	<tr>
		<td align="right">Nachname:</td>
		<td><input type="text" name="surname" value="<cfoutput>#htmleditformat(url.surname)#</cfoutput>" size=30></td>
	</tr>	
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="frmsubmit" value="Suchen ..."></td>
	</tr>
</table>
</form>

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="lightbg">
    <td>&nbsp;</td>
    <td><b>Benutzername</b></td>
    <td>Name</td>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
  </tr>
  <cfoutput query="q_select_users" startrow="1" maxrows="100">
  <tr>
  	<td align="right" style="color:silver;">#q_select_users.currentrow#</td>
    <td><a href="default.cfm?action=showuser&entrykey=#urlencodedformat(q_select_users.entrykey)#">#q_select_users.username#</a></td>
    <td>#q_select_users.surname#, #q_select_users.firstname#</td>
    <td></td>
    <td align="center">
	<img src="/images/editicon.gif" align="absmiddle" border="0">
	</td>
  </tr>
  </cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<!---<cfdump var="#q_select_users#">--->