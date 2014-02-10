
<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="UPDATE called" type="html">
<html>
	<head>
	
	</head>
	<body>
		<hr>
		<cfdump var="#arguments#">
	</body>
</html>
</cfmail>--->
<cfloop from="1" to="#ArrayLen(arguments.data)#" index="ii">

<cfset a_struct_data = arguments.data[ii]>

<cfset stUpdate = StructNew()>

<cfset stUpdate.title = a_struct_data.subject>
<cfset stUpdate.entrykey = a_struct_data.inboxcc_entrykey>

<cfif isDate(a_struct_data.duedate)>
	<cfset stUpdate.duedate = LsParseDateTime(a_struct_data.duedate)>
<cfelse>
	<cfset stUpdate.dt_due = ''>
</cfif>

<cfset stUpdate.categories = a_struct_data.categories>
<cfset stUpdate.status = GetInBoxccStatusFromOutlookStatus(a_struct_data.status)>
<cfset stUpdate.percentdone = a_struct_data.percentcomplete>
<cfset stUpdate.priority = a_struct_data.importance>
<cfset stUpdate.actualwork = a_struct_data.actualwork>
<cfset stUpdate.totalwork = a_struct_data.totalwork>
<cfset stUpdate.notice = a_struct_data.body>
<cfset stUpdate.private = a_struct_data.sensitivity>
<cfset stUpdate.priority = GetInBoxccPriorityFromOutlookPriority(a_struct_data.importance)>

<!--- call update --->
<cfinvoke component="/components/tasks/cmp_task" method="UpdateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="entrykey" value="#a_struct_data.inboxcc_entrykey#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
</cfinvoke>

	<!--- call update meta data ... --->
	<cfif a_bol_return>
	
		<!--- only if update succeded --->
		<cfquery name="q_update" datasource="#request.a_str_db_tools#">
		UPDATE
			tasks_outlook_data
		SET
			lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(LSParseDateTime(a_struct_data.lastmodificationtime))#">
		WHERE		
			(taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_data.inboxcc_entrykey#">)
			AND
			(outlook_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_data.entryid#">)
		;
		</cfquery>
	</cfif>

</cfloop>