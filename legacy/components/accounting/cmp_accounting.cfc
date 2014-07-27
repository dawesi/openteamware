<cfcomponent output=false>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- get settlement type of company ... --->
	<cffunction access="public" name="GetSettlementTypeOfCompany" returntype="numeric" output="false">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_settlement_type_of_company.cfm">
		
		<cfreturn val(q_select_settlement_type_of_company.settlement_type)>
	</cffunction>
		
</cfcomponent>