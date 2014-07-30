<!--- //



	select a single product ... 

	

	// --->

	

<cfparam name="SelectProductRequest.entrykey" type="string" default="">





<cfquery name="q_select_product">
SELECT
	entrykey,productname,dt_created,description,productgroupkey,itemindex,ongoing,unit,allowownquantities
FROM
	products
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectProductRequest.entrykey#">
;
</cfquery>