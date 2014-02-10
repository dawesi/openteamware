

<cfparam name="InsertNewCustomerContactRequest.userkey" type="string" default="">

<cfparam name="InsertNewCustomerContactRequest.companykey" type="string" default="">

<cfparam name="InsertNewCustomerContactRequest.user_level" type="numeric" default="100">

<cfparam name="InsertNewCustomerContactRequest.type" type="numeric" default="0">



<cfquery name="q_insert_customer_contact" datasource="#request.a_str_db_users#">
INSERT INTO
	companycontacts
	(
	userkey,
	contacttype,
	companykey,
	permissions,
	user_level
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertNewCustomerContactRequest.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewCustomerContactRequest.type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertNewCustomerContactRequest.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permissions#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level#">
	)
;
</cfquery>