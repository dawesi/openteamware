<!--- //



	load addressbook full data

	

	// --->

	

<!--- //



	select the most imporant data

	

	- outlook_id

	- last update date

	- id of entry

	

	scopes: url, session, GetOutlookMetaData

	

	// --->
	
<cfset ab = GetTickCount()>
<cflog text="get full data contacts 0" type="Information" log="Application" file="ib_load_data_contacts">

<cfset a_str_program_id = form.program_id>

<!--- load ALL contacts --->
<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_loadoptions.entrykeys = form.ids>
<cfset a_struct_loadoptions.maxrows = 0>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = form.ids>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts>

<cflog text="get full data contacts done #(ab - GetTickCount())#" type="Information" log="Application" file="ib_load_data_contacts">

<cfquery name="q_select_contacts" dbtype="query">
SELECT
	*
FROM
	q_select_contacts
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.ids#">)
;
</cfquery>

<!--- load now outlook meta data ... --->
<cfquery name="q_select_ol_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	outlook_id,addressbookkey
FROM
	addressbook_outlook_data
WHERE
	(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_program_id#">)
	AND
	(addressbookkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ids#" list="yes">))
;
</cfquery>

<cflog text="meta data loaded #(ab - GetTickCount())#" type="Information" log="Application" file="ib_load_data_contacts">

<!--- ok, now map outlook_id and the real table ... --->

<cfset a_struct_ol_data = StructNew()>
<cfloop query="q_select_ol_meta_data">
	<cfset a_struct_ol_data[q_select_ol_meta_data.addressbookkey] = q_select_ol_meta_data.outlook_id>
</cfloop>

<cflog text="data mapped loop q_select_ol_meta_data #(ab - GetTickCount())#" type="Information" log="Application" file="ib_load_data_contacts">

<!--- add the column ... --->
<cfset tmp = QueryAddColumn(q_select_contacts, 'outlook_id', ArrayNew(1))>

<cfloop query="q_select_contacts">
	<cfif StructKeyExists(a_struct_ol_data, q_select_contacts.entrykey)>
		<cfset QuerySetCell(q_select_contacts, 'outlook_id', a_struct_ol_data[q_select_contacts.entrykey], q_select_contacts.currentrow)>
	<cfelse>
		<cfset QuerySetCell(q_select_contacts, 'outlook_id', '', q_select_contacts.currentrow)>
	</cfif>
</cfloop>
	
<cflog text="second check done ... added outlook_id and set data #(ab - GetTickCount())#" type="Information" log="Application" file="ib_load_data_contacts">
	
<cfset q_select_contacts_full_data = q_select_contacts>