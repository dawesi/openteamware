<!--- //

	Module:		
	Action:		
	Description:	
	

// --->

<cfparam name="EventCloneRequest.DayDiff" type="numeric">

<cfset a_dt_original_start = q_select_events.date_start />
<cfset a_dt_original_end = q_select_events.date_end />

<!--- add a new row ... --->
<cfset a_int_col_number = QueryAddRow(q_select_events, 1) />

<cfloop list="#q_select_events.columnlist#" index="a_str_colname">
	<cfset QuerySetCell(q_select_events, a_str_colname, q_select_events[a_str_colname][q_select_events.currentrow], a_int_col_number)>
</cfloop>

<!--- why are we adding hours instead of days?? --->
<cfset a_int_hours_diff = EventCloneRequest.DayDiff * 24>

<cfset a_dt_new_start = DateAdd('h', a_int_hours_diff, q_select_events.date_start)>
<cfset a_dt_new_end = DateAdd('h', a_int_hours_diff, q_select_events.date_end)>

<!--- check if the hours are NOT the same ... --->
<cfif (Hour(a_dt_new_start) NEQ Hour(a_dt_original_start))>
	<!---AND
	(q_select_events.daylightsavinghoursoncreate NEQ arguments.usersettings.daylightsavinghoursonly)--->
	<!--- hours do NOT match ... apply right hours --->
	<cfset a_int_add_hours_diff = arguments.usersettings.daylightsavinghoursonly - q_select_events.daylightsavinghoursoncreate>
	
	<cfset a_int_hours_diff = a_int_hours_diff + a_int_add_hours_diff>
	<cfset a_dt_new_start = DateAdd('h', a_int_hours_diff, q_select_events.date_start)>
	<cfset a_dt_new_end = DateAdd('h', a_int_hours_diff, q_select_events.date_end)>	
	
</cfif>

<!--- if the event has been created in normal time we need to subtract one hour because
	otherwise the event would take place one hour later
	
	the reason: in summertime we need to add 2 hours to the values in the database (UTC),
	therefore winter values would be calculated in the wrong way --->
<!---<cftry>
<cfif (a_dt_original_start LT GetDaylightSavingTimeStart(year(a_dt_original_start))) AND
	  (now() GT GetDaylightSavingTimeStart())>
		
	   <!--- subtract one hour --->
	   <cfset a_int_hours_diff = a_int_hours_diff -1>
</cfif>
<cfcatch type="any">
	<!--- we've an error here but I don't know why yet --->
	</cfcatch>
</cftry>--->





<cfset a_str_dt_start = DateFormat(a_dt_new_start, 'yyyy-mm-dd')& ' ' & TimeFormat(a_dt_new_start, 'HH:mm:ss') />
<cfset a_str_dt_end = DateFormat(a_dt_new_end, 'yyyy-mm-dd')& ' ' & TimeFormat(a_dt_new_end, 'HH:mm:ss') />

<!--- update table --->
<!---<cfset QuerySetCell(q_select_events, 'date_start', a_dt_new_start, a_int_col_number)>
<cfset QuerySetCell(q_select_events, 'date_end', a_dt_new_end, a_int_col_number)>--->
<cfset QuerySetCell(q_select_events, 'date_start', a_str_dt_start, a_int_col_number) />
<cfset QuerySetCell(q_select_events, 'date_end', a_str_dt_end, a_int_col_number) />
<cfset QuerySetCell(q_select_events, 'uniquekey', RandRange(1, 100000), a_int_col_number) />

<cfset QuerySetCell(q_select_events, 'starthour', Hour(a_dt_new_start), a_int_col_number) />
