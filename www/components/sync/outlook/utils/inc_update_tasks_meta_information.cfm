<!--- //

	check permission and update
	
	// --->
	
<cfset a_int_jj = ArrayLen(arguments.metadata)>

<cfset a_cmp_tasks = application.components.cmp_tasks />

<cfloop from="1" to="#a_int_jj#" index="ii">
	
	<!--- ok, here we go ... --->
	
	<cfset a_struct_item = arguments.metadata[ii]>

	<!--- example:
	
		A_DT_LASTMOD {ts '2003-11-22 16:59:58'}  
A_STR_INBOXCC_ENTRYKEY 824B6173-0388-E246-E32EFEEDDEDD1047  
A_STR_OUTLOOK_ID 00000000C09EF73BAB6E854EAB77BC856DA0CCD9A4B62300 
	--->
	
	<!--- check if new or already exists --->
	<cfif MetaItemExists(arguments.servicekey, arguments.program_id, a_struct_item.a_str_inboxcc_entrykey)>
		
		<!--- check the permissions if we can update the other meta data as well --->
		<cfset a_struct_permissions = application.components.cmp_security.GetPermissionsForObject(servicekey = #arguments.servicekey#, object_entrykey = #a_struct_item.a_str_inboxcc_entrykey#, securitycontext = #arguments.securitycontext#)>
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="meta does exist">
		test
		</cfmail>--->
		
		<cfquery name="q_update" datasource="#request.a_str_db_tools#">
		UPDATE
			tasks_outlook_data
		SET
			lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_struct_item.a_dt_lastmod)#">
		WHERE
			
			<cfif a_struct_permissions.edit IS FALSE>
				<!--- update only the item of this user ... --->
				(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">)
				AND
				<!--- otherwise update all occurances of this outlook item ... --->
			</cfif>		
			(taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_item.a_str_inboxcc_entrykey#">)
			AND
			(outlook_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_item.a_str_outlook_id#">)
		;
		</cfquery>
		
		
	<cfelse>
		<!--- insert new item ... --->
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="meta does not exist">
		test
		</cfmail>--->
		
		<cfquery name="q_insert_meta_data" datasource="#request.a_str_db_tools#">
		INSERT INTO
			tasks_outlook_data
			(
			program_id,
			taskkey,
			outlook_id,
			lastupdate
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_item.a_str_inboxcc_entrykey#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_item.a_str_outlook_id#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_struct_item.a_dt_lastmod)#">
			)
		;
		</cfquery>
		
	</cfif>

</cfloop>