<!--- //

	Module:		Projects
	Function	GetProject
	Description: 
	

// --->

<cfquery name="q_select_project" datasource="#request.a_str_db_crm#">
SELECT
	budget,
	categories,
	stage,
	sales,
	currency,
	description,
	dt_begin,
	dt_created,
	dt_due,
	dt_end,
	dt_lastmodified,
	entrykey,
	parentprojectkey,
	percentdone,
	priority,
	projectleaderuserkey,
	dt_closing,
	status,
	title,
	project_type,
	probability,
	lead_source,
	lead_source_id,
	business_type,
	userkey,
	contactkey,
	closed,
	closedbyuserkey,
	dt_closed,
	'' AS contactkey_displayvalue,
	'' AS projectleaderuserkey_displayvalue,
	CAST((probability * sales / 100) AS SIGNED) AS sales_probability
FROM
	projects
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>


