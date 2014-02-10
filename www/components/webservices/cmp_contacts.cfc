<!--- //

	Component:	Service
	Function:	Function
	Description:
	
	Header:	

// --->

<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="UpdateContactAndCRM" output="false" returntype="struct">
		<cfargument name="data" type="struct" required="yes" hint="structure holding data">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="options" type="string" default="" required="no" hint="various options">
				
		<cfset var stReturn = StructNew()>		
		<cfset var a_struct_contact_data = StructNew()>
		
		<cfset a_struct_contact_data = arguments.data>		
		
		<!--- first step: ordenary update of contact --->
		<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="a_bol_return_update">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="newvalues" value="#arguments.data#">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">			
			<cfinvokeargument name="updatelastmodified" value="true">
			<cfinvokeargument name="sender" value="ws">
		</cfinvoke>
		
		<cfset stReturn.result = a_bol_return_update>
		
		<!--- 2nd step ... update CRM data? --->
		<cfset a_str_list = StructKeyList(a_struct_contact_data)>
		
		<cfloop list="#a_str_list#" index="a_str_item">
			<cfset a_struct_contact_data['db_' & a_str_item] = a_struct_contact_data[a_str_item]>
		</cfloop>		
		
		<cfif FindNoCase('ignoreownfields', arguments.options) IS 0>
		
			<!--- create the crm items ... --->
			<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
				<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
			</cfinvoke>
			
			<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
				<!--- ok, CRM is enabled ... --->
				<cfinclude template="utils/inc_update_crm_data.cfm">
			</cfif>
		
		</cfif>		
		
		<cfreturn stReturn>
		
	</cffunction>
	
	<cffunction access="public" name="CreateContactAndCRM" output="false" returntype="struct">
		<cfargument name="data" type="struct" required="yes" hint="structure holding data">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="options" type="string" default="" required="no" hint="various options">
		
		<!--- ok, here we go --->
		<cfset var stReturn = StructNew() />
		<cfset var a_struct_contact_data = StructNew() />
		<cfset var sEntrykey = CreateUUID() />
		<cfset var a_str_item = 0 />
		<cfset var a_str_list = 0 />
		<cfset var a_str_own_table_field_names = '' />
		<cfset var ShowCoreData = StructNew() />
		<cfset var ii = 0 />
		<cfset var a_str_internal_field_name = '' />
		
		<cfset a_struct_contact_data = arguments.data />
		
		<cfset a_str_list = StructKeyList(a_struct_contact_data) />
		
		<cfloop list="#a_str_list#" index="a_str_item">
			<cfset a_struct_contact_data['db_' & a_str_item] = a_struct_contact_data[a_str_item] />
		</cfloop>
		
		<!--- create contact ... --->
		<cfinclude template="utils/inc_create_contact.cfm">
		
		<!--- ignore own fields or not? --->
		<cfif FindNoCase('ignoreownfields', arguments.options) IS 0>
		
			<!--- create the crm items ... --->			
			<cfif Len(arguments.securitycontext.crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
				<!--- ok, CRM is enabled ... --->
				<cfinclude template="utils/inc_create_crm_data.cfm">
			</cfif>
		
		</cfif>
	
		<cfset stReturn.entrykey = sEntrykey />
		<cfreturn stReturn />
	</cffunction>

</cfcomponent>