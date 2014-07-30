<!--- //

	Module:		Contacts
	Action:		ReturnIndustryNameByNACECode
	Description:...
	
	Header:		

// --->

<cfquery name="q_select_nace_all_nace_codes">
SELECT
	code,industry_name
FROM
	nace_codes
ORDER BY
	code
;
</cfquery>

