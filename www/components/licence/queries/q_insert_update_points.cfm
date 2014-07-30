
<cfquery name="q_select_points_entry">
SELECT
	companykey,productkey,availableunits
FROM
	consumergoods
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="E11A2209-9448-1723-8EEEDF6CCB91E747">
;
</cfquery>

<cfif q_select_points_entry.recordcount IS 1>

<!--- update --->
<cfquery name="q_update_points_entry">
UPDATE
	consumergoods
SET
	availableunits = <cfqueryparam cfsqltype="cf_sql_integer" value="#(val(q_select_points_entry.availableunits) + val(arguments.points))#">
WHERE
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">)
	AND
	(productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="E11A2209-9448-1723-8EEEDF6CCB91E747">)
;	
</cfquery>

<cfelse>

<!--- insert --->
<cfquery name="q_insert_points_entry">
INSERT INTO
	consumergoods
	(
	companykey,
	productkey,
	availableunits
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="E11A2209-9448-1723-8EEEDF6CCB91E747">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.points#">
	)
;	
</cfquery>

</cfif>