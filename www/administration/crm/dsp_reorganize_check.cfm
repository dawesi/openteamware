<!--- //

	reorganize
	
	// --->
	

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfset q_select_databases = CreateObject('component', request.a_str_component_database).GetDatabasesCreatedByAdmins(companykey = url.companykey)>

<cfquery name="q_select_crm_db_name" dbtype="query">
SELECT
	name,userid AS userkey
FROM
	q_select_databases
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_crmsales_bindings.databasekey#">
;
</cfquery>

<cfif q_select_crm_db_name.recordcount IS 0>
	<h1>Invalid. Please contact feedback@openTeamWare.com</h1>
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_securitycontext">
	<cfinvokeargument name="userkey" value="#q_select_crm_db_name.userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stReturn_usersettings">
	<cfinvokeargument name="userkey" value="#q_select_crm_db_name.userkey#">
</cfinvoke>

<cfinvoke component="#request.a_str_component_database#" method="ListTables" returnvariable="q_select_tables">
	<cfinvokeargument name="securitycontext" value="#stReturn_securitycontext#">
	<cfinvokeargument name="usersettings" value="#stReturn_usersettings#">
	<cfinvokeargument name="database_entrykey" value="#a_struct_crmsales_bindings.databasekey#">
</cfinvoke>

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="../queries/q_select_company_users.cfm">

<cfquery name="q_select_all_contacts_of_company">
SELECT
	id
FROM
	addressbook
WHERE
	userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_company_users.entrykey)#" list="yes">)
;
</cfquery>

<br><br>
Total number of contacts: <cfoutput>#q_select_all_contacts_of_company.recordcount#</cfoutput>

<!--- now check missing contacts ... --->