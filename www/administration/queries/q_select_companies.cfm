<!--- //



	load companies ...

	

	// --->

	

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	entrykey,companyname,dt_created,resellerkey,dt_contractstart,dt_contractend,
	status,rating,description,customertype,contactperson,email,distributorkey,
	dt_trialphase_end,dt_nextcontact,domains,disabled,customerid,street,zipcode,city
FROM
	companies
WHERE
	<cfinclude template="inc_qry_resellerkey.cfm">
ORDER BY
	companyname
;
</cfquery>