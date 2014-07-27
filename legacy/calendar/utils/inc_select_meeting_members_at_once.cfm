
<cfparam name="SelectMeetingMembersAtOnline.q_select_events" type="query">

<cfquery name="q_select_events_with_meeting_members" dbtype="query">
SELECT
	entrykey
FROM
	SelectMeetingMembersAtOnline.q_select_events
WHERE
	meetingmemberscount > 0
;
</cfquery>

<cfif q_select_events_with_meeting_members.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_events_with_meeting_members_cache = ValueList(q_select_events_with_meeting_members.entrykey)>

<!--- load all meeting members of these events ... --->
<cfinvoke component="#application.components.cmp_calendar#" method="GetMeetingMembers" returnvariable="q_select_meeting_members_cache">
	<cfinvokeargument name="entrykey" value="">
	<cfinvokeargument name="entrykeys" value="#a_str_events_with_meeting_members_cache#">
</cfinvoke>

<!--- create list of contacts --->
<cfset a_str_meeting_members_entrykeys_cache = ValueList(q_select_meeting_members_cache.parameter)>

<cfif Len(a_str_meeting_members_entrykeys_cache) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = a_str_meeting_members_entrykeys_cache>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="loadfulldata" value="true">
</cfinvoke>

<cfoutput query="stReturn_contacts.q_select_contacts">
	<cfquery name="q_select_single_item" dbtype="query">
	SELECT
		*
	FROM
		stReturn_contacts.q_select_contacts
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stReturn_contacts.q_select_contacts.entrykey#">
	;
	</cfquery>
	
	<cfset a_struct_contacts_cached_info[stReturn_contacts.q_select_contacts.entrykey] = q_select_single_item>
</cfoutput>

<!---<cfdump var="#a_struct_contacts_cached_info#">--->