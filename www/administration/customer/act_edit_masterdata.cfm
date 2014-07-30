<cfdump var="#form#">



<cfset LoadCompanyData.entrykey = form.frmcompanykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfwddx action="cfml2wddx" input="#q_select_company_data#" output="a_str_wddx" usetimezoneinfo="yes">
<cfoutput>#htmleditformat(a_str_wddx)#</cfoutput>

<cfquery name="q_insert_wddx">
INSERT INTO
	companies_saved_data
	(
	createdbyuserkey,
	dt_created,
	wddx,
	companykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_wddx#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
	)
;
</cfquery>

<!--- update ... --->
<cfquery name="q_update_customer" datasource="myusers">
UPDATE
	companies
SET
	datachecked = 0,
	companyname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyname#">,
	contactperson = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcontactperson#">,
	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,
	street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanystreet#">,
	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycity#">,
	zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyzipcode#">,
	country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycountry#">,
	countryisocode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycountry#">,
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyemail#">,
	uidnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyuidnumber#">,
	telephone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanytelephone#">,
	fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyfax#">,
	billingcontact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmbillingcontact#">,
	customertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmtype#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
	AND
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frm_resellerkey#">
;
</cfquery>


<cflocation addtoken="no" url="#ReturnRedirectURL()#">