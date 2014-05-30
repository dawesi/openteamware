<!--- //

	Component:	Projects
	Function:	GetProject
	Description:Return sales projects trends
	

// --->

<cfquery name="q_select_sales_project_stage_trends">
SELECT
	sales,
	dt_project_start,
	probability,
	dt_created,
	stage,
	dt_closing
FROM
	salesprojects_trend_history
WHERE
	salesprojectentrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
ORDER BY
	dt_created DESC
;
</cfquery>

