<cfscript>
/**
 * Produces output used by the vCalendar standard for PIM's (such as Outlook).
 * There are other tags available such as (CF_AdvancedEmail) that will support multi-part mime encoding where the text of the attachment can be imbeded right into the email
 * 
 * @param stEvent 	 Structure containg the key/value pairs comprising the vCalendar data.  Keys are shown below: 
 * @param stEvent.description 	 Description for the event. 
 * @param stEvent.subject 	 Subject of the event. 
 * @param stEvent.location 	 Location for the event. 
 * @param stEvent.startTime 	 Event's start time in GMT. 
 * @param stEvent.endTime 	 Event's end time in GMT. 
 * @param stEvent.priority 	 Numeric priority for the event (1,2,3). 
 * @return Returns a string. 
 * @author Chris Wigginton (cwigginton@macromedia.com) 
 * @version 1.1, April 10, 2002 
 */
function vCal(stEvent)
{

	var description = "";
	var vCal = "";
	
	var CRLF=chr(13)&chr(10);
	
	if (NOT IsDefined("stEvent.startTime"))
		stEvent.startTime = DateConvert('local2Utc', Now());
	
	if (NOT IsDefined("stEvent.endTime"))
		stEvent.endTime = DateConvert('local2Utc', Now());
		
	if (NOT IsDefined("stEvent.location"))
		stEvent.location = "N/A";
				
	if (NOT IsDefined("stEvent.subject"))
		stEvent.subject = "n/a";
		
	if (NOT IsDefined("stEvent.organzier"))
		stEvent.subject = "n/a";		
		
	if (NOT IsDefined("stEvent.description"))
		stEvent.description = "n/a";
		
	if (NOT IsDefined("stEvent.priority"))
		stEvent.priority = "1";
			

	vCal = "BEGIN:VCALENDAR" & CRLF;
	vCal = vCal & "PRODID:-//Microsoft Corporation//OutlookMIMEDIR//EN" & CRLF;
	vCal = vCal & "VERSION:1.0" & CRLF;
	vCal = vCal & "METHOD:PUBLISH" & CRLF;
	vCal = vCal & "BEGIN:VEVENT" & CRLF;
	vCal = vCal & "DTSTART:" & 
			DateFormat(stEvent.startTime,"yyyymmdd") & "T" & 
			TimeFormat(stEvent.startTime, "HHmmss") & "Z" & CRLF;
	vCal = vCal & "DTEND:" & DateFormat(stEvent.endTime, "yyyymmdd") & "T" & 
			TimeFormat(stEvent.endTime, "HHmmss") & "Z" & CRLF;
	vCal = vCal & "LOCATION:" & stEvent.location & CRLF;
	vCal = vCal & "SUMMARY;ENCODING=QUOTED-PRINTABLE:" & stEvent.subject & CRLF;
	
	vCal = vCal & "DESCRIPTION;ENCODING=QUOTED-PRINTABLE:";
	// Convert CF_CRLF (13_10) into =0D=0A with CR/LF and indent sequences
	description = REReplace(stEvent.description,"[#Chr(13)##Chr(10)#]", "=0D=0A=#Chr(13)##Chr(10)#     ", "ALL");
	vCal = vCal & description & CRLF;
	
	vCal = vCal & "PRIORITY:" & stEvent.priority & CRLF;
	vcal = vCal & "ORGANIZER:MAILTO:"&stEvent.organzier & CRLF;

	vCal = vCal & "END:VEVENT" & CRLF;
	vCal = vCal & "END:VCALENDAR" & CRLF;	
	
	return vCal;
	
}
</cfscript>