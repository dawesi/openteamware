
<cfquery name="q_select_company">
SELECT
	companyname,entrykey
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.frmcustomerid#">
;
</cfquery>

<cfquery name="q_update_company">
UPDATE
	companies
SET
	autoorderontrialend = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_company.entrykey#">
;
</cfquery>

<h4><cfoutput>#q_select_company.companyname#</cfoutput> wird keine automatisch generierte Rechnung bekommen</h4>