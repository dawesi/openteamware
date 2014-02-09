<cfparam name="form.frmcbissystempartner" type="numeric" default="0">
<cfparam name="form.frmcbisdistributor" type="numeric" default="0">
<cfparam name="form.frmcbisprojectpartner" type="numeric" default="0">
<cfparam name="form.frmcbcontractingparty" type="numeric" default="0">
<cfparam name="form.frmcbisdealer" type="numeric" default="0">

<cfdump var="#form#">

<cfquery name="q_select_companykey" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmcustomerid)#">
;
</cfquery>

<cfset a_str_companykey = q_select_companykey.entrykey>

<cfquery name="q_update_reseller" datasource="#request.a_str_db_users#">
UPDATE
	reseller
SET
	companyname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyname#">,
	description= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,
	street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmstreet#">,
	telephone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtelephone#">,
	country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcountry#">,
	CUSTOMERCONTACT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmCUSTOMERCONTACT#">,
	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcity#">,
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmemailadr#">,
	assignedzipcodes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmassignedzipcodes#">,
	zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmzipcode#">,
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmparentkey#">,
	bankdetails = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmbankdetails#">,
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">,
	assignedareas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmassignedareas#">,
	issystempartner = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbissystempartner#">,
	isprojectpartner = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FRMCBISPROJECTPARTNER#">,
	isdistributor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbisdistributor#">,
	isdealer = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbisdealer#">,
	affiliatecode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmaffiliatecode#">,
	contractingparty = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbcontractingparty#">,
	homepage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmhomepage#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
;
</cfquery>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">