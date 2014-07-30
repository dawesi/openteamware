<!--- //
	Module:		Calendar
	Description:Update virtualcalendarkey when virtual calendar is deleted by user
	

	
// --->

<cfquery name="q_update_virtualcalendar_deleted_item">
UPDATE
	calendar
SET
	virtualcalendarkey = ''
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	virtualcalendarkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">
;
</cfquery>
