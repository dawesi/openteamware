<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="CreateContactAndCRM" output="false" returntype="struct">
		<cfargument name="data" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<!--- ok, here we go --->
		<cfset var stReturn = StructNew()>
		<cfset var a_struct_data = StructNew()>
		<cfset var sEntrykey = CreateUUID()>
		
		<cfinclude template="utils/inc_parse_xml.cfm">
		
		<cfset stReturn.entrykey = sEntrykey>
		
		<!--- create contact ... --->
		<cfinclude template="utils/inc_create_contact.cfm">
		
		
		<!--- create the crm items ... --->
		<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
			<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
		</cfinvoke>
		
		<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
			<!--- ok, CRM is enabled ... --->
			<cfinclude template="utils/inc_create_crm_data.cfm">
			
		</cfif>
	
		<cfreturn stReturn>
	</cffunction>

</cfcomponent>