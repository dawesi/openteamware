<!--- //

	Component:	Projects
	Function:	GetProjects
	Description:Select the desired projects ...
	

// --->

<cfif arguments.securitycontext.q_select_workgroup_permissions.recordcount>
	
	<!--- select all contact keys, use this one as filter --->
	<cfquery name="local.qProjectContacts">
	SELECT	contactkey
	FROM	projects;
	</cfquery>
	
	<!--- load all contacts shared with this user --->
	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stAddressbook">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
		<cfinvokeargument name="filter" value="#{ entrykeys : ValueList( qProjectContacts.contactkey )}#">
		<cfinvokeargument name="loadoptions" value="#{}#">
	</cfinvoke>
		
	<cfquery name="local.qProjects">
	SELECT	entrykey
	FROM	projects
	WHERE	contactkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList( stAddressbook.q_select_contacts.entrykey )#" list="true" />)
	</cfquery>
	
	<cfset sEntrykeys = ListPrepend(sEntrykeys, Valuelist(local.qProjects.entrykey))>

</cfif>

<cfquery name="q_select_own_projects">
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

<cfquery name="q_select_projects">
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
<!--- 
<cfif arguments.securitycontext.q_select_workgroup_permissions.recordcount GT 0>
<cfloop query="q_select_projects">
	
	<cfif StructKeyExists(stWGInfo, q_select_workgroup_entrykeys.projectkey) is true>	
		<cfset stWGInfo[q_select_workgroup_entrykeys.projectkey] = stWGInfo[q_select_workgroup_entrykeys.projectkey]&","&q_select_workgroup_entrykeys.workgroupkey>
	<cfelse>
		<cfset stWGInfo[q_select_workgroup_entrykeys.projectkey] = q_select_workgroup_entrykeys.workgroupkey>
	</cfif>

</cfloop>
</cfif> --->

<!---<cfset tmp = QueryAddColumn(q_select_contacts, "workgroupkeys", ArrayNew(1))>--->


<cfloop query="q_select_projects">

	<cfif StructKeyExists(stWGInfo,q_select_projects.entrykey)>
		<cfset QuerySetCell(q_select_projects, 'workgroupkeys', stWGInfo[q_select_projects.entrykey], q_select_projects.currentrow)>
	</cfif>

</cfloop>

