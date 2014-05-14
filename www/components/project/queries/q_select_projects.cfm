<!--- //

	Component:	Projects
	Function:	GetProjects
	Description:Select the desired projects ...
	

// --->

<cfif arguments.securitycontext.q_select_workgroup_permissions.recordcount>
	
	<cfquery name="q_select_workgroup_entrykeys" datasource="#request.a_str_db_crm#">
	SELECT
		projects_shareddata.projectkey,
		projects_shareddata.workgroupkey
	FROM
		projects_shareddata
	WHERE
		(projects_shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)#">))
	;
	</cfquery>
	
	<cfset sEntrykeys = ListPrepend(sEntrykeys, Valuelist(q_select_workgroup_entrykeys.projectkey))>
</cfif>

<cfquery name="q_select_own_projects" datasource="#request.a_str_db_crm#">
SELECT
	projects.entrykey
FROM
	projects
WHERE
	(projects.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)

	<cfif StructCount(arguments.filter) GT 0>
	
		<cfif StructKeyExists(arguments.filter, 'contactkeys')>
		AND
		(projects.contactkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contactkeys#" list="true">))
		</cfif>
		
	</cfif>
;
</cfquery>

<cfset sEntrykeys = ListPrepend(sEntrykeys, Valuelist(q_select_own_projects.entrykey)) />

<cfif Len(sEntrykeys) IS 0>
	<cfset sEntrykeys = 'thisitemdoesnotexist' />
</cfif>

<cfquery name="q_select_projects" datasource="#request.a_str_db_crm#">
SELECT
	sales,
	stage,
	budget,
	categories,
	description,
	dt_begin,
	dt_created,
	dt_due,
	dt_end,
	dt_closing,
	entrykey,
	probability,
	status,
	currency,
	project_type,
	contactkey,
	parentprojectkey,percentdone,priority,projectleaderuserkey,status,title,userkey,
	'' AS workgroupkeys,
	closed,
	dt_closed,
	closedbyuserkey,
	CAST((probability * sales / 100) AS SIGNED) AS sales_probability
FROM
	projects
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys#" list="yes">)
	
	<cfif StructKeyExists(arguments.filter, 'active_only')>
	AND
		closed = 0
	</cfif>
;
</cfquery>

<!--- create workgroup information ... --->
<cfset stWGInfo = StructNew()>

<cfif arguments.securitycontext.q_select_workgroup_permissions.recordcount GT 0>
<cfloop query="q_select_projects">
	
	<cfif StructKeyExists(stWGInfo, q_select_workgroup_entrykeys.projectkey) is true>	
		<cfset stWGInfo[q_select_workgroup_entrykeys.projectkey] = stWGInfo[q_select_workgroup_entrykeys.projectkey]&","&q_select_workgroup_entrykeys.workgroupkey>
	<cfelse>
		<cfset stWGInfo[q_select_workgroup_entrykeys.projectkey] = q_select_workgroup_entrykeys.workgroupkey>
	</cfif>

</cfloop>
</cfif>

<!---<cfset tmp = QueryAddColumn(q_select_contacts, "workgroupkeys", ArrayNew(1))>--->


<cfloop query="q_select_projects">

	<cfif StructKeyExists(stWGInfo,q_select_projects.entrykey)>
		<cfset QuerySetCell(q_select_projects, 'workgroupkeys', stWGInfo[q_select_projects.entrykey], q_select_projects.currentrow)>
	</cfif>

</cfloop>

