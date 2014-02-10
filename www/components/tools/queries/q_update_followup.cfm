<!--- //

	Component:	Follow Ups
	Function:	UpdateFollowup
	Description:Update a follow up item
	

// --->

<cfquery name="q_update_followup" datasource="#request.a_str_db_tools#">
UPDATE
	followups
SET
	entrykey = entrykey
	
	<cfif StructKeyExists(arguments.newvalues, 'done')>
		,done = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.done#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'dt_due')>
		,dt_due = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(arguments.newvalues.dt_due)#">
	</cfif>	
		
	<cfif StructKeyExists(arguments.newvalues, 'comment')>
		,comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.comment#">
	</cfif>	
	
	<cfif StructKeyExists(arguments.newvalues, 'subject')>
		,subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.subject#">
	</cfif>		
	
	<cfif StructKeyExists(arguments.newvalues, 'type')>
		,followuptype = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.type#">
	</cfif>		
	
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>

