
<!--- make a quick dummy query ... load all workgroup items --->

<cfif q_select_workgroup_permissions.recordcount GT 0>
<cfquery name="q_select_workgroup_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	taskkey
FROM
	 tasks_shareddata
WHERE
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(q_select_workgroup_permissions.workgroup_key)#">)	
;
</cfquery>
<cfelse>
	<cfset q_select_workgroup_entrykeys = QueryNew('tmp')>
</cfif>

<!--- load events --->
<cfquery name="q_select_tasks_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	tasks.entrykey,
	tasks.title,
	tasks.userkey,
	CONCAT(tasks.title, DATE_FORMAT(tasks.dt_due, '%d%m%Y%H%i')) AS hashvalue,
	tasks.dt_lastmodified AS dt_lasttimemodified_original,
	tasks_outlook_data.lastupdate AS dt_lasttimemodified,
	tasks_outlook_data.outlook_id
FROM
	tasks
LEFT JOIN
	 tasks_outlook_data ON
	 	(tasks_outlook_data.taskkey = tasks.entrykey) AND ((tasks_outlook_data.program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">))
		AND (tasks_outlook_data.ignoreitem = 0)
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	
	<cfif q_select_workgroup_entrykeys.recordcount GT 0>
	OR
	(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_workgroup_entrykeys.taskkey)#" list="yes">))
	</cfif>
;
</cfquery>

<!---<cflog text="q_select_tasks_meta_data selected" type="Information" log="Application" file="ib_ws">--->