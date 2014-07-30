<!--- //

	Component:     Forms
	Description:   Save posted content in wddx format for further usage
	

// --->

<cfquery name="q_update_set_wddx_posted_form_content">
UPDATE
	form_requests
SET
	wddx_formdata = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.wddx_formdata#">
WHERE
	formkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formkey#">
	AND
	requestkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requestkey#">
;
</cfquery>

