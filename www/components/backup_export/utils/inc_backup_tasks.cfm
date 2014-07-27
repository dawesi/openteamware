<cfsetting requesttimeout="20000">

<cfset a_struct_filter = StructNew()>

<cfinvoke component="/components/tasks/cmp_task" method="GetTasks" returnvariable="stReturn_tasks">
  <cfinvokeargument name="securitycontext" value="#variables.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#variables.stUserSettings#">
  <cfinvokeargument name="loadnotice" value="true">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfquery name="variables.q_select_tasks" dbtype="query">
SELECT
	*
FROM
	stReturn_tasks.q_select_tasks
WHERE
	userkey = '<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">'
;
</cfquery>

<cfset variables.q_select_tasks = queryRemoveColumns(theQuery = variables.q_select_tasks, columnsToRemove = 'workgroupkeys,entrykey,userkey,createdbyuserkey')>

<cfset LogMessage('tasks: ' & q_select_tasks.recordcount)>

<cfset variables.a_csv_tasks = QueryToCSV2(variables.q_select_tasks)>

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'tasks'>

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_backup_dir#/tasks.csv" output="#variables.a_csv_tasks#">
