<!--- //
	Module:		Calendar
	Description:Selects all virtual calendars of the current user
	

	
// --->

<cfquery name="q_select_virtual_calendars" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,userkey,createdbyuserkey,title,description,companykey,public,dt_created,language,colour
FROM
	virtualcalendars
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

