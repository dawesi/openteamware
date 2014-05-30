<cfquery name="q_select_old_crm_sales_binding">
SELECT
	*
FROM
	crmsalesmappings
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

<!--- create a "backup" --->
<cfif q_select_old_crm_sales_binding.recordcount GT 0>
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="q_select_old_crm_sales_binding" type="html">
	<cfdump var="#arguments#" label="arguments">
	<cfdump var="#q_select_old_crm_sales_binding#" label="q_select_old_crm_sales_binding">
	</cfmail>
</cfif>

<cfquery name="q_delete_crm_sales_binding">
DELETE FROM
	crmsalesmappings
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>