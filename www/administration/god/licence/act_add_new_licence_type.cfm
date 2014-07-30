<!--- //

	Module:		Administration / God
	Description:Add empty licence status
	
// --->

<cfquery name="q_update_status">
INSERT INTO
	licencing   
	(
	productkey,
	companykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FRMPRODUCTKEY#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FRMCOMPANYKEY#">
	)
;
</cfquery>

Licence added (0 seats)
