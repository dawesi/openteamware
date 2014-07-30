<!--- //

	load the company data 
	
	// --->

<cfparam name="LoadCompanyData.entrykey" type="string" default="">

<cfinclude template="../utils/inc_check_security.cfm">

<cfquery name="q_select_own_company">
SELECT
	companykey
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cfquery name="q_select_company_data">
SELECT
	companyname,dt_created,entrykey,uidnumber,description,telephone,customheader,customss,resellerkey,
	status,domains,dt_trialphase_end,billingcontact,createdbyuserkey,
	domain,customertype,uidnumber,street,fax,fbnumber,shortname,
	zipcode,city,email,country,countryisocode,customerid,contactperson,
	DATE_FORMAT(dt_contractend, '%Y-%m-%d %T') AS dt_contractend,dt_nextcontact,
	DATE_FORMAT(dt_contractstart, '%Y-%m-%d %T') AS dt_contractstart,
	rating,disabled,disabled_reason,dt_disabled,autoorderontrialend,industry,
	generaltermsandconditions_accepted,distributorkey,language,
	settlement_type,allow_order_shop,signupsource
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadCompanyData.entrykey#">

	<cfif (request.a_bol_is_reseller is true) AND NOT (q_select_own_company.companykey IS LoadCompanyData.entrykey)>
	AND <cfinclude template="inc_qry_resellerkey.cfm">
	</cfif>
;
</cfquery>