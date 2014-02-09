<cfquery name="q_update_price" datasource="#request.a_str_db_users#">
DELETE FROM
	prices
WHERE
	quantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmquantity#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpricekey#">
;
</cfquery>