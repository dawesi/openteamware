<cfquery name="q_update_bill_cancel" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	cancelled = 1,
	dt_cancelled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	cancelledbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancelledbyuserkey#">,
	reason_cancelled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reason#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>