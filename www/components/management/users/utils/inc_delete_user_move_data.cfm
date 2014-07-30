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
<cfquery name="q_update_tasks">
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
<cfquery name="q_update_calendar">
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
<cfquery name="q_update_contacts">
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
<cfquery name="q_update_followups">
UPDATE
	followups
SET
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.actionfordata_userkey#">,
	comment = CONCAT(comment,' #q_select_user.username#')
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>