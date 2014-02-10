<!--- load next free customer id ... --->
<cfquery name="q_select_max_customer_id" datasource="#request.a_str_db_users#">
SELECT
	MAX(customerid) AS max_customerid
FROM
	companies
;
</cfquery>

<cfset a_int_new_customer_id = Val(q_select_max_customer_id.max_customerid) + 1>

<cfquery name="q_insert_customer" datasource="#request.a_str_db_users#">
INSERT INTO companies
	(
	resellerkey,
	distributorkey,
	createdbyuserkey,
	assignedtoreseller,
	entrykey,
	httpreferer,
	status,
	companyname,
	customertype,
	contactperson,
	shortname,
	description,
	domains,
	uidnumber,
	telephone,
	fax,
	street,
	city,
	zipcode,
	countryisocode,
	customerid,
	email,
	signupsource,
	generaltermsandconditions_accepted,
	dt_created,
	industry,
	language,
	billingcontact,
	wddx_additional_data,
	company_default_categories,
	disabled_reason,
	oldpasswords,
	autoorderontrialend,
	settlement_type
	
	<cfif arguments.status IS 1>
		,dt_trialphase_end
	</cfif>
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resellerkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.distributorkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assignedtoreseller#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.httpreferer#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companyname#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.customertype#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactperson#">,
	<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.shortname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domains#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uidnumber#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.telephone#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.street#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zipcode#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.countryisocode#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_customer_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.source#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.generaltermsandconditions_accepted#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.industry#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language#">,
	'',
	'',
	'',
	'',
	'',
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_autoorder_on_trial_end#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.settlement_type#">
	
	<cfif arguments.status IS 1>
		,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_trialphase_end)#">	
	</cfif>
	)
;
</cfquery>