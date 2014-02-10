<!--- //

	Module:		Contacts
	Action:		ReturnIndustryNameByNACECode
	Description:...
	
	Header:		

// --->

<cfquery name="q_select_nace_all_nace_codes" datasource="#GetDSName()#">
SELECT
	code,industry_name
FROM
	nace_codes
ORDER BY
	code
;
</cfquery>

