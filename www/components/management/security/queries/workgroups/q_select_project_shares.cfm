
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
	
<!--- <cfquery name="local.qProjects">
SELECT	entrykey
FROM	projects
WHERE	contactkey IN 
</cfquery> --->

<cfquery name="q_select_shares">
SELECT
	shareddata.workgroupkey,
	'' AS workgroupname
FROM
	shareddata
WHERE
	addressbookkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList( stAddressbook.q_select_contacts.entrykey )#" list="true" />)
AND
	shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(securitycontext.q_select_workgroup_permissions.workgroup_key)#" list="yes">)
;
</cfquery>
