

<cfparam name="SelectResellerDataRequest.entrykey" type="string" default="">

<cfquery name="q_select_reseller_record" datasource="#request.a_str_db_users#">
SELECT
	dt_created,entrykey,country,companyname,parentkey,delegaterights,
	includefooter,street,zipcode,city,telephone,emailadr,domains,
	companykey,contractingparty
FROM
	reseller
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectResellerDataRequest.entrykey#">)
;
</cfquery>