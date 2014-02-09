<!--- // clone an event that takes place more than once // --->
<cfparam name="EventCloneRequest.DayDiff" type="numeric">

<cfset a_dt_original_start = MainCalendar.date_start>
<cfset a_dt_original_end = MainCalendar.date_end>

<!--- main query steht bereits richtig --->
<cfset acolnumber = QueryAddRow(MainCalendar, 1)>

<cfloop list="#MainCalendar.columnlist#" index="aCol"> 
     <cfset tmp=QuerySetCell(MainCalendar, acol, evaluate("MainCalendar.#acol#"), acolnumber)>
</cfloop>
<!---<cfoutput><!-- new beginning date: #DateAdd("d", EventCloneRequest.DayDiff, MainCalendar.date_start)##chr(13)##chr(10)# --></cfoutput>--->

<cfset a_int_hours_diff = EventCloneRequest.DayDiff * 24>

<!--- if the event has been created in normal time we need to subtract one hour because
	otherwise the event would take place one hour later
	
	the reason: in summertime we need to add 2 hours to the values in the database (UTC),
	therefore winter values would be calculated in the wrong way --->
<cftry>
<cfif (a_dt_original_start LT GetDaylightSavingTimeStart(year(a_dt_original_start))) AND
	  (now() GT GetDaylightSavingTimeStart())>
		
	   <!--- subtract one hour --->
	   <cfset a_int_hours_diff = a_int_hours_diff -1>
</cfif>
<cfcatch type="any">
	<!--- we've an error here but I don't know why yet --->
	</cfcatch>
</cftry>

<!--- update table --->
<cfset tmp = QuerySetCell(MainCalendar, "date_start", DateAdd("h", a_int_hours_diff, MainCalendar.date_start), AColNumber)>
<cfset tmp = QuerySetCell(MainCalendar, "date_end", DateAdd("h", a_int_hours_diff, MainCalendar.date_end), AColNumber)>
<cfset tmp = QuerySetCell(MainCalendar, "dt_start_iso", DateFormat(DateAdd("h", a_int_hours_diff, MainCalendar.date_start), "yyyy-mm-dd")&" "&TimeFormat(DateAdd("d", EventCloneRequest.DayDiff, MainCalendar.date_start), "HH:mm:ss"), AColNumber)>