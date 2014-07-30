<!--- select the tasks ...

	this is not a single query but a lot of work ;-)
	
	--->
	
<!--- select now entrykey of workgroup items ... --->
<cfif q_select_workgroups.recordcount GT 0>
	<cfset a_bol_workgroups_avaliable = true>
	<cfquery name="q_select_workgroup_entrykeys">
	SELECT
		tasks_shareddata.taskkey,
		tasks_shareddata.workgroupkey,
		tasks.id
	FROM
		tasks_shareddata
	LEFT JOIN
		tasks
			ON (tasks.entrykey = tasks_shareddata.taskkey)
	WHERE
		tasks_shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(q_select_workgroups.workgroup_key)#">)
		
		<cfif StructKeyExists(arguments.filter, 'statusexclude')>
			AND NOT
			(tasks.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.filter.statusexclude)#">)	
		</cfif>
		
		<cfif StructKeyExists(arguments.filter, 'excludenoduedateitems') AND arguments.filter.excludenoduedateitems>
			AND
			(tasks.dt_due IS NOT NULL)
		</cfif>
		
		<cfif StructKeyExists(arguments.filter, 'entrykeys') AND Len(arguments.filter.entrykeys) GT 0>
			AND
			(tasks_shareddata.taskkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykeys#" list="yes">))
		</cfif>
				
	;
	</cfquery>
<cfelse>
	<cfset a_bol_workgroups_avaliable = false>
</cfif>

<!--- select assigned items ... --->
<cfquery name="q_select_assigned_items">
SELECT
	<!---tasks_assigned_users.taskkey,--->
	tasks.id
FROM
	tasks_assigned_users
LEFT JOIN
	tasks
		ON (tasks.entrykey = tasks_assigned_users.taskkey)
WHERE
	tasks_assigned_users.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	
	<cfif StructKeyExists(arguments.filter, 'statusexclude')>
		AND NOT
		(tasks.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.filter.statusexclude)#">)	
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'excludenoduedateitems') AND arguments.filter.excludenoduedateitems>
		AND
		(tasks.dt_due IS NOT NULL)
	</cfif>	
	
	<cfif StructKeyExists(arguments.filter, 'entrykeys') AND Len(arguments.filter.entrykeys) GT 0>
		AND
		(tasks_assigned_users.taskkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykeys#" list="yes">))
	</cfif>		
;
</cfquery>


<!--- select now PERSONAL items ... --->
<cfquery name="q_select_own_entrykeys">
SELECT
	<!---entrykey,--->
	id
FROM
	tasks
WHERE
	(userkey = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.securitycontext.myuserkey#">)
	
	<cfif StructKeyExists(arguments.filter, 'statusexclude')>
		AND NOT
		(status = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.filter.statusexclude)#">)	
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'excludenoduedateitems') AND arguments.filter.excludenoduedateitems>
		AND
		(dt_due IS NOT NULL)
	</cfif>	
	
	<cfif StructKeyExists(arguments.filter, 'entrykeys') AND Len(arguments.filter.entrykeys) GT 0>
		AND
		(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykeys#" list="yes">))
	</cfif>		
	
;
</cfquery>


<!--- glue these two strings together ... --->
<cfset sEntrykeys_list = ''>
<cfset sIDList = 0>

<cfif a_bol_workgroups_avaliable>
	<!---<cfset sEntrykeys_list = valuelist(q_select_workgroup_entrykeys.taskkey)>--->
	
	<cfset sIDList = ListAppend(sIDList, valuelist(q_select_workgroup_entrykeys.id))>
</cfif>

<cfif q_select_own_entrykeys.recordcount gt 0>
	<!---<cfset sEntrykeys_list = ListPrepend(sEntrykeys_list, valuelist(q_select_own_entrykeys.entrykey))>--->
	
	<cfset sIDList = ListAppend(sIDList, valuelist(q_select_own_entrykeys.id))>
</cfif>

<cfif q_select_assigned_items.recordcount GT 0>
	<!---<cfset sEntrykeys_list = ListPrepend(sEntrykeys_list, valuelist(q_select_assigned_items.taskkey))>--->
	
	<cfset sIDList = ListAppend(sIDList, valuelist(q_select_assigned_items.id))>
</cfif>

<!--- check now if there are special entries which this user is not allowed to read ...
	remove them from the entrykey list ... --->

	
<!--- removed / done --->
<cfif Len(sEntrykeys_list) LTE 10>
	<cfset sEntrykeys_list = 'thisitemdoesnotexist'>
</cfif>


<!--- now we've got a list of entrykeys to load!! --->
<cfquery name="q_select_tasks">
SELECT
	title,
	
	<cfif arguments.loadnotice>
	notice,
	</cfif>
	
	categories,
	userkey,
	entrykey,
	dt_created,
	assignedtouserkeys,
	dt_due,
	status,
	priority,
	dt_lastmodified,
	projectkey,
	percentdone,
	mileage,
	billinginformation,
	totalwork,
	actualwork,
	'' AS workgroupkeys,
	0 AS int_dt_due
FROM
	tasks
WHERE
	<!---
	(entrykey IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#sEntrykeys_list#" list="Yes">))
	--->
	(id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#sIDList#" list="yes">))

<cfif len(arguments.search) gt 0>
	AND
	(
		(UPPER(title) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">)
		OR
		(UPPER(notice) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">)
		OR
		(UPPER(categories) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">)
	)
</cfif>

<cfif StructKeyExists(arguments.filter, 'statusexclude')>
	AND NOT
	(status = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.filter.statusexclude)#">)	
</cfif>

<cfif StructKeyExists(arguments.filter, 'assignedtoorownerkey')>
	AND 
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.assignedtoorownerkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.assignedtoorownerkey#%">)
	)
</cfif>

<cfif StructKeyExists(arguments.filter, 'excludenoduedateitems') AND arguments.filter.excludenoduedateitems>
	AND
	(dt_due IS NOT NULL)
</cfif>
	
<!--- do further filtering? --->
<cfif ListFindNoCase('dt_lastmodified,title,categories,dt_done,dt_due', arguments.orderby) gt 0>
ORDER BY
	#arguments.orderby# <cfif arguments.orderbydesc is true>DESC</cfif>
</cfif>

;
</cfquery>

<!--- create workgroup information ... --->
<cfset stWGInfo = StructNew()>

<!--- return information about the categories ... --->
<cfset a_struct_categories = StructNew()>

<cfif a_bol_workgroups_avaliable>
	<cfloop query="q_select_workgroup_entrykeys">
		
		<cfif StructKeyExists(stWGInfo, q_select_workgroup_entrykeys.taskkey) is true>	
			<cfset stWGInfo[q_select_workgroup_entrykeys.taskkey] = stWGInfo[q_select_workgroup_entrykeys.taskkey]&","&q_select_workgroup_entrykeys.workgroupkey>
		<cfelse>
			<cfset stWGInfo[q_select_workgroup_entrykeys.taskkey] = q_select_workgroup_entrykeys.workgroupkey>
		</cfif>
	
	</cfloop>
</cfif>

<cfloop query="q_select_tasks">

	<cfif StructKeyExists(stWGInfo,q_select_tasks.entrykey)>
		<cfset QuerySetCell(q_select_tasks, 'workgroupkeys', stWGInfo[q_select_tasks.entrykey], q_select_tasks.currentrow)>
	</cfif>
		
	<cfif arguments.createcategorylist>
		<cfloop list="#q_select_tasks.categories#" delimiters="," index="a_str_category">
			<cfif StructKeyExists(a_struct_categories, a_str_category) is false>
				<cfset a_struct_categories[a_str_category] = 1>
			<cfelse>
				<cfset a_struct_categories[a_str_category] = a_struct_categories[a_str_category] + 1>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif IsDate(q_select_tasks.dt_due)>
		<cfset QuerySetCell(q_select_tasks, 'int_dt_due', DateFormat(q_select_tasks.dt_due, 'yyyymmdd')&TimeFormat(q_select_tasks.dt_due,'HHmm'), q_select_tasks.currentrow)>
	</cfif>

</cfloop>