<!--- //
	Module:		Calendar
	Description:Unsubscribe from public virtual calendar (delete subscription record)
	

	
// --->

<cfquery name="q_remove_subscription" datasource="#request.a_str_db_tools#">
DELETE FROM 
	virtualcalendarsubscriptions
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscriptionkey#">
;
</cfquery>

