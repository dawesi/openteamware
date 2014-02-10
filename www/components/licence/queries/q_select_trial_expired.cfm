<cfquery name="q_select_trial_expired" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	<!--- not yet a customer --->
	status = 1
	AND
	<!--- trial expired --->
	trialexpired = 1
;
</cfquery>