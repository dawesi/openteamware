<cfquery name="q_select_ctac_accepted">
SELECT
	generaltermsandconditions_accepted,
	settlement_type
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>