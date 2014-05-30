<!--- //

	default reports
	
	// --->
	
<!--- select fields --->
<cfquery name="q_select_fields">
SELECT
	*
FROM
	crm_reports
WHERE
	(1 = 0)
;
</cfquery>

<!--- select default report --->
<cfquery name="q_select_default_report">
SELECT
	entrykey,reportname,description,groupname,basedonaddressbook,allow_select_fields
FROM
	crm_default_reports
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reportkey#">
;
</cfquery>

<cfset q_select_report = QueryNew(q_select_fields.columnlist)>	
	
<cfset QueryAddRow(q_select_report, 1)>

<cfset QuerySetCell(q_select_report, 'defaultreport', 1, 1)>
<cfset QuerySetCell(q_select_report, 'reportname', q_select_default_report.reportname, 1)>
<cfset QuerySetCell(q_select_report, 'description', q_select_default_report.description, 1)>
<cfset QuerySetCell(q_select_report, 'entrykey', q_select_default_report.entrykey, 1)>
<cfset QuerySetCell(q_select_report, 'basedonaddressbook', q_select_default_report.basedonaddressbook, 1)>
<cfset QuerySetCell(q_select_report, 'date_field', 'dt_created', 1)>
<cfset QuerySetCell(q_select_report, 'dt_created', Now(), 1)>
<cfset QuerySetCell(q_select_report, 'allow_select_fields', q_select_default_report.allow_select_fields, 1)>