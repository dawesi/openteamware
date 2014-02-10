<!--- //

	Component:     Forms
	Description:   Load the data concerning a form request by it's entrykey
	

// --->

<cfquery name="q_select_form_request_by_requestkey" datasource="#request.a_str_db_tools#">
SELECT
	requestkey,
	formkey,
	userkey,
	dt_created,
	data_used,
	wddx_formdata,
	action_type
FROM
	form_requests
WHERE
	requestkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requestkey#">
;
</cfquery>


