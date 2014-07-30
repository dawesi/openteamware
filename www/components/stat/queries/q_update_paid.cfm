<cfif StructKeyExists(request, 'a_bol_paid_updated')>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_open_invoices">
SELECT
	companykey
FROM
	invoices
WHERE
	paid = 0
	AND
	dunninglevel = 2
;
</cfquery>

<cfquery name="q_update_companies">
UPDATE
	companies
SET
	openinvoices = 0
;
</cfquery>

<cfif q_select_open_invoices.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- update ... --->
	
	<cfquery name="q_update_companies">
	UPDATE
		companies
	SET
		openinvoices = 1
	WHERE
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_open_invoices.companykey)#" list="yes">)
	;
	</cfquery>

<cfset request.a_bol_paid_updated = true>