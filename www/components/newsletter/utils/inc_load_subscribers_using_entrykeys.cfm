<!--- //

	load using entrykeys ...
	
	// --->
	
<cfquery name="q_select_subscribers_entrykeys">
SELECT
	contactkey,dt_created
FROM
	newsletter_subscribers
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
;
</cfquery>

<cfset a_struct_subscribers_entrykeys = StructNew()>

<cfloop query="q_select_subscribers_entrykeys">
	<cfset a_struct_subscribers_entrykeys[q_select_subscribers_entrykeys.contactkey] = q_select_subscribers_entrykeys.dt_created>
</cfloop>

<!--- create filter structure --->
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = valueList(q_select_subscribers_entrykeys.contactkey)>

<cfset a_struct_loadoptions = StructNew()>

<!--- max number is defined in arguments space --->
<cfset a_struct_loadoptions.maxrows = arguments.maxnumber>
<cfset a_struct_loadoptions.ignore_unsaved_crm_filters = true>

<!--- load data now ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="a_struct_load_contacts">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loaddistinctcategories" value="false">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_subscribers = a_struct_load_contacts.q_select_contacts>

<cfif q_select_ignored.recordcount GT 0>
	<cfquery name="q_select_subscribers" dbtype="query">
	SELECT
		*
	FROM
		q_select_subscribers
	WHERE
		entrykey NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_ignored.contactkey)#" list="yes">)
	;
	</cfquery>
</cfif>

<!--- add a new column where the date when the user has been added is saved ... --->
<cfset tmp = QueryAddColumn(q_select_subscribers, 'dt_created_nl_subscription', 'Date', ArrayNew(1))>

<cfloop query="q_select_subscribers">
	<cfif StructKeyExists(a_struct_subscribers_entrykeys, q_select_subscribers.entrykey)>
		<cfset tmp = QuerySetCell(q_select_subscribers, 'dt_created_nl_subscription', a_struct_subscribers_entrykeys[q_select_subscribers.entrykey], q_select_subscribers.currentrow)>
	</cfif>
</cfloop>

<cfquery name="q_select_subscribers" dbtype="query">
SELECT
	*
FROM
	q_select_subscribers
ORDER BY
	dt_created_nl_subscription DESC
;
</cfquery>
