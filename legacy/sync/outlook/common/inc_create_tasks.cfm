

<cfabort>
<cfloop from="1" to="#arraylen(a_array_return)#" index="ii">

	<cfset a_struct_element = a_array_return[ii]>
	
	<!--- entry key --->
	<cfset sEntrykey = ReplaceNoCase(CreateUUId(), "-", "", "ALL")>
	
	<!--- parse dates --->	
	<cfset a_dt_lastmod = LsParseDateTime(a_struct_element.lastmodificationtime)>
	
	<cfif Len(trim(a_struct_element.duedate)) gt 0 AND IsDate(a_struct_element.duedate)>
		<cfset a_dt_due = LsParseDateTime(a_struct_element.duedate)>
	</cfif>
	
	<cfif (Len(trim(a_struct_element.datecompleted)) gt 0) AND
		  (IsDate(a_struct_element.datecompleted)) AND
		  (DateFormat(a_struct_element.datecompleted, "dd.mm.yyyy") neq "31.12.4500")>
		<cfset a_dt_completed = LsParseDateTime(a_struct_element.datecompleted)>
	</cfif>
	
	<cfinvoke component="#application.components.cmp_tasks#" method="CreateTask" returnvariable="a_bol_return">
		<cfinvokeargument name="entrykey" value="#CreateUUID()#">
		<cfinvokeargument name="userkey" value="#session.stSecurityContext.myuserkey#">
		<cfinvokeargument name="title" value="#mid(a_struct_element.subject, 1, 250)#">
		<cfinvokeargument name="notice" value="#a_struct_element.body#">
		<cfinvokeargument name="priority" value="#a_int_priority#">
		<cfinvokeargument name="percentdone" value="#val(a_struct_element.PercentComplete)#">
		<cfinvokeargument name="status" value="#a_int_status#">
		<cfinvokeargument name="actualwork" value="#val(a_struct_element.actualwork)#">
		<cfinvokeargument name="totalwork" value="#val(a_struct_element.actualwork)#">
		<cfinvokeargument name="categories" value="#a_struct_element.categories#">
		<cfinvokeargument name="private" value="#val(a_struct_element.sensitivity)#">
		
		<cfif IsDate(a_dt_due)>
			<cfinvokeargument name="due" value="#createodbcdatetime(a_dt_due)#">
		</cfif>
	</cfinvoke>
	
	
	<cfinvoke component="components/cmp_conversion_utils" method="GetInBoxccStatus" returnvariable="a_int_status">
		<cfinvokeargument name="outlookstatus" value="#val(a_struct_element.status)#">
	</cfinvoke>
	
	<cfinvoke component="components/cmp_conversion_utils" method="GetInBoxccPriority" returnvariable="a_int_priority">
		<cfinvokeargument name="outlookimportance" value="#val(a_struct_element.importance)#">
	</cfinvoke>
		
	<!--- be aware: subject is the body! --->
	<cfquery name="q_insert_notepad" datasource="#request.a_Str_db_office#">
	INSERT INTO notepad
	(title,userid,notice,dt_created,lastmodified,entrykey,PercentDone,status,
	<cfif IsDefined("a_dt_due")>dt_due,</cfif>
	priority,totalwork,actualwork,mileage,categories,dt_done,billinginformation)
	VALUES
	(<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(a_struct_element.subject, 1, 250)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.stSecurityContext.myuserid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_element.body#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_lastmod)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_lastmod)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_struct_element.PercentComplete)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_status#">,
	
	<cfif IsDefined("a_dt_due")>
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_due)#">,
	</cfif>
	
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_priority#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_struct_element.totalwork)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_struct_element.actualwork)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(a_struct_element.mileage, 1, 250)#" maxlength="250">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(a_struct_element.categories, 1, 250)#" maxlength="250">,

	<cfif IsDefined("a_dt_completed")>
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_completed)#">,
	<cfelse>
	NULL,
	</cfif>

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(a_struct_element.billinginformation, 1, 250)#" maxlength="250">
	);
	</cfquery>
	
	<cfquery name="q_select_notepad_id" datasource="#request.a_Str_db_office#">
	SELECT id FROM notepad
	WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">;
	</cfquery>
	
	<cfquery name="q_insert_outlook_id" datasource="#request.a_Str_db_office#">
	INSERT INTO notepad_outlook_id
	(userid,lastupdate,program_id,outlook_id,notepad_id)
	VALUES
	(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.stSecurityContext.myuserid#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_lastmod)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.program_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_element.entryid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_notepad_id.id#">);
	</cfquery>
</cfloop>