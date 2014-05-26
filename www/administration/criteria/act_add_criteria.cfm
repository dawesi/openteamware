<cfif Len(form.frmname) IS 0>
	<h4>empty name</h4>
	<cfabort>
</cfif>

<cfquery name="q_select_dup" datasource="#request.a_str_db_crm#">
SELECT
	COUNT(id) AS count_id
FROM
	crmcriteria
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
	AND
	criterianame = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmname#">
	AND
	parent_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmparentid#">
;
</cfquery>

<cfif q_select_dup.count_id GT 0>
	<h4>criteria already exists</h4>
	<cfabort>
</cfif>

<cfquery name="q_insert_criteria" datasource="#request.a_str_db_crm#">
INSERT INTO
	crmcriteria
	(
	companykey,
	dt_created,
	criterianame,
	description,
	parent_id
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmparentid#">
	)
;
</cfquery>

<cflocation addtoken="no" url="../index.cfm?action=criteria#WriteURLTagsfromForm()#">