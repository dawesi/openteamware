<!--- //

	Component:	AppInit
	Function:	...
	Description:Load app settings
	

// --->

<cfset q_select_settings = CreateObject('component', request.a_str_component_tools).ReturnStoredXMLDatabaseAsQuery('myapp.applications')>

<cfquery name="q_select_settings" dbtype="query">
SELECT
	entrykey,
	id,
	description,
	about_company,
	defaultdomain, dt_created, defaultlanguage,
	tempdir,defaultencoding,
	allowforeigndomainlogins,default_stylesheet
FROM
	q_select_settings
WHERE
	appname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_app_name#">
;

</cfquery>

