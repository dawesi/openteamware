<!--- //

	Module:		Calendar
	Function:	GetCalendarItemsWithoutReports
	Description:Load events which are not yet set to done and have meeting members ...
	

// --->

<!--- get the week start ... in UTC (calculate from local time) --->
<cfset a_dt_start = DateAdd('d', -21, GetUTCDateTime(Now())>
<cfset a_dt_end = Now()>

<cfset a_struct_load_events = GetEventsFromTo(startdate = a_dt_start,
			enddate = a_dt_end,
			securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings)>

<cfset q_select_events = a_struct_load_events.q_select_events>


<!--- call a query of queries ... --->
<cfquery dbtype="query" name="q_select_events">
SELECT
	*
FROM
	calendar
WHERE
	private = 0
	AND
	meetingmemberscount > 0
	AND
	done = 0
;
</cfquery>
	
<!--- return the query above --->	
<cfset returnstruct.q_select_events = q_select_events>


