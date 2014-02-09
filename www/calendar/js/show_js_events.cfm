<cfparam name="url.date_start" type="date">
<cfparam name="url.date_end" type="date">

<cfcontent type="application/x-javascript; charset=UTF-8">

<cfset a_dt_start_load = url.date_start>
<cfset a_dt_end_load = url.date_end>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start_load#">
	<cfinvokeargument name="enddate" value="#a_dt_end_load#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events>

<cfsavecontent variable="a_str_js">
<cfoutput query="q_select_events">
this.add_item(#q_select_events.currentrow#, {type:'event', subject:'#jsstringformat(q_select_events.title)#', start:'#jsstringformat(q_select_events.date_start)#', end:'#jsstringformat(q_select_events.date_end)#', location:'#jsstringformat(q_select_events.location)#'});
</cfoutput>
</cfsavecontent>

<cfoutput>#a_str_js#</cfoutput>