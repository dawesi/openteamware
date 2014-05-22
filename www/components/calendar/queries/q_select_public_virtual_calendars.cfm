<!--- //
	Module:		Calendar
	Description:Load all public virtual calendars
	

	
// --->

<cfquery name="q_select_public_virtual_calendars" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,userkey,createdbyuserkey,title,description,companykey,public,dt_created,language,colour
FROM
	virtualcalendars
WHERE
	public = 1
;
</cfquery>
