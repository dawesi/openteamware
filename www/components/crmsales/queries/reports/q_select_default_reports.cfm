<!--- //

	Module:		Reports
	Function:	GetDefaultReports
	Description: 
	

// --->

<cfquery name="q_select_default_reports" datasource="#request.a_str_db_crm#">
SELECT
	entrykey,reportname,description,groupname,basedonaddressbook,allow_select_fields
FROM
	crm_default_reports
;
</cfquery>

