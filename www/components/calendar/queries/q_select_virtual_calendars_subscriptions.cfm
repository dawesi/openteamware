<!--- //
	Module:		Calendar
	Description:All subscriptions of current user to virtual calendars
	

	
// --->

<cfquery name="q_select_virtual_calendars_subscriptions">
SELECT
	entrykey, virtualcalendarkey
FROM
	virtualcalendarsubscriptions
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

