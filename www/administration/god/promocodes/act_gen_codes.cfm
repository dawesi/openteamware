<cfdump var="#form#">

<cfif Len(form.frmstart) IS 0>
	no start given
	<cfabort>
</cfif>

<cfif Len(form.frmend) IS 0>
	no end given
	<cfabort>
</cfif>

<cfif form.frmend - form.frmstart GT 999>
	not more than 999 allowed
	<cfabort>
</cfif>

<!--- check if code is already in use --->

<cfquery name="q_select_code_in_use" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	promocodes
WHERE
	code BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmstart#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmend#">
;
</cfquery>

<cfif q_select_code_in_use.count_id GT 0>
	Codes are already in use
	<cfabort>
</cfif>


<!--- insert now ... --->

<cfloop from="#form.frmstart#" to="#form.frmend#" index="ii">
	<cfquery name="q_insert_promocode" datasource="#request.a_str_db_users#">
	INSERT INTO
		promocodes
		(
		resellerkey,
		dt_created,
		code,
		codevalue
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#ii#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmvalue#">
		)
	;
	</cfquery>
</cfloop>

<cfquery name="q_insert_mapping" datasource="#request.a_str_db_users#">
INSERT INTO
	reseller_promocode_mappings
	(
	resellerkey,
	startcode,
	endcode,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmstart#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmend#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>