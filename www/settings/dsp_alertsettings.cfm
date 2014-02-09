<!--- //

	workgroup alert settings
	
	// --->
	
<cfinvoke component="#request.a_str_component_alerts#" method="GetAlertSettings" returnvariable="q_select_alert_settings">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>
	
<cf_disp_navigation mytextleft="Alert Einstellungen">
<br>
<table border="0" cellspacing="0" cellpadding="8">
<form action="act_save_alert_settings.cfm" method="post">
	<tr>
		<td colspan="2" class="bb"><b>Adressbuch</b></td>
	</tr>
  <tr>
  <tr>
    <td align="right" valign="top">
		Ueber welche Aktionen<br>
		moechten Sie informiert<br>
		werden?
	</td>
    <td valign="top">
		<input type="checkbox" name="frmactions_52227624-9DAA-05E9-0892A27198268072" value="create" class="noborder"> Erstellen<br>
		<input type="checkbox" name="frmactions_52227624-9DAA-05E9-0892A27198268072" value="change" class="noborder"> Aenderungen<br>
		<input type="checkbox" name="frmactions_52227624-9DAA-05E9-0892A27198268072" value="delete" class="noborder"> Loeschungen<br>
	</td>
  </tr>
  <tr>
    <td valign="top" align="right">
		Wie moechten Sie bei<br>Aenderungen benachrichtigt<br>werden?
	</td>
    <td valign="top">
		<input type="checkbox" name="frmemailnotify_52227624-9DAA-05E9-0892A27198268072" value="0" class="noborder"> E-Mail<br>
		<input type="checkbox" name="frmsmsnotify_52227624-9DAA-05E9-0892A27198268072" value="1" class="noborder"> SMS*
	</td>
  </tr>
	<tr>
		<td colspan="2" class="bb"><b>Neu eingetragene Nachverfolgungsauftr&auml;ge</b></td>
	</tr>
  <tr>  
  <tr>
    <td valign="top" align="right">
		Wie moechten Sie<br>benachrichtigt werden?
	</td>
    <td valign="top">
		<input type="checkbox" name="frmemailnotify_followups" value="0" class="noborder"> E-Mail<br>
		<input type="checkbox" name="frmsmsnotify_followups" value="1" class="noborder"> SMS*
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" name="frmsubmit" value="Speichern ...">
	</td>
  </tr>  
</form>
</table>





<br><br>
<b>Bestehende Einstellungen (<cfoutput>#q_select_alert_settings.recordcount#</cfoutput>)</b>
<br>
<cfdump var="#q_select_alert_settings#">
<br><br>
* kostenpflichtig