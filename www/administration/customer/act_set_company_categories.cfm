
<cfdump var="#form#">

<cfquery name="q_update_company_default_categories" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	company_default_categories = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcategories#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
;
</cfquery>

<!--- load company users ... --->

<cfset SelectCompanyUsersRequest.companykey = form.frmcompanykey>
<cfinclude template="../queries/q_select_company_users.cfm">

<cfdump var="#q_select_company_users#">

<cfoutput query="q_select_company_users">
	<cfmodule template="/common/person/getuserpref.cfm"
		entrysection = "common"
		entryname = "personalcategories"
		defaultvalue1 = ""
		setcallervariable1 = 'a_str_personal_categories'
		userid = #q_select_company_users.userid#>
	
	<cfloop list="#form.frmcategories#" delimiters="#chr(10)#" index="a_str_add_category">
	
		<cfset a_str_add_category = Trim(a_str_add_category)>
	
		<cfif ListFindNoCase(a_str_personal_categories, a_str_add_category) IS  0>
			<!--- not found ... add --->
			<cfset a_str_personal_categories = ListAppend(a_str_personal_categories, a_str_add_category)>
		</cfif>
		
	</cfloop>
	
	<!--- categories to set ... --->
	#a_str_personal_categories#
	<hr>
	<cfmodule template="/common/person/saveuserpref.cfm"
		entrysection = "common"
		entryname = "personalcategories"
		userid = #q_select_company_users.userid#
		entryvalue1 = #a_str_personal_categories#>	

</cfoutput>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">