<!--- //
	select ...

	// --->


<cfparam name="SelectAccounts.CompanyKey" type="string" default="">

<!--- check if resellerkey is ok ... --->
<cfquery name="q_check_resellerkey" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectAccounts.CompanyKey#">
;
</cfquery>

<cfif q_check_resellerkey.recordcount is 0>
	<cfabort>
</cfif>

<cfquery name="q_select_accounts" datasource="#request.a_str_db_users#">
SELECT
	firstname,surname,username,entrykey,pwd,login_count,lasttimelogin,login_count,activitystatus
FROM
	users
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectAccounts.CompanyKey#">
;
</cfquery>