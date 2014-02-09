
<cfdump var="#form#">

<cfparam name="form.frmpaid" type="numeric" default="0">

<!---<cfset a_dt_due = ParseDateTime(form.FRMDT_DUE)>

<cfoutput>#a_dt_due#</cfoutput>--->

<!--- update --->

<cfquery name="q_update_invoice" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	paid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmpaid#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
;
</cfquery>

updated.