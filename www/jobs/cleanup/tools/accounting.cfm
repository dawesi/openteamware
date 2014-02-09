<!---

	cleanup accounting

--->


<cfquery name="q_delete_invoiced" datasource="#request.a_str_db_users#">
DELETE FROM
	invoices
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd( 'yyyy', -2, Now() )#">
;
</cfquery>

<cfquery name="q_delete_licencehistory" datasource="#request.a_str_db_users#">
DELETE FROM
	licencehistory
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd( 'yyyy', -2, Now() )#">
;
</cfquery>
