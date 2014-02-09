<cfquery name="q_update_status" datasource="#request.a_str_db_users#">
UPDATE
	licencing   
SET
	inuse = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FRMINUSE#">,
	totalseats = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmtotalseats#">,
	availableseats = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmavailable#">
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FRMCOMPANYKEY#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FRMPRODUCTKEY#">
;
</cfquery>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">