<!--- //

	Module:		Projects
	Function:	CreateUpdateProject
	Description:Insert into history
	

// --->

<cfquery name="q_insert_sales_project_history" datasource="#request.a_str_db_crm#">
INSERT INTO
	salesprojects_trend_history
	(
	sales,
	probability,
	stage,
	dt_created,
	entrykey,
	createdbyuserkey,
	salesprojectentrykey,
	dt_closing
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_original_data.sales#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_original_data.probability#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_original_data.stage#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_select_original_data.dt_lastmodified#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#">,
	
	<cfif IsDate(q_select_original_data.dt_closing)>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_select_original_data.dt_closing#">
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
	</cfif>
	)
;
</cfquery>

