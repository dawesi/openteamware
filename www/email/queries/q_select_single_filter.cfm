<!--- //

	select all filter
	
	// --->
<cfparam name="SelectSingleFilterRequest.id" type="numeric" default="0">
	
<cfquery name="q_select_single_filter" datasource="#request.a_str_db_mailusers#">
SELECT id,enabled,aposition,stoponsuccess,filtertype,filtername,parameter,
comparison,comparisonparm,comparisonfield,antispamfilter
FROM filter
WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectSingleFilterRequest.id#">);
</cfquery>