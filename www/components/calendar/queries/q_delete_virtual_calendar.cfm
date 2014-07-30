<!--- //
	Module:		Calendar
	Description:Delete a virtual calendar definition
	

	
// --->
<cfquery name="q_delete_virtual_calendar">

DELETE FROM
	virtualcalendars
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">
;
</cfquery>

