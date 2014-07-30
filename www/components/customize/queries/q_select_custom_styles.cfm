<cfquery name="q_select_custom_styles">
SELECT
	entrykey,userkey,companykey,resellerkey,description
FROM
	customstyles
WHERE
	enabled = 1
;
</cfquery>