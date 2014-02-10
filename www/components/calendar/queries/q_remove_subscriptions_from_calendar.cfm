<!--- //
	Module:		Calendar
	Description:Deletes all subscriptions from calendar (we are going to delete)
	

	
// --->

<cfquery name="q_remove_subscriptions_from_calendar" datasource="#request.a_str_db_tools#">
DELETE FROM 
	virtualcalendarsubscriptions
WHERE
	virtualcalendarkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">
;
</cfquery>

