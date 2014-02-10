
<cfloop from="1" to="#arraylen(a_array_return)#" index="ii">

	<cfset a_struct_element = a_array_return[ii]>
	
	<!--- parse dates ... why am I using LSParseDateTime instead of ParseDateTime?? --->	
	<cfset a_dt_lastmod = LsParseDateTime(a_struct_element.lastmodificationtime)>
	
	<cfif IsDate(a_struct_element.start)>
	
		<cfset a_dt_start = LsParseDateTime(a_struct_element.start)>
		<cfset a_dt_end = LsParseDateTime(a_struct_element.end)>	
		
		<cfset a_str_ibcc_entrykey = CreateUUID()>
			
		<cfinvoke component="#application.components.cmp_calendar#" method="CreateEvent" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#session.stUserSettings#">	
			<cfinvokeargument name="entrykey" value="#a_str_ibcc_entrykey#">
			<cfinvokeargument name="title" value="#mid(a_struct_element.subject, 1, 250)#">
			<cfinvokeargument name="description" value="#a_struct_element.body#">
			<cfinvokeargument name="categories" value="#a_struct_element.categories#">
			<cfinvokeargument name="priority" value="2">
			<cfinvokeargument name="location" value="#a_struct_element.location#">
			<cfinvokeargument name="privateevent" value="#val(a_struct_element.sensitivity)#">
			
			<cfinvokeargument name="date_start" value="#a_dt_start#">
			<cfinvokeargument name="date_end" value="#a_dt_end#">
			
			<cfinvokeargument name="repeat_type" value="0">
		</cfinvoke>
		
		<cfif (a_struct_element.isrecurring) IS 1>
			<!--- insert wh --->
			<cfinvoke component="cmp_set_recur" method="SetRecurrence" returnvariable="a_return_bol">
				<cfinvokeargument name="entrykey" value="#a_str_ibcc_entrykey#">
				<cfinvokeargument name="structure" value="#a_struct_element#">
			</cfinvoke>
		</cfif>
	
		<cfquery name="q_insert_meta_data" datasource="#request.a_str_db_tools#">
		INSERT INTO
			calendar_outlook_data
			(
			program_id,
			eventkey,
			outlook_id,
			lastupdate
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_ibcc_entrykey#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_element.entryid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_lastmod)#">
			)
		;
		</cfquery>
	</cfif>
		
</cfloop>