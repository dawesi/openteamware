<!--- //

	Module:	SERVICE
	Description: 
	

// --->

<cfquery name="q_select_criteria_assignment_exists">
SELECT
	COUNT(id) AS count_id
FROM
	assigned_criteria
WHERE
	(servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">)
	AND
	(objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">)
	AND
	(criteria_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_criteria#">)
;
</cfquery>

<cfif q_select_criteria_assignment_exists.count_id IS 0>
	<cfquery name="q_insert_criteria_assignment">
	INSERT INTO
		assigned_criteria
		(
		servicekey,
		objectkey,
		dt_created,
		createdbyuserkey,
		criteria_id
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_criteria#">
		)
	;
	</cfquery>
</cfif>

