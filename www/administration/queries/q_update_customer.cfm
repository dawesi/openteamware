<!--- //

	update a customer ...
	
	// --->
		
<cfparam name="form.frmshortname" type="string" default="">

<cfquery name="q_update_customer" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,
	companyname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyname#">,
	shortname = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.frmshortname#">,
	status = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmradiostatus#">,
	rating = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmrating#">,
	street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanystreet#">,
	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycity#">,
	zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyzipcode#">,
	country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycountry#">,
	countryisocode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycountry#">,
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyemail#">,
	domains = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdomain#">,
	uidnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyuidnumber#">,
	telephone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanytelephone#">,
	fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyfax#">,
	billingcontact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmbillingcontact#">,
	contactperson = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcontactperson#">,
	industry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmindustry#">,
	language = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmlanguage#">,
	customertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmtype#">,
	settlement_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frm_settlement_type#">
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
;
</cfquery>