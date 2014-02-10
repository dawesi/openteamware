<!--- //

	Module:		Import
	Function:	GetEventsFromTo
	Description:Select all events of a given timeframe
	

// --->

<!--- get utc start/end --->
<cfset a_dt_start = arguments.startdate />
<cfset a_dt_end = arguments.enddate />

<cfset a_int_converted_day_start = Day(DateAdd("h", -arguments.usersettings.utcdiff, a_dt_start)) />
<cfset a_int_converted_day_end = Day(DateAdd("h", -arguments.usersettings.utcdiff, a_dt_end)) />

<cfset a_int_converted_month_start = Month(DateAdd("h", -arguments.usersettings.utcdiff, a_dt_start)) />
<cfset a_int_converted_month_end = Month(DateAdd("h", -arguments.usersettings.utcdiff, a_dt_end)) />

<cfset a_int_days_diff = DateDiff("d", a_dt_start, a_dt_end) />

<!--- events from virtual calendars the user is subscribed into? --->
<cfset a_bol_vcal_avaliable = arguments.loadeventofsubscribedcalendars />

<cfset a_str_virtual_calendar_subscriptions = '' />

<cfif a_bol_vcal_avaliable>
	<!--- get subscriptions ... --->
	<cfset a_str_virtual_calendar_subscriptions = GetVirtualCalendarSubscriptions(arguments.securitycontext.myuserkey) />
</cfif>

<cfset begin = GetTickCount() />

<!--- ignore items of inherites workgroup memberships? by default, true ... --->
<cfif StructKeyExists(arguments.filter, 'ignoreeventsofinheritedworkgroups') AND
	  (arguments.filter.ignoreeventsofinheritedworkgroups)>

	<cfquery name="variables.q_select_workgroups" dbtype="query">
	SELECT
		*
	FROM
		arguments.securitycontext.q_select_workgroup_permissions
	WHERE
		inherited_membership = 0
	;	
	</cfquery>
	
<cfelse>
	<cfset variables.q_select_workgroups =  arguments.securitycontext.q_select_workgroup_permissions />
</cfif>

<!--- // filter by meetingmember keys? select only the events where a certain person is a meeting member // --->
<cfif StructKeyExists(arguments.filter, 'meetingmember_contact_entrykeys') AND
	  (Len(arguments.filter.meetingmember_contact_entrykeys) GT 0)>

	<cfquery name="q_select_meeting_members_eventskeys_by_parameter" datasource="#request.a_str_db_tools#">
	/* selecting appointment entrykeys by meetingmembers parameters ... */
	SELECT
		meetingmembers.eventkey,
		meetingmembers.parameter,
		meetingmembers.type
	FROM
		meetingmembers
	WHERE
		meetingmembers.parameter IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.meetingmember_contact_entrykeys#" list="yes">)
        AND
        temporary = 0
	;
	</cfquery>
	
	<!--- if none found, return a dummy string ... otherwise, we filter for the given entrykeys --->
	<cfif q_select_meeting_members_eventskeys_by_parameter.recordcount IS 0>
		<cfset arguments.filter.entrykeys = 'thegivenentrykeydoesnotexist' />
	<cfelse>
		<cfset arguments.filter.entrykeys = ValueList(q_select_meeting_members_eventskeys_by_parameter.eventkey) />
	</cfif>

</cfif>


<!--- // Collect the entrykeys/Ids of items to load ...

	Start with 
	
		0 = private items, continue with
		3 = workgroup,
		2 = virtual and
		1 = meetingmembers
		
		These numbers have no further sense, they are just for a better handling of the data
	
	maybe apply filter to it afterwards
	
	
	VERY IMPORTANT: THE CORRECT SELECT COLUMN ORDER (MUST BE THE VERY SAME IN EVERY QUERY !!

	entrykey AS eventkey, id, workgroupkey, virtualcalendarkey, item_type, repeat ...
	// --->
	
<cfquery name="q_select_collect_items_to_load" datasource="#request.a_str_db_tools#">
SELECT * FROM 
(
/* select all own items of the user ... */
SELECT
	calendar.entrykey AS eventkey,
	calendar.id AS id,
	'' AS workgroupkey,
	calendar.virtualcalendarkey AS virtualcalendarkey,
	0 AS item_type,

	calendar.repeat_type,
	calendar.repeat_until,
	calendar.date_start,
	calendar.date_end
FROM
	calendar
WHERE
	(
		(calendar.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	)
	AND
	(	
		<cfinclude template="inc_q_select_events_timeframe.cfm">		
	)
	
<cfif variables.q_select_workgroups.recordcount GT 0>

	<!--- continue with workgroup items ... --->
	<cfset a_bol_workgroups_avaliable = true />
	
	/* union with all workgroup appointments ... */
	
	UNION
	SELECT
		calendar_shareddata.eventkey AS eventkey,
		calendar.id AS id,
		calendar_shareddata.workgroupkey AS workgroupkey,
		calendar.virtualcalendarkey AS virtualcalendarkey,
		3 AS item_type,
		
		calendar.repeat_type,
		calendar.repeat_until,
		calendar.date_start,
		calendar.date_end
	FROM
		calendar_shareddata
	LEFT JOIN
		calendar ON (calendar.entrykey = calendar_shareddata.eventkey)
	WHERE
		(
			calendar_shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(variables.q_select_workgroups.workgroup_key)#">)
		)
		AND
			(calendar.id > 0)
		AND
		(	
			<cfinclude template="inc_q_select_events_timeframe.cfm">		
		)
		
</cfif>

/* Continue with meeting members ... */
UNION
	SELECT
		meetingmembers.eventkey AS eventkey,
		calendar.id AS id,
		'' AS workgroupkey,
		calendar.virtualcalendarkey AS virtualcalendarkey,
		1 AS item_type,
		
		calendar.repeat_type,
		calendar.repeat_until,
		calendar.date_start,
		calendar.date_end
	FROM
		meetingmembers
	LEFT JOIN
		calendar ON (calendar.entrykey = meetingmembers.eventkey)
	WHERE
			(meetingmembers.parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
		AND
			(meetingmembers.type = 0)
        AND
            temporary = 0
		AND NOT	
			(status = -1)		
		AND
			(calendar.id > 0)
		AND
			(<cfinclude template="inc_q_select_events_timeframe.cfm">)


	<cfif Len(a_str_virtual_calendar_subscriptions) GT 0>
		
	/* virtual calendar subscriptions ... */
	UNION
		SELECT
			calendar.entrykey AS eventkey,
			calendar.id AS id,
			'' AS workgroupkey,
			calendar.virtualcalendarkey AS virtualcalendarkey,
			2 AS item_type,
			
			calendar.repeat_type,
			calendar.repeat_until,
			calendar.date_start,
			calendar.date_end
		FROM
			calendar
		WHERE
			(	
				virtualcalendarkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_virtual_calendar_subscriptions#" list="yes">)
			)	
			AND
			(	
				<cfinclude template="inc_q_select_events_timeframe.cfm">
			)
			
	</cfif>
	
) AS calendar_collect

/* now continue with the general WHERE SQL causes */
WHERE
	
	(
		<cfinclude template="inc_q_select_events_common_filter.cfm">
	)
;
</cfquery>

<cfset stReturn.q_select_collect_items_to_load = q_select_collect_items_to_load />

<!--- // select the workgroup entries ... // --->
<cfif variables.q_select_workgroups.recordcount GT 0>
	
	<cfquery name="q_select_workgroup_entrykeys" dbtype="query">
	SELECT
		eventkey,
		id,
		workgroupkey
	FROM
		q_select_collect_items_to_load
	WHERE
		item_type = 3
	;
	</cfquery>

	<cfset a_bol_workgroups_avaliable = (q_select_workgroup_entrykeys.recordcount GT 0) />
	
<cfelse>
	<!--- no wgs available (or selected ...) ... --->
	<cfset a_bol_workgroups_avaliable = false />
</cfif>	

<!--- get out events where meeting members are in the game ... --->
<cfquery name="q_select_meeting_members_entrykeys" dbtype="query">
SELECT
	eventkey,
    id
FROM
	q_select_collect_items_to_load
WHERE
	item_type = 1
;
</cfquery>
	
<cfset a_bol_meeting_members_avaliable = (q_select_meeting_members_entrykeys.recordcount GT 0) />

<!--- select private items from full query ... --->
<cfquery name="q_select_private_entrykeys" dbtype="query">
SELECT
	eventkey,
    id
FROM
	q_select_collect_items_to_load
WHERE
	item_type = 0
;
</cfquery>

<!--- Select virtual calendar items from full query ... --->
<cfquery name="q_select_virtual_calendars" dbtype="query">
SELECT
	eventkey,
    id
FROM
	q_select_collect_items_to_load
WHERE
	item_type = 2
;
</cfquery>
	
<cfset a_bol_vcal_avaliable = (q_select_virtual_calendars.recordcount GT 0)>

<!--- combine private and workgroup entries ... --->
<cfset sIDList = valuelist(q_select_private_entrykeys.id) />

<cfif a_bol_workgroups_avaliable>
	<cfset sEntrykeys = ValueList(q_select_private_entrykeys.eventkey) & ',' & ValueList(q_select_workgroup_entrykeys.eventkey) />
	<cfset sIDList = ListAppend(sIDList, ValueList(q_select_workgroup_entrykeys.id)) />
<cfelse>
	<cfset sEntrykeys = valuelist(q_select_private_entrykeys.eventkey) />
</cfif>

<!--- add possible virtual calendars ... --->
<cfif a_bol_vcal_avaliable>
	<cfset sEntrykeys = ListPrepend(sEntrykeys, ValueList(q_select_virtual_calendars.eventkey)) />
	<cfset sIDList = ListAppend(sIDList, ValueList(q_select_virtual_calendars.id)) />
</cfif>

<!--- add possible meeting members only events ... --->
<cfif a_bol_meeting_members_avaliable>
	<cfset sEntrykeys = ListPrepend(sEntrykeys, ValueList(q_select_meeting_members_entrykeys.eventkey)) />
	
	<cfset sIDList = ListAppend(sIDList, ValueList(q_select_meeting_members_entrykeys.id)) />
</cfif>

<cfif Len(sEntrykeys) LTE 10>
	<!--- no valid events found, return zero ... --->
	<cfset sEntrykeys = 'thiseventdoesnotexist' />
</cfif>

<cfif Len(sIDList) IS 0>
	<cfset sIDList = 0 />
</cfif>

<!--- Now, select the appointments on the collected IDs --->
<cfquery name="q_select_events" datasource="#request.a_str_db_tools#">
SELECT
	calendar.entrykey,
	calendar.userkey,
	calendar.meetingmemberscount,
	calendar.daylightsavinghoursoncreate,
	
	<cfif arguments.loadutctimes>
		date_start,
		date_end,
		dt_created,
		dt_lastmodified,
	<cfelse>
		<!--- default: adjust times --->
		DATE_ADD(date_start, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS date_start,
		DATE_ADD(date_end, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS date_end,
		DATE_ADD(dt_created, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_created,
		DATE_ADD(dt_lastmodified, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_lastmodified,
	</cfif>
	
	date_end - date_start AS dt_duration,
	categories,
	utcdiffoncreation,
	title,
	description,
	type,
	location,
	associatedurl,
	privateevent,
	color,
	repeat_type,repeat_weekday,repeat_day,repeat_month,repeat_until,
	repeat_day_1,repeat_day_2,repeat_day_3,repeat_day_4,repeat_day_5,repeat_day_6,repeat_day_7,
	virtualcalendarkey,
	createdbysecretarykey,
	createdbyuserkey,
	'' AS workgroupkeys,
	0 AS starthour,
	0 AS int_start_num,
	'' AS uniquekey
FROM
	calendar
WHERE
	(
		id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#sIDList#" list="yes">)
	)
	
	<cfif StructCount(arguments.filter) GT 0>
		
		<cfif StructKeyExists(arguments.filter, 'search')>
			AND
				(
					UPPER(title) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.filter.search)#%">
					OR
					UPPER(description) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.filter.search)#%">
					OR
					UPPER(categories) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.filter.search)#%">
				)
			</cfif>
	</cfif>
	
	<!--- TODO: allow filter according to certain fields ... --->
	
	<!--- shared event or not? --->
	AND
		(
			(
				(repeat_type = 0)
				
				AND
				
						(
							<!--- start in our timeframe --->
							(date_start >= <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
							AND
							(date_start < <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)
						)
						
						OR
						
						(
							<!--- start and end before and after our timeframe --->
							(date_start < <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
							AND
							(date_end > <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)
						)
						
						OR
						
						(
							<!--- end in our timeframe --->
							(date_end > <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
							AND
							(date_end < <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)
						)				
				
			)
		
			OR
		
			(
			
				<!--- repeating events ... --->				
				(repeat_type > 0)							
					
			)
					
				AND
				
					(
						<!--- daily repeating event ... --->
						(repeat_type = 1)
						<!--- die tage herausfinden wo das stattfindet 1234567 --->
						
						<!--- dates are stored here:
							repeat_day_1 ... (sunday)
							repeat_day_2 ... (saturday)
							
							--->
						
						AND
						
							(
							<!--- die betroffenen wochentage ermitteln --->
							
							<cfif a_int_days_diff GTE 6>
								<!--- alle tage --->
								(repeat_day_1 = 1) OR
								(repeat_day_2 = 1) OR
								(repeat_day_3 = 1) OR
								(repeat_day_4 = 1) OR
								(repeat_day_5 = 1) OR
								(repeat_day_6 = 1) OR
								(repeat_day_7 = 1)
							<cfelse>
							
								<!--- only certain days are affected --->
								<cfset a_arr_days = ArrayNew(1)>
								<!--- create an arreay from one to seven ... --->
								<cfset tmp = ArraySet(a_arr_days, 1, 7, 0)>
								
								<!--- get the real dayofweek, not utc ... otherwise
									we would get this event on days where it does not exist --->
								<cfset a_dt_tmp_start = a_dt_start><!---Dateadd("h", -usersettings.utcdiff, a_dt_start)>--->
								<cfset a_dt_tmp_end = a_dt_end><!--- Dateadd("h", -usersettings.utcdiff, a_dt_end)>--->
								
								<cfset a_int_dayofweek_start = dayofweek(GetLocalTime(a_dt_tmp_start))>
								<cfset a_int_dayofweek_end = dayofweek(GetLocalTime(a_dt_tmp_end))>

								<cfif a_int_dayofweek_start GT a_int_dayofweek_end>
									
									<!--- f.e. 7-1 (saturday to sunday) --->
									<cfloop index="aii" from="#a_int_dayofweek_start#" to="7">
										<cfset a_arr_days[aii] = 1>
									</cfloop>
									
									<cfloop index="aii" from="1" to="#a_int_dayofweek_end#">
										<cfset a_arr_days[aii] = 1>
									</cfloop>																		
									
								<cfelse>
								
									<!--- f.e. 3-5 --->
									<cfloop index="aii" from="#dayofweek(a_int_dayofweek_start)#" to="#dayofweek(a_int_dayofweek_end)#">
										<cfset a_arr_days[aii] = 1>
									</cfloop>
								</cfif>
								
								
								(
									<cfloop index="ii" from="1" to="7">
										<cfif NOT CompareNoCase(a_arr_days[ii], 1)>
											(repeat_day_#ii# = 1) OR
										</cfif>
									</cfloop>
								(1=0))
							</cfif>
							
							)
					
					)
					
					OR
					
					<!--- weekly repeatment ... --->
					(		
		
						<!--- wenn es gr��er w�re w�rde es den ganzen monat umfassen und egal sein --->
					
						(repeat_type = 2) 
						
						<!--- der wochentag als ziffer steht in repeat_weekday drinnen --->
						<cfif a_int_days_diff LTE 6>
						<!--- not a full week ... check for the correct weekday ... --->
						AND
												
						<!--- calculate user times in order to get correct weekdays --->
						<cfset a_dt_tmp_start = Dateadd("h", -usersettings.utcdiff, a_dt_start)>
						<cfset a_dt_tmp_end = Dateadd("h", -usersettings.utcdiff, a_dt_end)>
						
						<cfset a_int_dayofweek_start = DayofWeek(a_dt_tmp_start)>
						<cfset a_int_dayofweek_end = DayofWeek(a_dt_tmp_end)>
						
						
						
							<cfif a_int_dayofweek_start GT a_int_dayofweek_end>
							
								<!--- f.e. 7-1 --->
								
								<cfset a_str_weekday_list = ''>
								
								<cfloop from="#a_int_dayofweek_start#" to="7" index="ii_weekday">
									<cfset a_str_weekday_list = ListPrepend(a_str_weekday_list, ii_weekday)>
								</cfloop>
								
								<cfloop from="#a_int_dayofweek_end#" to="1" index="ii_weekday">
									<cfset a_str_weekday_list = ListPrepend(a_str_weekday_list, ii_weekday)>
								</cfloop>								
								
								(
								repeat_weekday IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#a_str_weekday_list#" list="yes">)
								 )
							
							<cfelse>
							
							(repeat_weekday
							
								BETWEEN
								
								<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_dayofweek_start#">
								AND
								<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_dayofweek_end#">
								
								)

							</cfif>								
						
						</cfif>
					
					)
					
					OR
						<!--- monthly --->
						(
							(repeat_type = 3)

							<!---AND
							(
								repeat_day 
								
									BETWEEN
									
										<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_converted_day_start#">
							 			AND
										<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_converted_day_end#">
							)--->
						)
					OR
						<!--- yearly --->
						(
						    (repeat_type = 4)
							
							<!---AND
								(
									repeat_day
								
										BETWEEN 
											
											<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_converted_day_start#">
											AND
											<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_converted_day_end#">
								)--->
							AND
								(
									repeat_month
										
										BETWEEN
										
											<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_converted_month_start#">
											AND
											<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_converted_month_end#">
								)
						)					
				
					
		)
ORDER BY
	date_start
;
</cfquery>

<!--- <cfif CompareNoCase(arguments.securitycontext.myusername, 'hp@openTeamware.com') IS 0>
<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="calendar select #arguments.startdate#" type="html">
<cfdump var="#q_select_collect_items_to_load#">
<cfdump var="#q_select_events#">
<cfdump var="#variables#">
</cfmail>
</cfif> --->

<!--- create workgroup information ... --->
<cfif a_bol_workgroups_avaliable>

	<cfloop query="q_select_workgroup_entrykeys">
		
		<cfif StructKeyExists(stWGInfo, q_select_workgroup_entrykeys.eventkey)>	
			<cfset stWGInfo[q_select_workgroup_entrykeys.eventkey] = stWGInfo[q_select_workgroup_entrykeys.eventkey]&","&q_select_workgroup_entrykeys.workgroupkey>
		<cfelse>
			<cfset stWGInfo[q_select_workgroup_entrykeys.eventkey] = q_select_workgroup_entrykeys.workgroupkey>
		</cfif>
	
	</cfloop>
</cfif>

<!--- set workgroup information --->
<cfloop query="q_select_events">
	<!--- set the unique key for this item ... --->
	<cfset QuerySetCell(q_select_events, 'uniquekey', RandRange(1, 10000), q_select_events.currentrow) />
</cfloop>

