<!--- //

	Module:		Address Book
	Description:Select the assigned workgroups
	

// --->

<cfquery name="q_select_workgroup_items">
SELECT
	addressbookkey
FROM
	shareddata
WHERE
	workgroupkey IN (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#a_struct_filter_element.comparevalue#">)
;
</cfquery>

