<!---
	the query holding all data
	--->
<cfparam name="attributes.q_select_security" type="query">

<!---
	entrykey of group ...
	--->
<cfparam name="attributes.entrykey" type="string" default="">

<!--- inherited or real membership? --->
<cfparam name="attributes.inherited_membership" type="numeric" default="0">

<!--- entrykey of user ... --->
<cfparam name="attributes.userkey" type="string" default="">

<!--- entrykey of parent group ... --->
<cfparam name="attributes.parent_entrykey" type="string" default="">

<!--- roles in the parent group (inherited by the sub group) --->
<cfparam name="attributes.parent_roles" type="string" default="">

<!--- level ... --->
<cfparam name="attributes.level" type="numeric" default="0">

<!--- load workgroup properties ... --->
<cfquery name="q_select_workgroup_properties">
SELECT
	groupname,shortname,colour
FROM
	workgroups
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrykey#">)
;
</cfquery>

<cfif q_select_workgroup_properties.recordcount is 0>
	<!--- invalid old group ... --->
	<cfexit method="exittemplate">
</cfif>

<!--- load roles ... --->
<cfquery name="q_select_roles">
SELECT
	roles
FROM
	workgroup_members
WHERE
	(workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrykey#">)
	AND
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.userkey#">)
;
</cfquery>

<cfif q_select_roles.recordcount is 0>
	<!--- user role of parent workgroup ... --->
	<cfset a_str_roles = attributes.parent_roles>
<cfelse>
	<cfset a_str_roles = q_select_roles.roles>
</cfif>

<!--- load all avaliable actions ... --->
<cfloop list="a_str_roles" delimiters="," index="a_str_role">
	<!--- load properties of all roles ... --->
	<cfquery name="q_select_standard_permissions">
	SELECT
		standardallowedactions,standardtype
	FROM
		roles
	WHERE
		(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_roles#">)
	;
	</cfquery>
	
	<cfset a_int_standard_types = q_select_standard_permissions.standardtype>
	
	<cfif val(q_select_standard_permissions.standardtype) gt 0>
		<!--- we've got a standard type ... --->
		<cfset a_str_permissions = Application.components.cmp_security.GetAllowedStandardActionsForStandardType(q_select_standard_permissions.standardtype)>
	<cfelse>
		<!--- load roles from upper group ... --->
		<cfset a_str_permissions = q_select_standard_permissions.standardallowedactions>
	</cfif>
	
</cfloop>

<cfscript>
	// add the group now ...
	QueryAddRow(attributes.q_select_security, 1);
	ii = attributes.q_select_security.recordcount;
	QuerySetCell(attributes.q_select_security, "workgroup_name", q_select_workgroup_properties.groupname, ii);
	QuerySetCell(attributes.q_select_security, "inherited_membership",attributes.inherited_membership, ii);
	QuerySetCell(attributes.q_select_security, "workgroup_key", attributes.entrykey, ii);
	QuerySetCell(attributes.q_select_security, "workgroup_name", q_select_workgroup_properties.groupname, ii);

	if (len(q_select_workgroup_properties.shortname) GT 0)
		{
		QuerySetCell(attributes.q_select_security, "workgroup_shortname", q_select_workgroup_properties.shortname, ii);
		}
		else
			{
			QuerySetCell(attributes.q_select_security, "workgroup_shortname", q_select_workgroup_properties.groupname, ii);
			}

	QuerySetCell(attributes.q_select_security, "parent_workgroup_key", attributes.parent_entrykey, ii);
	QuerySetCell(attributes.q_select_security, "roles", a_str_roles, ii);
	QuerySetCell(attributes.q_select_security, "permissions", a_str_permissions, ii);
	QuerySetCell(attributes.q_select_security, "workgrouplevel", attributes.level, ii);
	QuerySetCell(attributes.q_select_security, "standardtypes", a_int_standard_types, ii);
	QuerySetCell(attributes.q_select_security, "colour", q_select_workgroup_properties.colour, ii);
</cfscript>

<!--- load subgroups and execute this routine ... --->
<cfquery name="q_select_subgroups">
SELECT
	entrykey
FROM
	workgroups
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrykey#">
;
</cfquery>

<cfloop query="q_select_subgroups">

	<cfset a_int_new_level = val(attributes.level) + 1>

	<cfmodule template="mod_add_group.cfm"
		entrykey = #q_select_subgroups.entrykey#
		q_select_security = #attributes.q_select_security#
		inherited_membership = 1
		parent_entrykey = #attributes.entrykey#
		parent_roles = #a_str_roles#
		level = #a_int_new_level#
		userkey = #attributes.userkey#>
	
</cfloop>