<cfquery name="q_insert_trialendaccountaction">
INSERT INTO
	trialendaccountaction
	(
	companykey,
	productkey,
	userkeys
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="delete">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdelete#">
	)
;
</cfquery>

<cfquery name="q_insert_trialendaccountaction">
INSERT INTO
	trialendaccountaction
	(
	companykey,
	productkey,
	userkeys
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="AD4262D0-98D5-D611-4763153818C89190">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmprofessional#">
	)
;
</cfquery>


<cfquery name="q_insert_trialendaccountaction">
INSERT INTO
	trialendaccountaction
	(
	companykey,
	productkey,
	userkeys
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="AE79D26D-D86D-E073-B9648D735D84F319">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmgroupware#">
	)
;
</cfquery>