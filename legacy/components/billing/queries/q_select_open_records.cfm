<!--- 

	select all open records ...

	--->

<cfparam name="SelectOpenRecordsRequest.companykey" type="string" default="">

<cfquery name="q_select_open_records" datasource="#request.a_str_db_users#">
SELECT
	entrykey,companykey,productkey,paid,durationinmonths,totalamount,dt_contractend,
	createdbyuserkey,productname,quantity,specialdiscount
FROM
	bookedservices
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectOpenRecordsRequest.companykey#">
	AND
	settled = 0
;
</cfquery>