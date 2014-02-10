
<cfloop from="1" to="#arraylen(a_array_return)#" index="ii">

	<!---<cflog text="element #ii#" type="Information" log="Application" file="ib_sync">--->
	
	<cfset a_struct_element = a_array_return[ii]>
	
	

	<!--- parse dates --->	
	<cfset a_dt_lastmod = LsParseDateTime(a_struct_element.lastmodificationtime)>
	
	<cfif Len(trim(a_struct_element.duedate)) gt 0 AND IsDate(a_struct_element.duedate)>
		<cfset a_dt_due = LsParseDateTime(a_struct_element.duedate)>
	<cfelse>
		<cfset a_dt_due = ''>
	</cfif>
	
	<cfif (Len(trim(a_struct_element.datecompleted)) gt 0) AND
		  (IsDate(a_struct_element.datecompleted)) AND
		  (DateFormat(a_struct_element.datecompleted, "dd.mm.yyyy") neq "31.12.4500")>
		<cfset a_dt_completed = LsParseDateTime(a_struct_element.datecompleted)>
	</cfif>
	
	<!---<cflog text="calling component" type="Information" log="Application" file="ib_sync">--->
	
	<cfset a_str_ibcc_entrykey = CreateUUID()>
	
	<cfinvoke component="#application.components.cmp_tasks#" method="CreateTask" returnvariable="a_bol_return">
		<cfinvokeargument name="entrykey" value="#a_str_ibcc_entrykey#">
		<cfinvokeargument name="userkey" value="#session.stSecurityContext.myuserkey#">
		<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#session.stUserSettings#">			
		<cfinvokeargument name="title" value="#mid(a_struct_element.subject, 1, 250)#">
		<cfinvokeargument name="notice" value="#a_struct_element.body#">
		<cfinvokeargument name="priority" value="#GetInBoxccPriorityFromOutlookPriority(a_struct_element.importance)#">
		<cfinvokeargument name="percentdone" value="#val(a_struct_element.PercentComplete)#">
		<cfinvokeargument name="status" value="#GetInBoxccStatusFromOutlookStatus(a_struct_element.status)#">
		<cfinvokeargument name="actualwork" value="#val(a_struct_element.actualwork)#">
		<cfinvokeargument name="totalwork" value="#val(a_struct_element.actualwork)#">
		<cfinvokeargument name="categories" value="#a_struct_element.categories#">
		<cfinvokeargument name="private" value="#val(a_struct_element.sensitivity)#">
		
		<cfif IsDate(a_dt_due)>
			<cfinvokeargument name="due" value="#createodbcdatetime(a_dt_due)#">
		</cfif>
	</cfinvoke>
	<!---<cflog text="done. result: #a_bol_return#" type="Information" log="Application" file="ib_sync">--->
	
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
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_ibcc_entrykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_element.entryid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_lastmod)#">
		)
	;
	</cfquery>
		
</cfloop>