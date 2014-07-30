<!--- //

	update a task
	
	check if the data is provided
	
	
	
	// --->
	
<cfquery name="q_update_task">
UPDATE
	tasks
SET
	dt_lastmodified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	
	lasteditedbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	
	<cfif StructKeyExists(arguments.newvalues, 'userkey') AND (Len(arguments.newvalues.userkey) GT 0)>
		<!--- someone wants to take over the ownership ... --->
		
		<cfif stReturn_rights.managepermissions is true>
		,userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.userkey#">
		</cfif>
	
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'title')>
	,title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.title#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'notice')>
	,notice = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.notice#">
	</cfif>	
	
	<cfif StructKeyExists(arguments.newvalues, 'categories')>
	,categories = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.categories#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'status')>
	,status = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.status)#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'priority')>
	,priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.priority)#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'actualwork')>
	,actualwork = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.actualwork)#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'totalwork')>
	,totalwork = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.totalwork)#">
	</cfif>			
	
	<cfif StructKeyExists(arguments.newvalues, 'percentdone')>
	,percentdone = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.percentdone)#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'assignedtouserkeys')>
	,assignedtouserkeys = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.assignedtouserkeys#">
	</cfif>	
	
	<cfif StructKeyExists(arguments.newvalues, 'private')>
	,private = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.private)#">
	</cfif>	
	
	<cfif StructKeyExists(arguments.newvalues, 'dt_done')>
		
		<cfif isDate(arguments.newvalues.dt_done) is true>
		,dt_done = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.dt_done)#">		
		<cfelse>
		,dt_done = NULL
		</cfif>
		

	</cfif>		
	
	<cfif StructKeyExists(arguments.newvalues, 'dt_due')>
		
		<cfif isDate(arguments.newvalues.dt_due) is true>
		,dt_due = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.dt_due)#">
		<cfelse>
		,dt_due = NULL
		</cfif>
	
	</cfif>		

WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>