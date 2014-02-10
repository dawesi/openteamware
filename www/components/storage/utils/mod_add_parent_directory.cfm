
<cfparam name="attributes.query" type="query">
<cfparam name="attributes.directorykey" type="string" default="">

<cfif attributes.directorykey IS ''>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_directory" datasource="#request.a_str_db_tools#">
SELECT
	parentdirectorykey,directoryname,description
FROM
	directories
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.directorykey#">
;
</cfquery>

<cfset tmp = QueryAddRow(attributes.query, 1)>

<cfset tmp = QuerySetCell(attributes.query, 'directorykey', attributes.directorykey, attributes.query.recordcount)>
<cfset tmp = QuerySetCell(attributes.query, 'directoryname', q_select_directory.directoryname, attributes.query.recordcount)>
<cfset tmp = QuerySetCell(attributes.query, 'description', q_select_directory.description, attributes.query.recordcount)>
<cfset tmp = QuerySetCell(attributes.query, 'parentdirectorykey', q_select_directory.parentdirectorykey, attributes.query.recordcount)>


<cfif attributes.query.recordcount GT 10>
	<cfexit method="exittemplate">
</cfif>

<cfmodule template="mod_add_parent_directory.cfm" directorykey=#q_select_directory.parentdirectorykey# query=#attributes.query#>