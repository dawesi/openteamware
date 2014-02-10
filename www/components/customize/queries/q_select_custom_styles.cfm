<cfquery name="q_select_custom_styles" datasource="#request.a_str_db_app#">
SELECT
	entrykey,userkey,companykey,resellerkey,description
FROM
	customstyles
WHERE
	enabled = 1
;
</cfquery>