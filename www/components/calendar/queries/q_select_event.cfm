<!--- //
	Module:		 Calendar
	Description: selects event by specified entrykey argument
// --->

<cfquery name="q_select_event">
SELECT
	entrykey,userkey,createdbysecretarykey,
	DATE_ADD(date_start, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS date_start,	
	DATE_FORMAT(DATE_ADD(date_start, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR), '%Y%m%d%H%i') AS date_start_numeric,	
	DATE_ADD(date_end, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS date_end,
	DATE_ADD(dt_created, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_created,
	date_end - date_start AS dt_duration,
	virtualcalendarkey,
	title,description,type,location,associatedurl,categories,priority,privateevent,color,showtimeas,
	repeat_type,repeat_weekday,repeat_day,repeat_month,repeat_until,
	repeat_day_1,repeat_day_2,repeat_day_3,repeat_day_4,repeat_day_5,repeat_day_6,repeat_day_7
FROM
	calendar
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
;
</cfquery>


