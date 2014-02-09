<!--- email account editieren --->
<cf_disp_navigation mytextleft="E-Mail Adresse editieren">

<cfabort>

<cfparam name="url.id" default="0">

<cfset selectemailrequest.id = url.id>
<cfinclude template="queries/q_select_emailadr.cfm">

<cfif q_select_emailadr.recordcount is 0><cfabort></cfif>

<form action="act_edit_email_account.cfm" method="POST" enablecab="No">
<input type="Hidden" name="frmID" value="<cfoutput>#q_select_emailadr.id#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="5">
<tr>
	<td align="right">Angezeigter Name:</td>
	<td><input type="text" name="frmDisplayName" value="<cfoutput>#q_select_emailadr.displayname#</cfoutput>" size="20" maxlength="100"></td>
</tr>
<tr>
	<td align="right">E-Mail Adresse:</td>
	<td><b><cfoutput>#q_select_emailadr.emailadr#</cfoutput></b></td>
</tr>
<tr>
	<td align="right">POP3-Server:</td>
	<td><input type="Text" name="frmPop3Server" value="<cfoutput>#q_select_emailadr.pop3server#</cfoutput>" required="No" size="20" maxlength="50"></td>
</tr>
<tr>
	<td align="right">Benutzername am POP3-Server:</td>
	<td><input type="Text" name="frmPop3username" value="<cfoutput>#q_select_emailadr.pop3username#</cfoutput>" required="No" size="20" maxlength="50"></td>
</tr>
<tr>
	<td align="right">Nachrichten am Server l&ouml;schen</td>
	<td>
	<input type="Checkbox" <cfif q_select_emailadr.deletemsgonserver is 1>checked</cfif> name="frmDeleteMsgOnServer" class="noborder">	
	</td>
</tr>
<tr>
	<td align="right">Automatisch pr&uuml;fen</td>
	<td>
	<!---<select name="frmAutoCheckEachHours">
	<option <cfif val(q_select_emailadr.autocheckeachhours) is 0>selected</cfif> value="0">deaktiviert - immer manuell pr&uuml;fen
	<option <cfif val(q_select_emailadr.autocheckeachhours) is 1>selected</cfif> value="1">jede Stunde pr&uuml;fen
	<option <cfif val(q_select_emailadr.autocheckeachhours) is 3>selected</cfif> value="3">alle 3 Stunden pr&uuml;fen
	<option <cfif val(q_select_emailadr.autocheckeachhours) is 6>selected</cfif> value="6">alle 6 Stunden pr&uuml;fen
	<option <cfif val(q_select_emailadr.autocheckeachhours) is 12>selected</cfif> value="12">alle 12 Stunden pr&uuml;fen		
	<option <cfif val(q_select_emailadr.autocheckeachhours) is 24>selected</cfif> value="24">alle 24 Stunden pr&uuml;fen		
	</select>--->
	
	<select name="frmAutoCheckEachMinutes">
	<option value="0" <cfif val(q_select_emailadr.AutoCheckMinutes) is 0>selected</cfif>>deaktiviert</option>
	<option value="1" <cfif val(q_select_emailadr.AutoCheckMinutes) is 1>selected</cfif>>jede Minute</option>
	<option value="3" <cfif val(q_select_emailadr.AutoCheckMinutes) is 3>selected</cfif>>alle 3 Minuten</option>
	<option value="5" <cfif val(q_select_emailadr.AutoCheckMinutes) is 5>selected</cfif>>alle 5 Minuten</option>
	<option value="10" <cfif val(q_select_emailadr.AutoCheckMinutes) is 10>selected</cfif>>alle 10 Minuten</option>
	<option value="30" <cfif val(q_select_emailadr.AutoCheckMinutes) is 30>selected</cfif>>alle 30 Minuten</option>
	<option value="45" <cfif val(q_select_emailadr.AutoCheckMinutes) is 45>selected</cfif>>alle 45 Minuten</option>
	<option value="60" <cfif val(q_select_emailadr.AutoCheckMinutes) is 60>selected</cfif>>jede Stunde</option>
	<option value="180" <cfif val(q_select_emailadr.AutoCheckMinutes) is 180>selected</cfif>>alle 3 Stunden</option>
	<option value="360" <cfif val(q_select_emailadr.AutoCheckMinutes) is 360>selected</cfif>>alle 6 Stunden</option>
	<option value="720" <cfif val(q_select_emailadr.AutoCheckMinutes) is 720>selected</cfif>>alle 12 Stunden</option>
	<option value="1440" <cfif val(q_select_emailadr.AutoCheckMinutes) is 1440>selected</cfif>>ein mal pro Tag</option>
	</select>
	</td>
</tr>
<tr>
	<td align="right">Passwort am POP3-Server:</td>
	<td><input type="password"  name="frmPop3Password" required="No" size="20" maxlength="50"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><b>Hinweis:</b> Eingabe nur erforderlich wenn Sie das Passwort &auml;ndern wollen.</td>
</tr>
<tr>
	<td></td>
	<td><input type="Submit" name="frmSubmit" value="Einstellungen speichern"></td>
</tr>
</table>
</form>