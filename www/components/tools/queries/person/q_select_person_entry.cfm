<!--- //

	Component:	Person
	Function:	GetUserPreference
	Description:Load user preference from database ...
	
// --->

<cfquery name="q_select_person_entry">
SELECT
	entryvalue1
FROM
	userpreferences
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">)
	AND
	(entrysection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.section#">)
	AND
	(entryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
; 
</cfquery>