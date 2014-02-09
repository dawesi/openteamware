<!--- //

	edit an openTeamWare account
	
	// --->
	
	<cfabort>

<cfparam name="url.id" default="0">

<cf_disp_navigation mytextleft="openTeamWare Account editieren">
<br>

<cfset selectemailrequest.id = url.id>
<cfinclude template="queries/q_select_emailadr.cfm">

<cfif q_select_emailadr.recordcount is 0>Keine Adresse gefunden<cfabort></cfif>

<form action="act_edit_inboxcc_email_account.cfm" method="POST" enablecab="No">
<input type="Hidden" name="frmID" value="<cfoutput>#q_select_emailadr.id#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="5">
<tr class="spaltenkoepfe">
	<td colspan="2"><b>Zugangsdaten/Grundeinstellungen</b></td>
</tr>
<tr>
	<td align="right">E-Mail Adresse:</td>
	<td><b><cfoutput>#q_select_emailadr.emailadr#</cfoutput></b></td>
</tr>
<tr>
	<td align="right">Angezeigter Name:</td>
	<td><input type="text" name="frmDisplayName" size="20" maxlength="100" value="<cfoutput>#htmleditformat(q_select_emailadr.displayname)#</cfoutput>"></td>
</tr>
<tr>
	<td align="right">POP3-Server:</td>
	<td><cfoutput>#q_select_emailadr.pop3server#</cfoutput></td>
</tr>
<tr>
	<td align="right">Benutzername am POP3-Server:</td>
	<td><cfoutput>#q_select_emailadr.pop3username#</cfoutput></td>
</tr>
<tr>
	<td align="right">Passwort am POP3-Server:</td>
	<td><input type="text" value="<cfoutput>#htmleditformat(q_select_emailadr.pop3password)#</cfoutput>"  name="frmPop3Password" required="No" size="20" maxlength="50"></td>
</tr>
<tr>
	<td align="right">Nachrichten am Server l&ouml;schen</td>
	<td><input type="Checkbox" <cfif q_select_emailadr.deletemsgonserver is 1>checked</cfif> name="frmDeleteMsgOnServer" class="noborder"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td style="color:gray;">Deaktivieren Sie die L&ouml;schungen der Nachrichten am<br>
	Server wenn Sie planen Ihre E-Mails mit einem externen<br>
	Programm wie Microsoft Outlook herunterzuladen.</td>
</tr>

<!--- // nachrichten umleiten // --->
<tr class="spaltenkoepfe">
	<td colspan="2"><b>Nachrichten umleiten</b></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>
	Sie k&ouml;nnen eintreffende Nachrichten automatisch an eine weitere<br>
	Adresse umleiten lassen. Optional k&ouml;nnen Sie auch eine Kopie der<br>
	Nachricht auf openTeamWare verbleiben lassen.
	</td>
</tr>
<cfset SelectForwardingRequest.emailadr = q_select_emailadr.emailadr>
<cfinclude template="queries/q_select_ib_forwarding_target.cfm">
<tr>
	<td align="right">Nachrichten umleiten:</td>
	<td>
	<cfif q_select_redirect.recordcount is 0>
		<cfset AChecked = false>
	<cfelse>
		<cfset AChecked = true>
	</cfif>
	
	<input class="noborder" type="Checkbox" name="frmForwardingEnabled" value="on" <cfif AChecked is true>checked</cfif>>
	
	</td>
</tr>
<tr>
	<td align="right">Ziel:</td>
	<td>
	<input type="Text" name="frmForwardingDestination" value="<cfoutput>#htmleditformat(q_select_redirect.destination)#</cfoutput>" required="No" size="40" maxlength="100">
	</td>
</tr>
<tr>
	<td align="right">Kopie speichern:</td>
	<td>
	<cfif q_select_redirect.recordcount is 0>
		<cfset AChecked = false>
	<cfelseif q_Select_redirect.leavecopy is 1>
		<cfset AChecked = true>
	<cfelse>
		<cfset AChecked = false>
	</cfif>
	
	<input class="noborder" type="Checkbox" name="frmForwardingLeaveCopy" value="on" <cfif AChecked is true>checked</cfif>>	
	</td>
</tr>
<tr class="spaltenkoepfe">
	<td colspan="2"><b>&Auml;nderungen speichern</b></td>
</tr>
<tr>
	<td></td>
	<td><input type="Submit" name="frmSubmit" value="Einstellungen speichern"></td>
</tr>
</table>
</form>