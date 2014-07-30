



<cfparam name="DeleteFromBasketRequest.entrykey" type="string" default="">

<cfparam name="DeleteFromBasketRequest.companykey" type="string" default="">



<cfquery name="q_delete_from_basket">

	DELETE FROM bookedservices WHERE

	settled = 0

	AND entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeleteFromBasketRequest.entrykey#">

	AND companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeleteFromBasketRequest.companykey#">;

</cfquery>