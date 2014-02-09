<!--- //



	select the most imporant data

	

	- outlook_id

	- last update date

	- id of entry

	

	scopes: url, session, GetOutlookMetaData

	

	// --->
	
<cfset a_dt_start = CreateDate(1800, 1, 1)>
<cfset a_dt_end = CreateDate(2100, 1, 1)>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = form.ids>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#a_dt_end#">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
	<cfinvokeargument name="calculaterepeatingevents" value="false">
	<cfinvokeargument name="loadvirtualcalendars" value="false">
	<cfinvokeargument name="loadutctimes" value="true">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="get cal full data" type="html">
<html>
	<body>
		<cfdump var="#stReturn#">
	</body>
</html>
</cfmail>--->


<cfset a_str_program_id = form.program_id>

	
<cfset q_select_events = stReturn.q_select_events>

<cfquery name="q_select_events" dbtype="query">
SELECT
	*
FROM
	q_select_events
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.ids#">)
;
</cfquery>

<!--- load now outlook meta data ... --->
<cfquery name="q_select_ol_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	outlook_id,eventkey
FROM
	calendar_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_program_id#">
;
</cfquery>

<!--- ok, now map outlook_id and the real table ... --->

<cfset a_struct_ol_data = StructNew()>
<cfloop query="q_select_ol_meta_data">
	<cfset a_struct_ol_data[q_select_ol_meta_data.eventkey] = q_select_ol_meta_data.outlook_id>
</cfloop>

<!--- add the column ... --->
<cfset tmp = QueryAddColumn(q_select_events, 'outlook_id', ArrayNew(1))>

<cfloop query="q_select_events">
	<cfif StructKeyExists(a_struct_ol_data, q_select_events.entrykey)>
		<cfset QuerySetCell(q_select_events, 'outlook_id', a_struct_ol_data[q_select_events.entrykey], q_select_events.currentrow)>
	</cfif>
</cfloop>
	
	
<cfset q_select_cal_full_data = q_select_events>