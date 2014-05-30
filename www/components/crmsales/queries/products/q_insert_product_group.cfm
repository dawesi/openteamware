<!--- //
	Module:		 Product
	Description: Inserts new productgroup into database
	

	
// --->

<cfquery name="q_insert_product_qroup">
INSERT INTO
	productgroups
	(
	entrykey,
    dt_created,
    createdbyuserkey,
    lasteditedbyuserkey,

	companykey,
    productgroupname,
    description,
    parentproductgroupentrykey,
    category1,
    category2
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#"/>,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.companykey#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.productgroupname#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.description#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.parentproductgroupentrykey#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category1#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category2#"/>
	)
;
</cfquery>

