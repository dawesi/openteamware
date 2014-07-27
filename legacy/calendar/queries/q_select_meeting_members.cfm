<!--- // select meeting members for a specific event

	scope: SelectMeetingMembersRequest
	// --->
	
<cfparam name="SelectMeetingMembersRequest.id" default="0" type="numeric">

<!--- select only specific status? (f.e. persons who have not reacted? --->
<cfparam name="SelectMeetingMembersRequest.StatusOnly" default="-2" type="numeric">

<cfquery name="q_select_meeting_members" datasource="myCalendar" debug="yes">
SELECT id,adrbid,emailaddress,status FROM meeting_members
WHERE eventid = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectMeetingMembersRequest.id#">

<cfif SelectMeetingMembersRequest.StatusOnly gt -2>
	AND status = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectMeetingMembersRequest.StatusOnly#">
</cfif>

;
</cfquery>