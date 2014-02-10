<!--- //

	move data
	
	// --->
	
<!--- move following data:

	- contacts
	- events
	- followups
	- tasks
	
	--->
	
<!--- tasks --->
<cfquery name="q_update_tasks" datasource="#request.a_str_db_tools#">
UPDATE
	tasks
SET
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.actionfordata_userkey#">,
	categories = CONCAT(categories,',#q_select_user.username#')
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<!--- events --->
<cfquery name="q_update_calendar" datasource="#request.a_str_db_tools#">
UPDATE
	calendar
SET
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.actionfordata_userkey#">,
	categories = CONCAT(categories,',#q_select_user.username#')
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<!--- address book --->
<cfquery name="q_update_contacts" datasource="#request.a_str_db_tools#">
UPDATE
	addressbook
SET
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.actionfordata_userkey#">,
	categories = CONCAT(categories,',#q_select_user.username#')
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<!--- followups --->
<cfquery name="q_update_followups" datasource="#request.a_str_db_tools#">
UPDATE
	followups
SET
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.actionfordata_userkey#">,
	comment = CONCAT(comment,' #q_select_user.username#')
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>