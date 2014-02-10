
<cfloop from="1" to="#ArrayLen(arguments.data)#" index="ii">

	<cfset a_struct_data = arguments.data[ii]>

	<cfset stUpdate = StructNew()>

	<cfset a_dt_lastmod = LsParseDateTime(a_struct_data.lastmodificationtime)>
	
	<!--- only proceed if we've got really a date/time object ... --->
	<cfif IsDate(a_struct_data.start)>
	
		<cfset a_dt_start = LsParseDateTime(a_struct_data.start)>
		<cfset a_dt_end = LsParseDateTime(a_struct_data.end)>	
		
		<cfset stUpdate = StructNew()>
		<cfset stUpdate.entrykey = a_struct_data.inboxcc_entrykey>
		<cfset stUpdate.title = Mid(a_struct_data.subject, 1, 250)>
		<cfset stUpdate.description = a_struct_data.body>
		<cfset stUpdate.location = a_struct_data.location>
		<cfset stUpdate.categories = Mid(a_struct_data.categories, 1, 250)>
		<cfset stUpdate.privateevent = val(a_struct_data.sensitivity)>
		<cfset stUpdate.date_start = a_dt_start>
		<cfset stUpdate.date_end = a_dt_end>
		
		<cfset stUpdate.repeat_type = 0>
			
		<cfinvoke component="#application.components.cmp_calendar#" method="UpdateEvent" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
			<cfinvokeargument name="entrykey" value="#a_struct_data.inboxcc_entrykey#">
			<cfinvokeargument name="newvalues" value="#stUpdate#">
		</cfinvoke>
		
		<cfif (a_struct_data.isrecurring) IS 1>
			<!--- insert wh --->
			<cfinvoke component="cmp_set_recur" method="SetRecurrence" returnvariable="a_return_bol">
				<cfinvokeargument name="entrykey" value="#a_struct_data.inboxcc_entrykey#">
				<cfinvokeargument name="structure" value="#a_struct_data#">
			</cfinvoke>
		<cfelse>
			<!--- delete recurrence --->
		</cfif>	
	
	<cfelse>
		<cfset a_return_bol = false>
	</cfif>
	

	<!--- call update meta data ... --->
	<cfif a_bol_return>
	
		<!--- only if update succeded --->
		<cfquery name="q_update" datasource="#request.a_str_db_tools#">
		UPDATE
			calendar_outlook_data
		SET
			lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(LSParseDateTime(a_struct_data.lastmodificationtime))#">
		WHERE		
			(eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_data.inboxcc_entrykey#">)
			AND
			(outlook_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_data.entryid#">)
		;
		</cfquery>
	</cfif>

</cfloop>