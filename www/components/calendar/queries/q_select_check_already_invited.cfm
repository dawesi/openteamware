
<!--- //
	Module:            calendar
	Description:       select amount of meeting member assigned to an event with specified parameter and type
// --->

<cfquery name="q_select_check_already_invited" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
	AND
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameter#">
	AND
	type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
    AND
    temporary = 1
;
</cfquery>

