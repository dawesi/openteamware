<!--- //

	Module:		Reseller Administration
	Description: 
	

// --->
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">

	<!--- 
	
		load data of reseller
		
		--->
	<cffunction access="public" name="LoadResellerData" output="false" returntype="query">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset SelectResellerDataRequest.entrykey = arguments.entrykey>
		<cfinclude template="queries/q_select_reseller_record.cfm">
		
		<cfreturn q_select_reseller_record>		
	
	</cffunction>
	
	<cffunction access="public" name="TransferCustomer" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="newresellerkey" type="string" required="true">
		
		<cfinclude template="queries/q_update_customer_reseller.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetPartnerStyle" output="false" returntype="string" hint="return the (maybe) custom style of a partner">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of partner">
		
		<cfinclude template="queries/q_select_style_of_partner.cfm">
		
		<cfreturn q_select_style_of_partner.style>		
	</cffunction>
	
	<cffunction access="public" name="AddResellerUser" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="resellerkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="contacttype" type="string" default="" required="false">
		<cfargument name="permissions" type="string" default="" required="false">
		
		<!--- checks ... --->
		<!--- does this user exist? --->
		
		<!--- is this user a part of this company? --->
		
		<!--- is this company the reseller? --->
		
		<!--- does this entry already exist? --->
		
		<!--- ok, insert --->
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="IsResellerUser" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">

		<cfinclude template="queries/q_select_is_reseller_user.cfm">
		
		<cfreturn (q_select_is_reseller_user.count_id GT 0)>
	</cffunction>
	
	<!--- return all company keys of a reseller ... --->
	<cffunction access="public" name="GetAllCompanykeysOfAReseller" output="false" returntype="string">
		<cfargument name="resellerkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_company_keys.cfm">
		
		<cfreturn ValueList(q_select_company_keys.entrykey)>		
	
	</cffunction>
	
	<cffunction access="public" name="GetResellerKeyFromAffiliateCode" output="false" returntype="string">
		<cfargument name="affiliatecode" type="string" required="true">
		
		<cfquery name="q_select_resellerkey_from_affiliatecode" datasource="#request.a_str_db_users#">
		SELECT
			entrykey
		FROM
			reseller
		WHERE
			affiliatecode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.affiliatecode#">
		;
		</cfquery>
		
		<cfreturn q_select_resellerkey_from_affiliatecode.entrykey>
	</cffunction>

</cfcomponent>


