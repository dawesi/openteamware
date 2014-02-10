<!--- //

	Module:		Calendar
	Function:	GetEventsFromTo
	Description:Clean up return query (remove out of timeframe events ...)
	

// --->
	
<cfset a_str_remove_items = '' />
<cfset a_str_delete_uniquekeys = '' />

<cfset a_tmp_dt_local_enddate = DateAdd('h', -arguments.usersettings.utcdiff, arguments.enddate) />
<cfset a_tmp_dt_local_startdate = DateAdd('h', -arguments.usersettings.utcdiff, arguments.startdate) />


<cfloop query="q_select_events">
	<!--- q_select_events.date_start LT a_tmp_dt_local_startdate AND  --->
	
	<!--- changed: LTE ... termine die bis 00:00 dauern tauchen am n�chsten tag nicht mehr auf --->
	<cfif (q_select_events.date_end LTE a_tmp_dt_local_startdate)
			OR 
		  (q_select_events.date_start GT a_tmp_dt_local_enddate)>
		  
		  <cfset a_str_remove_items = a_str_remove_items & "," & q_select_events.CurrentRow />
		  
		  <cfset a_str_delete_uniquekeys = ListPrepend(a_str_delete_uniquekeys, q_select_events.uniquekey) />
	</cfif>	
	
	<cfset a_str_int_date_start = DateFormat(q_select_events.date_start, 'yyyymmdd')&TimeFormat(q_select_events.date_start,'HHmm') />

	<cfset QuerySetCell(q_select_events, 'int_start_num', Int(a_str_int_date_start), q_select_events.currentrow) />
</cfloop>

<cfloop query="q_select_events">
	<cfset a_int_temp_diff_db = q_select_events.daylightsavinghoursoncreate + q_select_events.utcdiffoncreation>
	
	<!--- changed: LTE ... termine die bis 00:00 dauern tauchen am n�chsten tag nicht mehr auf --->
	<cfif (a_int_temp_diff_db IS -2)
		    AND
		  (q_select_events.date_start GTE a_tmp_dt_local_enddate)>
		    
		  <cfset a_str_delete_uniquekeys = ListPrepend(a_str_delete_uniquekeys, q_select_events.uniquekey)>
	</cfif>	
</cfloop>

<!--- dateformat ... PREVENT the bug ... --->
<cfoutput query="q_select_events">

	<!--- calculate and set numeric start date --->
	<cfset a_str_int_date_start = DateFormat(q_select_events.date_start, 'yyyymmdd') & TimeFormat(q_select_events.date_start, 'HHmm') />

	<cfset QuerySetCell(q_select_events, 'int_start_num', Int(a_str_int_date_start), q_select_events.currentrow) />
</cfoutput>

<cfquery name="q_select_events" dbtype="query">
SELECT
	*
FROM
	q_select_events
<cfif Len(a_str_delete_uniquekeys) GT 0>
WHERE
	uniquekey NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_delete_uniquekeys#" list="yes">)
</cfif>
ORDER BY
	int_start_num
;
</cfquery>

<cfoutput query="q_select_events">
	
	<cfif Len(q_select_events.repeat_until) IS 0>
		<!--- generate dummy value ... is that a good idea? --->
		<cfset QuerySetCell(q_select_events, 'repeat_until', q_select_events.date_end, q_select_events.currentrow)>
	</cfif>
	
	<cfset QuerySetCell(q_select_events, 'starthour', hour(q_select_events.date_start), q_select_events.currentrow)>
	
	<cfif StructKeyExists(stWGInfo,q_select_events.entrykey)>
		<cfset tmp = QuerySetCell(q_select_events, 'workgroupkeys', stWGInfo[q_select_events.entrykey], q_select_events.currentrow)>
	</cfif>	
</cfoutput>

<cfif StructKeyExists(variables, 'q_select_meeting_members_eventskeys_by_parameter')>

	<cfset a_str_sql_dummy_select = ListAppend(variables.q_select_meeting_members_eventskeys_by_parameter.eventkey, q_select_events.entrykey) />
	<cfset a_str_sql_dummy_select = ListAppend(a_str_sql_dummy_select, 'thisitemdoesnotexist') />

	<cfquery name="q_select_meeting_members_eventskeys_by_parameter" dbtype="query">
	SELECT
		*
	FROM
		q_select_meeting_members_eventskeys_by_parameter
	WHERE
		eventkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_sql_dummy_select#" list="true">)

	;
	</cfquery>
</cfif>


