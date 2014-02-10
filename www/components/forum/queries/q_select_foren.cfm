<!--- 

	select now all workgorupkeys
	
	--->
	
<cfquery name="q_select_foren_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	forumkey
FROM
	foren_shareddata
WHERE
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)#" list="yes">)
;
</cfquery>

<cfset a_str_workgroup_keys = ValueList(q_select_foren_entrykeys.forumkey)>

<cfif Len(a_str_workgroup_keys) IS 0>
	<cfset a_str_workgroup_keys = 'dummy,dummy2'>
</cfif>


<cfquery name="q_select_foren" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,forumname,description,dt_created,createdbyuserkey,dt_lastposting,announcementforum
FROM
	foren
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_workgroup_keys#" list="yes">)
ORDER BY
	forumname
;
</cfquery>

<!--- nun noch die workgroups hinzufuegen so wie bei den tasks ... --->

<cfset tmp = QueryAddColumn(q_select_foren, 'workgroupkeys', ArrayNew(1))>