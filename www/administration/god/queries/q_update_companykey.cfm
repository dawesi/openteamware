<cfquery name="q_select_companykey">
SELECT
	entrykey
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcustomerid#">
;
</cfquery>

<cfdump var="#q_select_companykey#">

<cfif q_select_companykey.recordcount IS 0>
	<h4>no such company found</h4>
	<cfabort>
</cfif>



<cfquery name="q_update_companykey">
UPDATE
	users
SET
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companykey.entrykey#">
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmusername#">
;
</cfquery>