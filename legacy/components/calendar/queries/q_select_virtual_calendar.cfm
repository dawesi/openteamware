<!--- //
	Module:		Calendar
	Description:Select specified calendar (by entrykey) only if current user is the owner
	

	
// --->

<cfquery name="q_select_virtual_calendar" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,userkey,createdbyuserkey,title,description,companykey,public,dt_created,language,colour
FROM
	virtualcalendars
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	and
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">
;
</cfquery>

