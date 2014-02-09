<cfset sEntrykeys_contacts_with_events = ''>

<cfset sEntrykeys_addressbook = ValueList(q_select_contacts.entrykey)>

<cfinvoke component="#request.a_str_component_assigned_items#" method="GetAssignments" returnvariable="q_select_assignments">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="objectkeys" value="#sEntrykeys_addressbook#">
</cfinvoke>
	
<cfset a_str_objectkeys_with_assignments = ValueList(q_select_assignments.objectkey)>
<!---

<cfset a_dt_begin = CreateDate(2000, 1, 1)>
<cfset a_dt_end = DateAdd('yyyy', 3, Now())>
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.meetingmember_contact_entrykeys = sEntrykeys_addressbook>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn_calendar">
	<cfinvokeargument name="startdate" value="#a_dt_begin#">
	<cfinvokeargument name="enddate" value="#a_dt_end#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="calculaterepeatingevents" value="false">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfquery name="q_select_events_with_this_contacts" dbtype="query">
SELECT
	*,'' AS meeting_members_entrykeys
FROM
	stReturn_calendar.q_select_events
;
</cfquery>
	
<cfoutput query="q_select_events_with_this_contacts">
	<!--- select meeting members and append ... --->
	<cfquery name="q_select_meeting_members_for_this_event" dbtype="query">
	SELECT
		parameter
	FROM
		stReturn_calendar.q_select_meeting_members_eventskeys_by_parameter
	WHERE
		eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_events_with_this_contacts.entrykey#">
	;
	</cfquery>
	
	<cfloop query="q_select_meeting_members_for_this_event">
		<cfset sEntrykeys_contacts_with_events = ListAppend(sEntrykeys_contacts_with_events,q_select_meeting_members_for_this_event.parameter)>
	</cfloop>
	
	<!---<cfset a_str_meeting_members_for_this_event = ValueList(q_select_meeting_members_for_this_event.parameter)>
	
	<cfset QuerySetCell(q_select_events_with_this_contacts, 'meeting_members_entrykeys', a_str_meeting_members_for_this_event, q_select_events_with_this_contacts.currentrow)>--->
</cfoutput>
	
<!--- generate list of objectkeys --->
<cfset a_str_objectkeys_with_assigned_events = ValueList(q_select_events_with_this_contacts.entrykey)>
---><!--- 

<cfset a_struct_filter_followups = StructNew()>
<cfset a_struct_filter_followups.objectkeys = sEntrykeys_addressbook>
<cfset a_struct_filter_followups.done = 0>

<cfinvoke component="#request.a_str_component_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter_followups#">
</cfinvoke>	

<cfset a_str_objectkeys_with_followups = valuelist(q_select_follow_ups.objectkey)> --->