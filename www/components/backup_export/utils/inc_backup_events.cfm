<!--- //
	
	get calendar data
	
	// --->
<cfsetting requesttimeout="20000">
	
<cfset a_struct_filter = StructNew()>

<cfset a_dt_begin = DateAdd('yyyy', -5, Now())>
<cfset a_dt_end = DateAdd('yyyy', 5, Now())>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn_calendar">
	<cfinvokeargument name="startdate" value="#a_dt_begin#">
	<cfinvokeargument name="enddate" value="#a_dt_end#">
	<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#variables.stUserSettings#">
	<cfinvokeargument name="calculaterepeatingevents" value="false">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>


<cfset variables.q_select_events = stReturn_calendar.q_select_events>

<cfquery name="variables.q_select_events" dbtype="query">
SELECT
	*
FROM
	variables.q_Select_events
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

<cfset tmp = LogMessage('events: ' & variables.q_select_events.recordcount)>

<!--- remove unwanted columns --->
<cfset variables.q_select_events = queryRemoveColumns(thequery = variables.q_select_events, columnsToRemove = 'workgroupkeys,entrykey,userkey,createdbyuserkey,INT_START_NUM,MEETINGMEMBERSCOUNT,starthour')>

<cfset variables.a_csv_events = QueryToCSV2(variables.q_select_events)>

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'appointments'>

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_backup_dir#/appointments.csv" output="#a_csv_events#">
