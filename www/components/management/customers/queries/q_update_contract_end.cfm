



<!--- update the contract end ... --->



<cfparam name="SetContractEndRquest.entrykey" type="string" default="">

<cfparam name="SetContractEndRquest.date" type="date">



<cfquery name="q_update_contract_end" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	dt_contractend = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(SetContractEndRquest.date)#">,
	<!--- customer! --->
	status = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SetContractEndRquest.entrykey#">
;
</cfquery>