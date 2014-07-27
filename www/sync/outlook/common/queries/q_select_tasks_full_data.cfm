<!--- //

	select the full data
		
	scopes: form, session
	
	// --->
	
<cfset a_str_program_id = form.program_id>

<!--- select tasks full data ... --->
<cfinvoke component="/components/tasks/cmp_task" method="GetTasks" returnvariable="stReturn">
  <cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#session.stUserSettings#">
</cfinvoke>

<cfset q_select_tasks = stReturn.q_select_tasks>

<cfquery name="q_select_tasks" dbtype="query">
SELECT
	*
FROM
	q_select_tasks
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.ids#">)
;
</cfquery>

<!--- load now outlook meta data ... --->
<cfquery name="q_select_ol_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	outlook_id,taskkey
FROM
	tasks_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_program_id#">
;
</cfquery>

<!--- ok, now map outlook_id and the real table ... --->

<cfset a_struct_ol_data = StructNew()>
<cfloop query="q_select_ol_meta_data">
	<cfset a_struct_ol_data[q_select_ol_meta_data.taskkey] = q_select_ol_meta_data.outlook_id>
</cfloop>

<!--- add the column ... --->
<cfset QueryAddColumn(q_select_tasks, 'outlook_id', ArrayNew(1))>

<cfloop query="q_select_tasks">
	<cfif StructKeyExists(a_struct_ol_data, q_select_tasks.entrykey)>
		<cfset QuerySetCell(q_select_tasks, 'outlook_id', a_struct_ol_data[q_select_tasks.entrykey], q_select_tasks.currentrow)>
	</cfif>
</cfloop>

<cfset q_select_tasks_full_data = q_select_tasks>