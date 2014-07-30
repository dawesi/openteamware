<!--- //

	Module:		Resources
	Description:Create a new resource ...
	

// --->


<cfquery name="q_insert_resource">
INSERT INTO
	resources
	(
	entrykey,
	createdbyuserkey,
	title,
	description,
	dt_created,
	companykey,
	workgroupkeys,
	exclusive,
	location
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GETUTCTime(now()))#">,	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkeys#">,
	<cfif arguments.exclusive>
		<cfqueryparam cfsqltype="cf_sql_integer" value="1">
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_integer" value="0">	
	</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">
	)
;
</cfquery>

