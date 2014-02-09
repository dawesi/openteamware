<!--- //



	display the outlook sync and the possibility to reset items

	

	// --->
<cfparam name="form.frmpassword" type="string" default="">

<cf_disp_navigation mytextleft="OutlookSync Einstellungen">

<br>
<cfif StructKeyExists(url, "confirmed") is false>
<b>Jetzt die Daten leeren</b>

<br>
<br>
Mit dieser Option koennen Sie eine vollstaendige Neu-Synchronisierung erzwingen bei der alle mit Outlook abzugeleichenden Datenbereiche auf openTeamWare geleert werden.
<br>
<br>


Dazu gehoergen:
<li>Adressbuch,</li>
<li>Kalender,</li>
<li>Aufgaben &amp;</li>
<li>Notizen</li>

<br>
<br>
<form action="default.cfm?action=outlooksync&confirmed=1" method="post">
<b>Wollen Sie diese Aktion wirklich durchfuehren?</b><br><br>
Geben Sie nun Ihr Passwort ein:&nbsp;<input type="password" name="frmpassword" size="20">&nbsp;<input type="submit" name="frmsubmit" value="Weiter, Bereiche jetzt leeren ...">
</form>

<cfexit method="exittemplate">
</cfif>

<cfif len(form.frmpassword) is 0>
	<b>Passworteingabe erforderlich!</b>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_pwd" datasource="#request.a_str_db_users#">
SELECT
	pwd
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cfif comparenocase(form.frmpassword, q_select_pwd.pwd) neq 0>
	<b>Keine Uebereinstimmung</b>
	<cfexit method="exittemplate">
</cfif>

<!--- ok, here we go ... --->

<cfquery name="q_select_notepad" datasource="#request.a_str_db_tools#">
DELETE FROM
	notepad
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
;
</cfquery>

<cfquery name="q_select_notepad_outlook_id" datasource="#request.a_str_db_tools#">
DELETE FROM
	notepad_outlook_id
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
;
</cfquery>


<cfquery name="q_select_addressbook" datasource="#request.a_str_db_tools#">
DELETE FROM
	addressbook
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
;
</cfquery>

<cfquery name="q_select_addressbook_outlook_id" datasource="#request.a_str_db_tools#">
DELETE FROM
	adrb_outlook_id
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
;
</cfquery>

<cfquery name="q_select_calendar" datasource="#request.a_str_db_tools#">
DELETE FROM
	calendar
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
;
</cfquery>


<cfquery name="q_select_calendar_outlook_id" datasource="#request.a_str_db_tools#">
DELETE FROM
	calendar_outlook_id
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
;
</cfquery>

<h4>Aktion erfolgreich durchgefuehrt!</h4>
<h4>WICHTIG: Gehen Sie im Programm OutlookSync nun nach dem Start in die "Erweiterten Einstellungen" und dort in den Bereich "Systemeinstellungen". Dort erhalten Sie nach der Eingabe des Zugriffscodes "LOOKOUT" die Moeglichkeit schob bekannte sowie ignorierte Eintraege wieder in die Synchronisation aufzunehmen - dies ist unbedingt notwendig!</h4>