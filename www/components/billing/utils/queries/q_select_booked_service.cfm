<!--- //

	select a booked service
	
	// --->
	
<cfparam name="SelectBookedService.entrykey" type="string" default="">


<cfquery name="q_select_booked_service" datasource="#request.a_str_db_users#">
SELECT
	quantity,entrykey,companykey,productkey,paid,durationinmonths,totalamount,dt_contractend,
	createdbyuserkey,comment,specialdiscount,productname,unit,currency
FROM
	bookedservices
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectBookedService.entrykey#">
;
</cfquery>