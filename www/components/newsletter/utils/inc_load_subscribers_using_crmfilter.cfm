<!--- //

	Module:		GetSubscribers
	Description: 
	

// --->

<cfif Len(q_select_profile.crm_filter_key) GT 0>

	<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
		<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
		<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
		<cfinvokeargument name="viewkey" value="#q_select_profile.crm_filter_key#">
	</cfinvoke>

<cfelse>

	<!--- create an empty structure if no filter should be given ... --->
	<cfset a_struct_crm_filter = StructNew() />

</cfif>

<cfset a_struct_loadoptions = StructNew() />

<!--- total number is defined in arguments scope ... --->
<cfset a_struct_loadoptions.maxrows = arguments.maxnumber />
<cfset a_struct_loadoptions.ignore_unsaved_crm_filters = true />

<!--- ignore archive items --->
<cfset a_struct_filter.archiveentries = 0>

<!--- load contacts ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="a_struct_load_contacts">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loaddistinctcategories" value="false">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_subscribers = a_struct_load_contacts.q_select_contacts />

<!--- in case of a testrun, exit now ... --->
<cfif arguments.testrun>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_subscribers" dbtype="query">
SELECT
	*
FROM
	q_select_subscribers
WHERE
	(email_prim IS NOT NULL)
	AND NOT
	(email_prim = '')
	AND
	(archiveentry = 0)

	<!--- if ignore items exist, remove them ... --->
	<cfif q_select_ignored.recordcount GT 0>
	AND
	(entrykey NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_ignored.contactkey)#" list="yes">))
	</cfif>
;
</cfquery>


