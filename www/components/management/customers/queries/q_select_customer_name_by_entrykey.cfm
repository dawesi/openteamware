

<cfparam name="SelectCustomerName.Entrykey" type="string" default="">

<cfquery name="q_select_customer_name_by_entrykey" datasource="#request.a_str_db_users#">
SELECT companyname FROM companies
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCustomerName.Entrykey#">;
</cfquery>