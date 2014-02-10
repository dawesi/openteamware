
<cfparam name="SelectCustomerRecordRequest.Entrykey" type="string" default="">

<cfquery name="q_Select_customer_record" datasource="#request.a_str_db_users#">
SELECT
	domain,companyname,description,uidnumber,dt_contractend,street,zipcode,city,country,
	telephone,fax,countryisocode,customerid,resellerkey,domains,billingcontact,status,email,
	dt_trialphase_end,settlementinterval,disabled,distributorkey,contactperson,language,currency,
	settlement_type,allow_order_shop,autoorderontrialend
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCustomerRecordRequest.Entrykey#">
;
</cfquery>