<!--- //



	select a customer contact

	

	// --->



<!--- select all contacts of this company --->	

<cfparam name="SelectCustomerContacts.entrykey" type="string" default="">



<cfquery name="q_select_customer_contacts" datasource="#request.a_str_db_users#">
SELECT
	userkey,user_level,contacttype,permissions,contacttype
FROM
	companycontacts
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCustomerContacts.entrykey#">
;
</cfquery>