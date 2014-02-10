<!--- //

	Module:		Appsettings
	Action:		LoadAppSettings
	Description:Check if this app exists
	
// --->
	
<cfset q_select_settings = CreateObject('component', request.a_str_component_tools).ReturnStoredXMLDatabaseAsQuery('myapp.applications') />

<cftry>
<cfquery name="q_select_app_exists" dbtype="query">
SELECT
	id
FROM
	q_select_settings
WHERE
	appname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_app_name#">
;
</cfquery>
<cfcatch type="any">
	<cfset q_select_app_exists = QueryNew('id') />
</cfcatch>
</cftry>

