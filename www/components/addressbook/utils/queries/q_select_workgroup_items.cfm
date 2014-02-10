<!--- //

	Module:		Address Book
	Description:Select the assigned workgroups
	

// --->

<cfquery name="q_select_workgroup_items" datasource="#request.a_str_db_tools#">
SELECT
	addressbookkey
FROM
	shareddata
WHERE
	workgroupkey IN (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#a_struct_filter_element.comparevalue#">)
;
</cfquery>

