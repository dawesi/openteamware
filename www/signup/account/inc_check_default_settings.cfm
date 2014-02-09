<<!--- //

	Module:		Signup
	Description:check the default settings 
	

// --->
<cfparam name="form.frmoptions" type="string" default="">

	
<!--- we need to get the securitycontext & usersettings in order to create demo data ... --->
<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stSecurityContext">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stUserSettings">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>


<!--- activate CRM? --->

<cfif ListFindNoCase(form.frmoptions, 'activatecrmsales') GT 0>
	<!---  create database, default tables and update crmsalesmappings ... --->
	
	<!--- <cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>
	<cfset sEntrykey_database = CreateUUID()>
	<cfset sEntrykey_additional_data = CreateUUID()>
	<cfset sEntrykey_activities = CreateUUID()>
	
	<cfinvoke
		component = "#a_cmp_database#"   
		method = "CreateDatabase"   
		returnVariable = "a_struct_info"   
		securitycontext="#stSecurityContext#"
		usersettings="#stUserSettings#"
		database_name="crmsales"
		database_description=""
		entrykey="#sEntrykey_database#">
	</cfinvoke>

	<!--- additional data --->
	<cfinvoke
			returnvariable="stReturn"
			component = "#a_cmp_database#"   
			method = "CreateTable"   
			securitycontext="#stSecurityContext#"
			usersettings="#stUserSettings#"
			table_name="additionaldata"
			table_description=""
			entrykey="#sEntrykey_additional_data#"
			database_entrykey="#sEntrykey_database#"
			template_tabletype = "crm_additionaldata">
	</cfinvoke>
	
	<!--- update mapping ... --->
	<cfinvoke component="#application.components.cmp_crmsales#" method="SetCRMSalesBinding" returnvariable="a_bol_return">
		<cfinvokeargument name="companykey" value="#stSecurityContext.mycompanykey#">
		<cfinvokeargument name="databasekey" value="#sEntrykey_database#">
		<cfinvokeargument name="securitycontext" value="#stSecurityContext#">
		<cfinvokeargument name="additionaldata_tablekey" value="#sEntrykey_additional_data#">
		<cfinvokeargument name="USERKEY_DATA" value="">
	</cfinvoke> --->
	
</cfif>	

<!--- edit newsletter subscriptions? --->
<cfif ListFindNoCase(form.frmoptions, 'subscribenewsletter') IS 0>
	<!--- remove newsletter subscription ... --->
	<cfinclude template="queries/q_update_nl_subscription.cfm">
</cfif>

<cfif ListFindNoCase(form.frmoptions, 'subscribetnt') IS 0>
	<!--- remove newsletter subscription ... --->
	<cfinclude template="queries/q_update_tnt_subscription.cfm">
</cfif>

<!--- add free bonus points? --->
<cfif ListFindNoCase(form.frmoptions, 'bonuspoints') GT 0>
	<!--- add bonus points ... --->
	<cfinvoke component="#application.components.cmp_licence#" method="AddAvailablePoints">
		<cfinvokeargument name="companykey" value="#stSecurityContext.mycompanykey#">
		<cfinvokeargument name="points" value="50">
	</cfinvoke>	
</cfif>