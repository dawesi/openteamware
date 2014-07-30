<!--- //

	create a customer ...
	
	// --->
<cfparam name="form.frmshortname" type="string" default="">
	
<!--- load next free customer id ... --->

<cftransaction>

<!--- get the newest customerid ... --->
<cfquery name="q_select_max_customer_id">
SELECT MAX(customerid) AS max_customerid FROM companies;
</cfquery>

<cfset a_int_new_customer_id = q_select_max_customer_id.max_customerid + 1>

<cfset a_dt_trialphase_end = LSParseDateTime(form.frmdt_trialphase_end)>

<cfif DateDiff('d', now(),a_dt_trialphase_end) GT 30>
	<cfset a_dt_trialphase_end = DateAdd('d', 30, Now())>
</cfif> 
	
<cfquery name="q_insert_customer">
INSERT INTO companies
	(
	resellerkey,
	createdbyuserkey,
	entrykey,
	status,
	companyname,
	shortname,
	description,
	domain,
	domains,
	uidnumber,
	telephone,
	fax,
	street,
	city,
	zipcode,
	country,
	countryisocode,
	customerid,
	email,
	dt_created,
	dt_trialphase_end,
	billingcontact,
	contactperson,
	generaltermsandconditions_accepted,
	industry,
	language,
	settlement_type,
	customertype
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_customer_key#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmradiostatus)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyname#">,
	<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.frmshortname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdomain#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdomain#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyuidnumber#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanytelephone#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyfax#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanystreet#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycity#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyzipcode#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycountry#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanycountry#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_customer_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanyemail#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_trialphase_end)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmbillingcontact#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcontactperson#">,
	<!--- agb noch nicht akzeptiert --->
	
	<cfif form.frm_settlement_type IS 0>
		<!--- standard settlement ... abrechnen �ber openTeamware.com --->
		0,
	<cfelse>
		<!--- wenn die verrechnung indirekt verl�uft, keine AGB zustimmung erforderlich --->
		1,
	</cfif>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmindustry#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmlanguage#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frm_settlement_type#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmtype#">
	)
;
</cfquery>

</cftransaction>