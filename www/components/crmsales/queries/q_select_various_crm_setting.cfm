<cfquery name="q_select_various_crm_setting" datasource="#request.a_str_db_tools#">
SELECT
	setting_value
FROM
	various_crm_settings
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	setting_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#">
;
</cfquery>