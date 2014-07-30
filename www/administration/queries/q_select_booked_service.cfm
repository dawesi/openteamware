<!--- //

	select a booked service
	
	// --->
	
<cfparam name="SelectBookedService.entrykey" type="string" default="">


<cfquery name="q_select_booked_service">
SELECT entrykey,companykey,productkey,paid,durationinmonths,totalamount,dt_contractend,createdbyuserkey,specialdiscount,comment,
productname,unit
FROM bookedservices
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectBookedService.entrykey#">;
</cfquery>