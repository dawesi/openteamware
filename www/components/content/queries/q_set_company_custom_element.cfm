<cfquery name="q_delete_company_custom_element">
DELETE FROM
	company_custom_elements
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	item_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.elementname#">
;
</cfquery>

<cfif Len(arguments.elementvalue) GT 0>
	<cfquery name="q_delete_company_custom_element">
	INSERT INTO
		company_custom_elements
		(
		createdbyuserkey,
		dt_created,
		companykey,
		item_name,
		content
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.elementname#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.elementvalue#">
		)
	;
	</cfquery>
</cfif>