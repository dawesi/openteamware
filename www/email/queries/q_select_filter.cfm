<!--- //

	select all filter
	
	// --->
	
<cfquery name="q_select_filter" datasource="#request.a_str_db_mailusers#">
SELECT id,enabled,aposition,stoponsuccess,filtertype,filtername,parameter,
comparison,comparisonparm,comparisonfield,antispamfilter
FROM filter
WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
AND userdefined = 1
ORDER BY aposition;
</cfquery>