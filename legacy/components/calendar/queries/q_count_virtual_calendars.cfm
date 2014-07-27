<!--- //
	Module:		Calendar
	Description:Select amount of virtual calendars with specified title for user
	            (check is same named calendar already exists)
	

	
// --->
<cfquery name="q_count_virtual_calendars" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	virtualcalendars
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
<cfif arguments.virtualcalendarkey GT 0>
	AND
	entrykey != <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">
</cfif>
;
</cfquery>

