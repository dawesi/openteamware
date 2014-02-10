<!--- //

	Module:		Forms
	Function:	LoadPostedFormWDDXData
	Description: 
	

// --->

<cfquery name="q_select_posted_form_data" datasource="#request.a_str_db_tools#">
SELECT
	wddx_formdata
FROM
	form_requests
WHERE
	requestkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requestkey#">
;
</cfquery>

