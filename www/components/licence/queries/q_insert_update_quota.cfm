
<cfquery name="q_select_quota_entry" datasource="#request.a_str_db_users#">
SELECT
	companykey,productkey,availableunits
FROM
	consumergoods
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="AD9947E9-92B7-635C-B48BC5D8259841DF">
;
</cfquery>

<cfif q_select_quota_entry.recordcount IS 1>

<!--- update --->
<cfquery name="q_insert_quota_entry" datasource="#request.a_str_db_users#">
UPDATE
	consumergoods
SET
	availableunits = <cfqueryparam cfsqltype="cf_sql_integer" value="#(val(q_select_quota_entry.availableunits) + arguments.mb)#">
WHERE
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">)
	AND
	(productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="AD9947E9-92B7-635C-B48BC5D8259841DF">)
;	
</cfquery>

<cfelse>

<!--- insert --->
<cfquery name="q_insert_quota_entry" datasource="#request.a_str_db_users#">
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
	<cfqueryparam cfsqltype="cf_sql_varchar" value="AD9947E9-92B7-635C-B48BC5D8259841DF">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mb#">
	)
;	
</cfquery>

</cfif>