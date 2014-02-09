<cfparam name="form.frmcbissystempartner" type="numeric" default="0">
<cfparam name="form.frmcbisdistributor" type="numeric" default="0">
<cfparam name="form.frmcbisprojectpartner" type="numeric" default="0">
<cfparam name="form.frmcbcontractingparty" type="numeric" default="0">
<cfparam name="form.frmcbisdealer" type="numeric" default="0">

<cfdump var="#form#">

<cfquery name="q_select_companykey" datasource="#request.a_str_db_users#">
SELECT
	entrykey,status
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmcustomerid)#">
;
</cfquery>

<cfset a_str_companykey = q_select_companykey.entrykey>

<cfif Len(a_str_companykey) IS 0>
	Sie muessen eine Kundennummer eingeben!
	<cfabort>
</cfif>

<cfset a_str_resellerkey = CreateUUID()>

<cfquery name="q_update_reseller" datasource="#request.a_str_db_users#">
INSERT INTO
	reseller
	(
	companyname,
	entrykey,
	parentkey,
	description,
	street,
	telephone,
	country,
	CUSTOMERCONTACT,
	city,
	emailadr,
	assignedzipcodes,
	zipcode,
	companykey,
	assignedareas,
	issystempartner,
	isdistributor,
	isprojectpartner,
	isdealer,
	affiliatecode,
	contractingparty,
	homepage
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_resellerkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmparentkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmstreet#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtelephone#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcountry#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmCUSTOMERCONTACT#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcity#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmemailadr#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmassignedzipcodes#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmzipcode#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmassignedareas#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbissystempartner#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbisdistributor#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbisprojectpartner#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbisdealer#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmaffiliatecode#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbcontractingparty#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmhomepage#">
	)
;
</cfquery>

<!--- add 7 groupware and 7 pro licences --->
<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats">
	<cfinvokeargument name="companykey" value="#a_str_companykey#">
	<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
	<cfinvokeargument name="addseats" value="10">
	<cfinvokeargument name="comingfromshop" value="0">						
</cfinvoke>

<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats">
	<cfinvokeargument name="companykey" value="#a_str_companykey#">
	<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
	<cfinvokeargument name="addseats" value="10">
	<cfinvokeargument name="comingfromshop" value="0">						
</cfinvoke>

<cfset a_dt_contract_end = DateAdd('yyyy', 1, Now())>

<cfquery name="q_update" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	status = 0,
	dt_contractend = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_contract_end)#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">
;
</cfquery>

<cflocation addtoken="no" url="default.cfm?action=resellerusers&resellerkey=#a_str_resellerkey#">
