<!--- //
	Module:		Calendar
	Description:Updates specified virtual calendar
	

	
// --->

<cfquery name="q_update_virtual_calendar">
UPDATE
	virtualcalendars
SET	
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">,
	title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.title#">,
	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.description#">,
<!---	language = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.database_values.language#">, --->
	colour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.colour#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#">
;
</cfquery>

