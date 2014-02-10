<!--- //

	Component:	cmp_customer
	Description:customer functions
	

// --->

<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	
	<!--- load the administrators of a company --->
	<cffunction access="public" name="GetCompanyContacts" output="false" returntype="query">
		<cfargument name="companykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_company_contacts.cfm">
		
		<cfreturn q_select_customer_contacts>
	</cffunction>
	
	<cffunction access="public" name="GetPartnerKeyOfCustomer" output="false" returntype="string"
			hint="return entrykey of partner of a customer">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="partnertype" type="string" default="reseller" hint="reseller,distributor, ...." required="no">
		
		<cfinclude template="queries/q_select_partnerkey_of_customer.cfm">
		
		<cfreturn q_select_partnerkey_of_customer.partnerkey>	
	</cffunction>
	
	<cffunction access="public" name="GetCompanyCustomStyle" output="false" returntype="string"
			hint="return the style a company uses">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfset var sReturn = ''>
		<cfset var a_str_partnerkey = ''>
		
		<cfinclude template="queries/q_select_style_company.cfm">
			
		<cfif (Len(q_select_style_company.style) GT 0) AND (Compare(q_select_style_company.style, request.a_str_default_style) NEQ 0)>
			<cfset sReturn = q_select_style_company.style>
		</cfif>
		
		<cfif Len(sReturn) IS 0>
			<!--- get entrykey of partner --->
			<cfset a_str_partnerkey = GetPartnerKeyOfCustomer(companykey = arguments.companykey)>
			
			<cfinclude template="queries/q_select_style_partner.cfm">
			
			<cfif (Len(q_select_style_partner.style) GT 0) AND (Compare(q_select_style_partner.style, request.a_str_default_style) NEQ 0)>
				<cfset sReturn = q_select_style_partner.style>
			</cfif>
		</cfif>		
		
		<cfreturn sReturn>		
	
	</cffunction>

	<!--- select the default language --->	
	<cffunction access="public" name="GetCompanyDefaultLanguage" output="false" returntype="numeric">
		<cfargument name="companykey" type="string" required="yes">

		<cfinclude template="queries/q_select_company_default_language.cfm">

		<cfreturn val(q_select_company_default_language.language)>
	</cffunction>
	
	<!--- add a customer contact ... --->
	<cffunction access="public" name="AddCustomerContact" output="false" returntype="boolean">
		<!--- the key of the company ... --->
		<cfargument name="companykey" type="string" default="" required="true">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" default="" required="true">
		<!--- permission level ... default = 100 = everything --->
		<!---<cfargument name="level" type="numeric" default="100">--->
		<!--- type ... 0 = technical; 1 = business --->
		<cfargument name="type" type="numeric" default="0" required="true">
		<!--- permissions --->
		<cfargument name="permissions" type="string" required="true" default="">
		<!--- level --->
		<cfargument name="level" type="numeric" default="0" required="no">
		
		<!--- insert now into the database ... --->
		<cfset InsertNewCustomerContactRequest.userkey = arguments.userkey>
		<cfset InsertNewCustomerContactRequest.companykey = arguments.companykey>
		<!---<cfset InsertNewCustomerContactRequest.user_level = arguments.level>--->
		<cfset InsertNewCustomerContactRequest.type = arguments.type>
		
		<cfinclude template="queries/q_insert_customer_contact.cfm">		
		
		<cfreturn true>
		
	</cffunction>
	
	<cffunction access="public" name="UpdateCustomerContact" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="permissions" type="string" required="true">
		<cfargument name="type" type="numeric" default="0" required="false">
		<cfargument name="level" type="numeric" default="0" required="no">
		
		<cfinclude template="queries/q_update_customer_contact.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="RemoveCustomerContact" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		
		<cfinclude template="queries/q_delete_customer_contact.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<!--- get the customer name by the entrykey --->
	<cffunction access="public" name="GetCustomerNameByEntrykey" output="false" returntype="string">
		<!--- the entrykey --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset SelectCustomerName.Entrykey = arguments.entrykey>
		
		<cfinclude template="queries/q_select_customer_name_by_entrykey.cfm">
		
		<cfreturn q_select_customer_name_by_entrykey.companyname>
	
	</cffunction>
	
	<!--- return the whole customer record ... --->
	<cffunction access="public" name="GetCustomerData" output="false" returntype="query">
		<!--- the entrykey --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset SelectCustomerRecordRequest.entrykey = arguments.entrykey>
		<cfinclude template="queries/q_select_customer_record.cfm">
		
		<cfreturn q_Select_customer_record>
	
	</cffunction>
	
	<!--- return the contract end ... --->
	<cffunction access="public" name="GetContractEnd" output="false" returntype="struct">
		<!--- entryid of the company ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
	
		<cfset stReturn = StructNew()>
		
		<cfset SelectCompanyContractEndRequest.entrykey = arguments.entrykey>
		<cfinclude template="queries/q_select_customer_contract_end.cfm">
		
		<cfif isDate(q_select_customer_contract_end.dt_contractend) is true>
			<cfset stReturn.dt_contractend = q_select_customer_contract_end.dt_contractend>
		<cfelse>
			<cfset stReturn.dt_contractend = "">
		</cfif>
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<!--- set a new contract end ... --->
	<cffunction access="public" name="SetContractEnd" output="false" returntype="boolean">
		<!--- company key ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		<!--- new contract end ... --->
		<cfargument name="contractend" type="date" required="true">
		
		<cfset SetContractEndRquest.entrykey = arguments.entrykey>
		<cfset SetContractEndRquest.date = arguments.contractend>
		
		<cfinclude template="queries/q_update_contract_end.cfm">
		
		<cfreturn true>	
	</cffunction>
	
	<cffunction access="public" name="CheckCompanyAdminRightAvailable" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="permissionname" type="string" required="yes">
		
		<cfinclude template="queries/q_select_admin_rights.cfm">
		
		<cfif q_select_admin_rights.recordcount IS 0>
			<!--- no admin at all --->
			<cfreturn false>
		</cfif>
		
		<cfif q_select_admin_rights.user_level IS 100>
			<!--- supermode ... return true --->
			<cfreturn true>
		<cfelse>
			
			<!--- check permission list ... --->
			<cfset a_bol_right_enabled = ListFindNoCase(q_select_admin_rights.permissions, arguments.permissionname)>
			<cfreturn (a_bol_right_enabled GT 0)>
		</cfif>
		
	</cffunction>
	
	<!--- check if an user is a company administrator --->
	<cffunction access="public" name="IsUserCompanyAdmin" output="false" returntype="boolean">
		<!--- the userkey ... --->
		<cfargument name="userkey" type="string" required="true">
		<!--- optional: companykey --->
		<cfargument name="companykey" type="string" required="false" default="">
		
		<cfinclude template="queries/q_select_user_is_admin.cfm">
		
		<cfreturn (q_select_user_is_admin.recordcount GT 0)>
	</cffunction>
	
	<cffunction access="public" name="IsUserCompanyAdminAndInRoles" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="roles" type="string" required="true">
		
		<cfreturn false>
	</cffunction>
	
	<cffunction access="public" name="GetAllCompanyUsers" output="false" returntype="query"
			hint="return basic data of all users of a company">
		<cfargument name="companykey" type="string" required="true"
			hint="entrykey of company">
		<cfargument name="workgroup_memberships" type="string" required="false" default=""
			hint="select only people who are members in one of the given workgroups, not implemented yet">
			
		<cfset q_select_company_users = 0 />
		
		<cfinclude template="queries/q_select_company_users.cfm">
		
		<cfreturn q_select_company_users />
	</cffunction>
	
	<!--- // create a new customer // --->
	<cffunction access="public" name="CreateCustomer" output="false" returntype="boolean">
		<!--- companykey --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- service or projectpartner --->
		<cfargument name="resellerkey" type="string" required="true">
		<!--- distributorkey --->
		<cfargument name="distributorkey" type="string" default="" required="false">
		<cfargument name="assignedtoreseller" type="numeric" default="1" required="false">
		<!--- 0 = customer; 1 = trial --->
		<cfargument name="status" type="numeric" required="true">
		<cfargument name="companyname" type="string" required="true">
		<!--- 0 = private; 1 = organisation --->
		<cfargument name="customertype" type="numeric" default="1" required="false">
		<cfargument name="shortname" type="string" required="false" default="">
		<cfargument name="contactperson" type="string" default="" required="false">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="domains" type="string" required="false" default="#request.appsettings.a_str_default_domain#">
		<cfargument name="uidnumber" type="string" default="" required="false">
		<cfargument name="telephone" type="string" default="" required="false">
		<cfargument name="fax" type="string" default="" required="false">		
		<cfargument name="street" type="string" default="" required="false">		
		<cfargument name="city" type="string" default="" required="false">		
		<cfargument name="zipcode" type="string" default="" required="false">		
		<cfargument name="countryisocode" type="string" default="" required="false">
		<cfargument name="email" type="string" default="" required="false">
		<cfargument name="dt_trialphase_end" type="date" required="false">
		<cfargument name="source" type="string" default="" required="false">
		<cfargument name="createdbyuserkey" type="string" default="" required="false">
		<cfargument name="generaltermsandconditions_accepted" type="numeric" default="1" required="false">
		<cfargument name="httpreferer" type="string" default="" required="no">
		<cfargument name="industry" type="string" default="" required="no">
		<cfargument name="createdefaultteam" type="boolean" default="false" required="no">
		<cfargument name="language" type="numeric" default="0" required="no">
		<cfargument name="billingcontact" type="string" required="no" default="">
		<cfargument name="settlement_type" type="numeric" default="0" required="no" hint="settlement type (verrechnung)">
		
		<cfset var a_int_autoorder_on_trial_end = 1>
		<cfset var a_bol_autoorder_on_trial_end = true>
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="create customer" type="html">
		<cfdump var="#arguments#">
		</cfmail>--->
		
		<cfif arguments.status IS 1>
			<!--- trial phase, send end date ... --->
			
			<cfif StructKeyExists(arguments, 'dt_trialphase_end') AND IsDate(arguments.dt_trialphase_end)>
				<cfset a_dt_trialphase_end = ParseDateTime(arguments.dt_trialphase_end)>
			<cfelse>
				<cfset a_dt_trialphase_end = DateAdd('d', 30, Now())>
			</cfif>
			
			<!--- max 31 days ... --->
			<cfif DateDiff('d', now(),a_dt_trialphase_end) GT 31>
				<cfset a_dt_trialphase_end = DateAdd('d', 31, Now())>
			</cfif> 
			
		</cfif>
		
		<cfif Len(arguments.resellerkey) IS 0>
			<cfset arguments.resellerkey = '5872C37B-DC97-6EA3-E84EC482D29FC169'>
		</cfif>
		
		<!--- get reseller properties (concerning settlement type) --->
		<cfset a_cmp_customize = application.components.cmp_customize />
		<cfset a_cmp_reseller = CreateObject('component', request.a_str_component_reseller)>
		
		<cfset a_str_style_reseller = a_cmp_reseller.GetPartnerStyle(entrykey = arguments.resellerkey)>
		
		<cftry>
		<cfset a_bol_autoorder_on_trial_end = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_style_reseller, entryname = 'administration').autoorderontrialend>
				<cfcatch type="any">
					<cfset a_bol_autoorder_on_trial_end = true>
				</cfcatch>
		</cftry>
		
		<!--- set autoorder trial ... --->
		<cfif a_bol_autoorder_on_trial_end>
			<cfset a_int_autoorder_on_trial_end = 1>
		<cfelse>
			<cfset a_int_autoorder_on_trial_end = 0>
		</cfif>
		
		<cfinclude template="queries/q_insert_customer.cfm">
		
		<cfif arguments.createdefaultteam>
			<!--- create a default TEAM --->
			<cfinvoke component="#request.a_str_component_workgroups#" method="CreateWorkgroup" returnvariable="stReturn">
				<cfinvokeargument name="groupname" value="Team">
				<cfinvokeargument name="shortname" value="Team">
				<cfinvokeargument name="description" value="">
				<cfinvokeargument name="createdbyuserkey" value="system">
				<cfinvokeargument name="companykey" value="#arguments.entrykey#">
				<cfinvokeargument name="parentgroupkey" value="">
				<cfinvokeargument name="createstandardroles" value="true">
				<cfinvokeargument name="colour" value="white">
			</cfinvoke>
		</cfif>
	
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="CreateCompanyDataSheet" output="false" returntype="struct">
		<cfargument name="companykey" type="string" required="true">
		
		<cfset stReturn = StructNew()>
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="GetCompanyAdminRights" output="false" returntype="string">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="companykey" type="string" required="yes">
		
		<!--- load status ... --->
		<cfinclude template="queries/q_select_admin_rights.cfm">
		
		<!--- load rights --->
		<cfif q_select_admin_rights.recordcount IS 0>
			<cfreturn ''>
		</cfif>
		
		<cfif q_select_admin_rights.user_level IS 100>
			<!--- return all admin actions ... --->
			<cfreturn request.a_str_admin_actions>
		<cfelse>
			<!--- just return the set permissions --->
			<cfreturn q_select_admin_rights.permissions>
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="DeleteCustomer" returntype="boolean" output="false">
		<cfargument name="companykey" type="string" required="true">
		
		<!--- load all accounts ... --->
		
		
		
		<cfreturn true>
	</cffunction>
	
</cfcomponent>

