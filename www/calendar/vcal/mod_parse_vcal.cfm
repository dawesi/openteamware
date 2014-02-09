<!--- // this module parses a vcal string and returns a structure with the events // --->

<!--- the string holding the iCalendar file --->
<cfparam name="attributes.vCalendarEvents" type="string">
<!--- utc difference ... important for setting the start/end time --->
<cfparam name="attributes.utcdiff" default="0" type="numeric">


<cfset attributes.vCalendarEvents = trim(attributes.vCalendarEvents)>

<!--- return information --->
<cfset a_array_events = ArrayNew(1)>
<cfset a_str_calid = "">
<cfset a_str_calname = "">

<cfscript>
	// check params	
	function ReturnEntryParams(astr)
	{
	// return array
	// aResult[1] ... key
	// aResult[2] ... parameters (maybe empty)
	// aResult[3] ... value
	var aResult = arraynew(1);
	var aII_key = 0;
	var aII_param = 0;
	var aII_value = 0;
	var a_str_temp = "";
	var a_str_temp_key_param = "";
	
	// trim
	astr = trim(astr);
	
	// example: DTSTART;VALUE=DATE:20021225
	//          key     parameters value

	aResult[1] = "";
	aResult[2] = "";
	aResult[3] = "";
	
	// value
	aII_value = FindNoCase(":", astr);	
	aResult[3] = Mid(astr, aII_value+1, len(astr));
	aResult[3] = ReplaceNoCase(aResult[3], "\n", chr(13)&chr(10), "ALL");
	aResult[3] = ReplaceNoCase(aResult[3], chr(194), "", "ALL");
	aResult[3] = ReplaceNoCase(aResult[3], chr(160), "", "ALL");
	aResult[3] = ReplaceNoCase(aResult[3], "\""", """", "ALL");
	aResult[3] = ReplaceNoCase(aResult[3], "\r", " ", "ALL");
	aResult[3] = ReplaceNoCase(aResult[3], "\,", ",", "ALL");
	aResult[3] = ReplaceNoCase(aResult[3], "\;", ";", "ALL");
	//aResult[3] = ReReplaceNoCase(aResult[3], "[[:cntrl:]]", "", "ALL");
	
	// copy now key + param
	// there was a bug when a ";" was detected in the text (value) part
	if (aII_value gt 2)
		{
		a_str_temp_key_param = Mid(astr, 1, aII_value);
		} 
			else
				{
				a_str_temp_key_param = astr;
				}
	
	// key
	aII_key = FindNoCase(";", a_str_temp_key_param);
	
	if (aII_key gt 0)
		{
		// we have parameters	
		aResult[1] = Mid(a_str_temp_key_param, 1, aII_key-1);		
		}
		else
			{
			aII_key = FindNoCase(":", a_str_temp_key_param);
			
			if (aII_key gt 0)
				{
				aResult[1] = Mid(a_str_temp_key_param, 1, aII_key-1);
				}			
			}

	// param
	aII_param = FindNoCase(":", a_str_temp_key_param);
	if (aII_param gt 0)
		{
		a_str_temp = Mid(a_str_temp_key_param, 1, aII_param-1);
		
		// now we have the DTSTART;VALUE=DATE: part
		aII_param = FindNoCase(";", a_str_temp);
		
		if (aII_param gt 0)
			{
			aresult[2] = Mid(a_str_temp, aII_param+1, len(a_str_temp));
			}		
		}	
	
	// return array
	return(aResult);	
	}
	
	// convert string to date/time
	function GetDateTimeFromVCal(astr)
	{
	var aresult = "";
	var a_int_year = 0;
	var a_int_month = 0;
	var a_int_day = 0;
	var a_int_hour = 0;
	var a_int_minute = 0;
	var a_bol_utc = true;
	var a_bol_time_supplied = true;
	
	// examples
	// 20021112T110000Z
	// 20021112
	
	if (Len(astr) lt 8)
		{
		break;
		}
		
	// do we have UTC values?
	a_bol_utc = FindNoCase("z", astr, 1) gt 0;
	
	// time given?
	a_bol_time_supplied = FindNoCase("t", astr, 1) gt 0;
		
	// yyyymmdd
	// http://www.ietf.org/rfc/rfc2445.txt
	a_int_year = Mid(astr, 1, 4);
	a_int_month = Mid(astr, 5, 2);
	a_int_day = Mid(astr, 7, 2);
	
	if (a_bol_time_supplied is true)
		{
		a_int_hour = Mid(astr, 10, 2);
		a_int_minute = Mid(astr, 12, 2);				
		} else
			{
			a_int_hour = 0;
			a_int_minute = 0;
			} 
	
	aresult = CreateDateTime(a_int_year, a_int_month, a_int_day, a_int_hour, a_int_minute, 0);
	
	if ((attributes.utcdiff neq 0) AND (a_bol_utc neq true))
		{
		aResult = DateAdd("h", attributes.utcdiff, aResult);
		}
	
	return(aresult);	
	}
	
	// calculate hours of duration
	function GetDurationFromVCal(astr)
	{
	var aresult = 1;
	var a_str_temp = "";
	var a_str_temp2 = "";
	var a_int_result_hours = 0;
	
	a_Str_temp = Replacenocase(astr, "PT", "", "ALL");
	a_Str_temp = Replacenocase(a_Str_temp, "P", "", "ALL");
	
	// let's have a look which time is provided
	a_struct_pos = ReFindNoCase("[1-9]*H", a_str_temp, 1, true);
		
	if (ArrayLen(a_struct_pos.pos) gt 0)
		{
		// found something
		a_str_temp2 = Mid(a_str_temp, a_struct_pos.pos[1], a_struct_pos.len[1]-1); 
		a_int_result_hours = a_str_temp2;
		}		
	
	if (a_int_result_hours gt 0) { aresult = a_int_result_hours; }
	
	return(aresult);
	}
</cfscript>

<!--- this char is used later as delimteter --->
<cfset attributes.vCalendarEvents = ReplaceNoCase(attributes.vCalendarEvents, chr(14), "", "ALL")>

<cfif FindNoCase("BEGIN:VCALENDAR", attributes.vcalendarevents, 1) neq 1>
	<cfthrow message="No vCalendarFile">
</cfif>


<!--- properties ermitteln --->

<cfset aii = FindNoCase("BEGIN:VEVENT", attributes.vCalendarEvents, 1)>

<cfset avCalendarHeader = trim(Mid(attributes.vCalendarEvents, 1, aii-1))>
<cfset attributes.vCalendarEvents = Mid(attributes.vCalendarEvents, aii, len(attributes.vCalendarEvents))>

<!---
CALSCALE:GREGORIAN
X-WR-TIMEZONE;VALUE=TEXT:US/Pacific
PRODID:WHITERABBIT-CONFIDENTIAL
X-WR-CALNAME;VALUE=TEXT:German Holidays
X-WR-RELCALID;VALUE=TEXT:44774A10-C415-11D6-BA97-003065F198AC
VERSION:2.0
--->
<cfoutput><pre><b>#avCalendarHeader#</b></pre></cfoutput>
<cfsetting enablecfoutputonly="yes">
<cfloop index="a_str_header_line" delimiters="#chr(10)#" list="#avCalendarHeader#">
	
	<cfset a_arr_header_info = ReturnEntryParams(a_str_header_line)>
	
	<cfswitch expression="#a_arr_header_info[1]#">
		<cfcase value="X-WR-CALNAME">
		<cfset a_str_calname = a_arr_header_info[3]>
		</cfcase>
		<cfcase value="X-WR-RELCALID">
		<cfset a_str_calid = a_arr_header_info[3]>
		</cfcase>
	</cfswitch>

</cfloop>

<!--- structure for events --->
<cfset aEventsStruct = StructNew()>

<!--- typical event:

BEGIN:VEVENT
UID:4476BE3F-C415-11D6-BA97-003065F198AC
DTSTAMP:20020625T170905Z
SUMMARY:Neujahr
RRULE:FREQ=YEARLY;INTERVAL=1;BYMONTH=1
DTSTART;VALUE=DATE:20020101
DTEND;VALUE=DATE:20020102
END:VEVENT
 
--->

<!---<cfoutput><pre>#attributes.vCalendarEvents#</pre></cfoutput>--->

<cfset attributes.vCalendarEvents = ReplaceNoCase(attributes.vcalendarEvents, "BEGIN:VEVENT", chr(14)&"BEGIN:VEVENT", "ALL")>



<CFSET tickBegin=GetTickCount()>
<cfset a_int_counter = 0>
<cfloop index="aSingleEvent" list="#attributes.vCalendarEvents#" delimiters="#chr(14)#">

	<cfset a_int_counter = a_int_counter + 1>
	
	
	<cfset a_int_arraylen = ArrayLen(a_array_events)+1>		
	<cfset a_array_events[a_int_arraylen] = StructNew()>
	
	<!--- set delimeter 
		chr(10) does not work properly because one entry can go over several lines
		
		therefore insert a special char (chr(14))
		
		we use a regular expression to insert this char
	--->
	
	<cfset a_str_new_event_line = "">
	
	<cfloop index="aSingleEventLine" list="#aSingleEvent#" delimiters="#chr(13)##chr(10)#">
		<cfif ReFind("^[A-Z]*[;,:]", aSingleEventLine, 1) gt 0>
			<cfset a_str_new_event_line = a_str_new_event_line&chr(13)&chr(10)&chr(14)&aSingleEventLine>
		<cfelse>
			<cfset a_str_new_event_line = a_str_new_event_line&chr(13)&chr(10)&aSingleEventLine>
		</cfif>
	</cfloop>
	
	<!---<cfoutput><pre>#a_str_new_event_line#</pre></cfoutput>--->
	<cfset a_array_events[a_int_arraylen]["start"] = "">
	<cfset a_array_events[a_int_arraylen]["end"] = "">
	<cfset a_array_events[a_int_arraylen]["title"]= "">
	<cfset a_array_events[a_int_arraylen]["uid"] = "">
	<cfset a_array_events[a_int_arraylen]["description"] = "">
	<cfset a_array_events[a_int_arraylen]["timestamp"] = "">

	<cfloop index="a_str_event_line" list="#a_str_new_event_line#" delimiters="#chr(14)#">
		<cfset a_str_event_line = ReplaceNoCase(a_str_event_line, chr(13)&chr(10), "", "ALL")>
		
		<!---<hr>
		<cfoutput><h4>#a_str_event_line#</h4></cfoutput>
		<hr>--->
	
		<!--- important 
			the key/value pair is divided by an ";" ...
			
			f.e. DTSTART:3478534895
			
			optional properties can be included with an ";", f.e.
			
			DTSTART;ENCODING ISO8859-1:47589354
			
			the cfscript above is responsible for checking this!
		--->
				
		<!--- parse data --->
		<cfset a_arr_info = ReturnEntryParams(trim(a_str_event_line))>
		
		<!---<cfoutput><font color="##0000FF">Name: #a_arr_info[1]#</font> <font color="##009900">Param: #a_arr_info[2]#</font> <font color="##FF0000">Value: #replacenocase(a_arr_info[3], chr(13)&chr(10), "<br>", "ALL")#</font><br></cfoutput>--->
		
		<!---<cfloop index="a_int_loop" from="1" to="#len(a_arr_info[3])#">
		<cfoutput><li>#mid(a_arr_info[3], a_int_loop, 1)# #asc(mid(a_arr_info[3], a_int_loop, 1))#</li></cfoutput>
		</cfloop>--->
		
		<cftry>
		<cfswitch expression="#a_arr_info[1]#">
			<cfcase value="DTSTART">
			<!--- start date(time) --->
			<cfset a_array_events[a_int_arraylen]["start"] = GetDateTimeFromVCal(a_arr_info[3])>
			</cfcase>
			<cfcase value="SUMMARY">
			<!--- title --->
			<cfset a_array_events[a_int_arraylen]["title"]= a_arr_info[3]>
			</cfcase>
			<cfcase value="UID">
			<!--- uid of event - important for updates --->
			<cfset a_array_events[a_int_arraylen]["uid"] = a_arr_info[3]>
			</cfcase>
			<cfcase value="DTEND">
			<!--- end of event (can be also Duration, see below --->
			<cfset a_array_events[a_int_arraylen]["end"] = GetDateTimeFromVCal(a_arr_info[3])>
			</cfcase>
			<cfcase value="DURATION">
			<!--- duration is given ... add x hours to start date/time --->
			<cfset a_int_duration_hours = GetDurationFromVCal(a_arr_info[3])>
			<cfset a_array_events[a_int_arraylen]["end"] = DateAdd("h", a_int_duration_hours, a_array_events[a_int_arraylen]["start"])>
			</cfcase>
			<cfcase value="DTSTAMP">
			<cfset a_array_events[a_int_arraylen]["timestamp"] = GetDateTimeFromVCal(a_arr_info[3])>
			</cfcase>
			<cfcase value="Description">
			<cfset a_array_events[a_int_arraylen]["description"] = a_arr_info[3]>
			</cfcase>
			<cfcase value="End">
			<!--- // end of vcal entry // --->			
			</cfcase>
		</cfswitch>
		<cfcatch type="any">
		<cfoutput><h1>#cfcatch.Message#</h1></cfoutput>
		</cfcatch>
		</cftry>
		</cfloop>	
	</cfloop>

<cfsetting enablecfoutputonly="no">
<cfset caller.a_array_events = a_array_events>
<cfset caller.a_cal_title = a_str_calname>
<cfset caller.a_cal_calid = a_str_calid>

<CFSET tickEnd=GetTickCount()>

<CFSET loopTime=tickEnd - tickBegin>
<CFOUTPUT>Time to Complete: #looptime#</CFOUTPUT>