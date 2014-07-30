<cfquery name="q_select_item_exists">
SELECT
	COUNT(id) AS count_id
FROM
	various_crm_settings
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	setting_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#">
;
</cfquery>

<cfif q_select_item_exists.count_id IS 0>

	<!--- insert --->
	<cfquery name="q_insert_setting">
	INSERT INTO
		various_crm_settings
		(
		companykey,
		setting_name,
		setting_value,
		createdbyuserkey,
		dt_created
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
		)
	;
	</cfquery>

<cfelse>

	<!--- update --->
	<cfquery name="q_update_setting">
	UPDATE
		various_crm_settings
	SET
		setting_value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#">,
		dt_created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
		createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
		AND
		setting_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#">
	;
	</cfquery>

</cfif>