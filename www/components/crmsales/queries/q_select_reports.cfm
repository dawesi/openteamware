<cfquery name="q_select_reports" datasource="#request.a_str_db_crm#">
SELECT
	*
FROM
	crm_reports
;
</cfquery>