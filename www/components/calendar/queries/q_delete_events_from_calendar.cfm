<!--- //
	Module:		Calendar
	Description:Delete all events from specified virtual calendar
	

	
// --->

<cfquery name="q_delete_events_from_calendar">
DELETE FROM
	calendar
WHERE
	virtualcalendarkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">
;
</cfquery>

