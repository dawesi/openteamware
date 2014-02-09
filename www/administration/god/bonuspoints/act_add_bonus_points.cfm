<!--- //

	add bonus points
	
	// --->
	
<cfquery name="q_select_companykey" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcustomerid#">
;
</cfquery>

<cfif q_select_companykey.recordcount IS 0>
	<h1>not found</h1>
	<cfabort>
</cfif>
	
<cfinvoke component="#application.components.cmp_licence#" method="AddAvailablePoints">
	<cfinvokeargument name="companykey" value="#q_select_companykey.entrykey#">
	<cfinvokeargument name="points" value="#form.frmpoints#">
</cfinvoke>