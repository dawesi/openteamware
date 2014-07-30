<!--- //

	Module:		Forms
	Function:	LoadPostedFormWDDXData
	Description: 
	

// --->

<cfquery name="q_select_posted_form_data">
SELECT
	wddx_formdata
FROM
	form_requests
WHERE
	requestkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requestkey#">
;
</cfquery>

