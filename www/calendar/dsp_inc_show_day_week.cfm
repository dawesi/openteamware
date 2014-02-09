<!--- // display week // --->

<cfset a_dt_outlook_start = DateAdd('d', 1, request.a_dt_current_date)>
<cfset request.a_dt_utc_current_date = DateAdd('d', 1, request.a_dt_current_date)>

<cfset a_int_tmp_day = DayOfWeek(request.a_dt_utc_current_date) - 1>

<cfif a_int_tmp_day is 0>
	<!--- sunday ... would calculate the wrong week ... goto the previous week --->
	<cfset a_int_tmp_day = 7>
</cfif>

<cfset a_dt_start = CreateDate(year(a_dt_outlook_start), month(a_dt_outlook_start), Day(a_dt_outlook_start))>

<cfset a_dt_start = GetUTCTimeFromUserTime(a_dt_start)>

<!---<cfset a_dt_start = weekStartDate(a_int_weekno, year(request.a_dt_utc_current_date), true)>--->
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.virtualcalendars = request.a_str_virtual_calendar_filter>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#DateAdd('d', 7, a_dt_start)#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events>

<cfif IsDefined("url.debugweek")>
	<cfdump var="#stReturn#">
</cfif>

<cftry>
<cfquery name="q_select_events" dbtype="query">
SELECT
	*
FROM
	q_select_events
ORDER BY
	int_start_num
;
</cfquery>
<cfcatch type="any"></cfcatch></cftry>

<!---
<cfset a_struct_events = QueryToArrayOfStructures(q_select_events)>


	<cfset tmp = QueryAddColumn(q_select_events, 'days', ArrayNew(1))>
	
	<cfset a_struct_events = QueryToArrayOfStructures(q_select_events)>
	
	<cfloop index="ii" from="1" to="#arraylen(a_struct_events)#">
		
		<!--- write list of days into the structure ... speeds up looping below --->
		
		<!--- this function writes a list into the structure that contains the days
			  where this event is repeating
			  
			  f.e.: a 2-days event has the value "17,18"
			  
					a one-day-event has the value "8"
					
			  this way we can use ListFindNoCase instead of complicate walks trough cfif/cfif/cfelse ...
			   --->
		<cfif Compare(GetISOWeek(a_struct_events[ii].date_start), a_int_weekno) NEQ 0>
			<cfset A_int_day_start = 1>
		<cfelse>
			<cfset A_int_day_start = DayOfWeek(a_struct_events[ii].date_start)-1>
	
			<cfif A_int_day_start IS 0>
				<cfset A_int_day_start = 7>
			</cfif>
			
		</cfif> 
		
		
		
		<cfif Compare(GetISOWeek(a_struct_events[ii].date_end), a_int_weekno) NEQ 0>
			<cfset A_int_day_end = 7>
		<cfelse>
			<!--- a bug ... if the events is a whole day event, the
				next day will be included in the display routine ...
				
				that's wrong ... therefore subtract 1 minute in order
				to get the previous day if neccessay ... f.e. 12.10.2002 00:00 -> 11.10.2002 23:59 --->
			<cfset A_int_day_end = DayOfWeek(a_struct_events[ii].date_end)-1>
			
			<cfif A_int_day_end IS 0>
				<cfset A_int_day_end = 7>
			</cfif>
					
		</cfif> 	
		
		<cfset a_str_days = "">
		
		<cfloop index="a_int_day" from="#a_int_day_start#" to="#a_int_day_end#">
			<cfset a_str_days = a_str_days & "," & a_int_day>
		</cfloop>
	
		<cfset tmp = StructInsert(a_struct_events[ii], 'days',  a_str_days, true)>
	
	</cfloop>--->

<cfset a_dt_day_week =  request.a_dt_utc_current_date>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
  	<td colspan="7" class="addinfotext bb" align="center" style="text-transform:uppercase;letter-spacing:2px;font-size:10px;">
	<b><cfoutput>#GetLangVal('cal_wd_ph_day_next_days')#</cfoutput></b>
	</td>
  </tr>
  <tr class="mischeader">
  
  <cfset a_dt_day_week = DateAdd('d', -1, a_dt_day_week)>
  <cfset a_dt_week_original = a_dt_day_week>
  	
  <cfloop index="a_int_daynumber" from="1" to="7" step="1">
	
	<cfset a_dt_day_week = DateAdd("d", "1", a_dt_day_week)>
	
    <td align="center" width="15%" valign="middle" class="bb addinfotext">
		<cfset a_str_day_link = DateFormat(a_dt_day_week, 'mm/dd/yyyy')>
		
		<cfoutput>
		<a href="default.cfm?action=ViewDay&Date=#urlencodedformat(a_str_day_link)#" class="addinfotext">#LSDateFormat(a_dt_day_week, 'dddd')#
		<br>
		#DateFormat(a_dt_day_week, 'dd.mm')#</a></cfoutput>
		</td> 
  </cfloop>
   </tr>
   
  <tr>
  	<cfloop index="a_int_daynumber" from="1" to="7" step="1">
	
	<cfset a_dt_week_original = DateAdd("d", "1", a_dt_week_original)>
	
    <td valign="top" width="15%" class="<cfif a_int_daynumber GT 1>bl </cfif>bb">
	
	<cfset a_bol_events_found_this_day = false>
	
	<cfoutput query="q_select_events">
		<cfset a_int_start_db = Mid(q_select_events.int_start_num, 1, 8)>
		
		<cfset a_int_day_diff_event = (DateDiff('h', q_select_events.date_start, q_select_events.date_end) - 1) / 24>
		
		<cfset a_str_list_days = DateFormat(q_select_events.date_start, 'yyyymmdd')>
		
		<cfloop from="1" to="#a_int_day_diff_event#" index="ii">
			<cfset a_str_list_days = ListAppend(a_str_list_days, DateFormat(DateAdd('d', ii, q_select_events.date_start), 'yyyymmdd'))>
		</cfloop>
		
		<cfset a_int_start_display = DateFormat(a_dt_week_original, 'yyyymmdd')>
		
		<cfif ListFind(a_str_list_days, a_int_start_display) GT 0>
		<!---<cfif CompareNoCase(a_int_start_db, a_int_start_display) IS 0>--->
		
			<div style="padding:3px;">
			#Timeformat(q_select_events.date_start, 'HH:mm')#
						
			<cfset a_int_diff_hours = DateDiff('h', q_select_events.date_start, q_select_events.date_end)>
			<cfset a_int_diff_minutes = DateDiff('n', q_select_events.date_start, q_select_events.date_end)>
			
			
			<cfif a_int_diff_hours GT 0>
				(#a_int_diff_hours#h)
			<cfelseif a_int_diff_minutes GT 0>
				(#a_int_diff_minutes#')
			</cfif>
			</span>
			<br>
	
			<a href="default.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_events.entrykey)#">#htmleditformat(q_select_events.title)#</a>
			
			<cfif LEN(q_select_events.workgroupkeys) GT 0>
				<img src="/images/calendar/16kalender_gruppen.gif" width="12" height="12" align="absmiddle" border="0">
			</cfif>
			</div>
		</cfif>
		
	</cfoutput>
			
			
	&nbsp;
	</td>
	</cfloop>	
  </tr>
</table>