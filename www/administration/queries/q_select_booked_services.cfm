<!--- //



	select all booked services ...

	

	// --->

	

<cfparam name="SelectBookedServices.companykey" type="string" default="">

<cfparam name="SelectBookedServices.SettledType" type="numeric" default="0">

<cfquery name="q_select_booked_services">
SELECT
	entrykey,companykey,productkey,paid,durationinmonths,totalamount,dt_contractend,
	createdbyuserkey,productname,quantity,unit,specialdiscount,settled
FROM
	bookedservices
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectBookedServices.companykey#">
	AND
	settled = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectBookedServices.SettledType#">
;
</cfquery>