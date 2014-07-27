<!--- // create an invitation by email // --->
<cfparam name="attributes.userid" default="">
<cfparam name="attributes.Recipient" default="">
<cfparam name="attributes.Sender" default="">
<cfparam name="attributes.Language" default="0">
<cfparam name="attributes.Title" default="">
<cfparam name="attributes.Location" default="">
<cfparam name="attributes.StartDate" default="">
<cfparam name="attributes.EndDate" default="">
<cfparam name="attributes.Description" default="">
<cfparam name="attributes.UTCDiff" default="">
<cfparam name="attributes.Randomkey" default="">
<cfparam name="attributes.AttachVCal" default="false">

<cfif attributes.AttachVCal is true>
	<!--- create vCal file and attach it to the E-Mail --->
	
	<cfinclude template="../vcal/cfscript_create_vcalfile.cfm">
		
		<cfscript>
		stEvent = StructNew();
		stEvent.description = #attributes.description#;
		stEvent.subject = #attributes.title#;
		stEvent.location = #attributes.location#;
		stEvent.startTime = #attributes.StartDate#; //dateObj or timestamp in GMT
		stEvent.endTime = #attributes.EndDate#; // dateObj or timestamp in GMT
		stEvent.organzier = #attributes.sender#;
		stEvent.priority = 1;
		vCalOutput = vCal(stEvent);
		</cfscript>

	
	<cfset AFilename = request.a_str_temp_directory&createuuid()&".ics">
	
	<cffile action="WRITE" file="#AFilename#" output="#vCalOutput#" addnewline="No">

</cfif>

<cfquery name="q_select_sig" datasource="inboxccusers" dbtype="ODBC">
SELECT signature FROM pop3_data
WHERE userid = #val(attributes.userid)#
AND emailadr = '#attributes.sender#';
</cfquery>

<cfmail to="#attributes.Recipient#"
	from="#attributes.Sender#"
	subject="Einladung zu #attributes.Title# am #lsDateFormat(attributes.StartDate, "ddd, dd.mm.yyyy")#" mimeattach="#AFilename#">

Guten Tag!

Sie wurden soeben von #request.a_struct_personal_properties.MYFIRSTNAME# #request.a_struct_personal_properties.MYSURNAME# zu folgendem Termin eingeladen:

Titel: #attributes.Title#
Ort: #attributes.Location#

Beginn: #DateFormat(attributes.StartDate, "dd.mm.yyyy")# #TimeFormat(attributes.StartDate, "HH:mm")# (UTC #attributes.UTCDiff#)
Ende: #DateFormat(attributes.EndDate, "dd.mm.yyyy")# #TimeFormat(attributes.EndDate, "HH:mm")# (UTC #attributes.UTCDiff#)

Beschreibung: #attributes.Description#

--------------------------------------------------------------
| Auf die Einladung reagieren mit ...
--------------------------------------------------------------

... einer Zustimmung zum Termin ...
http://www.openTeamWare.com/rd/calr.cfm?status=1&id=#attributes.Randomkey#

... einer Absage ...
http://www.openTeamWare.com/rd/calr.cfm?status=0&id=#attributes.Randomkey#

... einem eigenen Text ...
http://www.openTeamWare.com/rd/calr.cfm?action=writeback&id=#attributes.Randomkey#


--------------------------------------------------------------
| Termin im eigenen Kalender hinzufuegen
--------------------------------------------------------------

Klicken Sie nun hier um diesen Termin in Ihren eigenen Kalender auf
openTeamWare.com einzutragen:
http://www.openTeamWare.com/rd/calr.cfm?action=addevent&id=#attributes.Randomkey#
	
Wenn Sie Microsoft Outlook oder ein anderes vCalendar-faehiges Programm einsetzen
k�nnen Sie das beigefuegte Attachment oeffnen - dadurch wird der Termin in
Ihrem Kalender aufgenommen!

<cfif (q_select_sig.recordcount gt 0) AND (len(q_select_sig.signature) gt 0)>
--------------------------------------------------------------

Diese Einladung wurde von verschickt von:

#request.a_struct_personal_properties.myfirstname# #request.a_struct_personal_properties.mysurname#

#q_select_sig.signature#
</cfif>
--------------------------------------------------------------
| powered by openTeamWare.com - Ihr Onlineb�ro! http://www.openTeamWare.com/
--------------------------------------------------------------
</cfmail>