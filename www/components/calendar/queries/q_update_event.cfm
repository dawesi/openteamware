<!--- //
	Module:		 Calendar
	Description: Updates the calendar record
// --->

<cfquery name="q_update_event" datasource="#request.a_str_db_tools#">
UPDATE
	calendar
SET
	dt_lastmodified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	
	lasteditedbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	
	daylightsavinghoursoncreate = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.usersettings.DAYLIGHTSAVINGHOURSONLY#">
	
	<cfif StructKeyExists(arguments.newvalues, 'userkey') AND (Len(arguments.newvalues.userkey) GT 0)>
		<!--- someone wants to take over the ownership ... --->
		
		<cfif stReturn_rights.managepermissions is true>
		,userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.userkey#">
		</cfif>
	
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'title')>
	,title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.title#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'categories')>
	,categories = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.categories#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'description')>
	,description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.description#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'privateevent')>
	,privateevent = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.privateevent)#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'location')>
	,location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.location#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'color')>
	,color = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.color#">
	</cfif>	
	<cfif StructKeyExists(arguments.newvalues, 'showtimeas')>
	,showtimeas = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.showtimeas#">
	</cfif>	
	
	<cfif StructKeyExists(arguments.newvalues, 'virtualcalendarkey')>
	,virtualcalendarkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.virtualcalendarkey#">
	</cfif>
	
	,meetingmemberscount = (select count(id) from meetingmembers where eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"> and temporary = 1)
	
	<cfif StructKeyExists(arguments.newvalues, 'date_start')>
	,date_start = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.date_start)#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'date_end')>
	
		<!--- check if end date is greather than start date ... --->
		<cfif StructKeyExists(arguments.newvalues, 'date_start')>
			<cfif arguments.newvalues.date_end LTE arguments.newvalues.date_start>
				<cfset arguments.newvalues.date_end = DateAdd('h', 1, arguments.newvalues.date_start)>
			</cfif>
		</cfif>
	
	,date_end = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.date_end)#">
	</cfif>
	
	<!--- recurring elements ... --->
	<cfif StructKeyExists(arguments.newvalues, 'repeat_type')>
	,repeat_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_type#">
	</cfif>	
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_until')>
		<cfif isDate(arguments.newvalues.repeat_until)>
			,repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(arguments.newvalues.repeat_until)#">
		<cfelse>
			,repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
		</cfif>
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_1')>
	,repeat_day_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_1#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_2')>
	,repeat_day_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_2#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_3')>
	,repeat_day_3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_3#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_4')>
	,repeat_day_4 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_4#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_5')>
	,repeat_day_5 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_5#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_6')>
	,repeat_day_6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_6#">
	</cfif>
	
	<cfif StructKeyExists(arguments.newvalues, 'repeat_day_7')>
	,repeat_day_7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.repeat_day_7#">
	</cfif>				
	
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfinclude template="q_commit_temporary_attendees.cfm">


