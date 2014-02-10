
<cfset a_struct_company_logins = StructNew()>


<cfloop query="q_select_companies">

	<cfquery name="q_select_login_sum" datasource="#request.a_str_db_users#">
	SELECT
		SUM(login_count) AS sum_logins
	FROM
		users
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
	;
	</cfquery>
	
	<cfif q_select_login_sum.sum_logins GTE 3>
		<cfset a_struct_company_logins[q_select_companies.entrykey] = q_select_login_sum.sum_logins>
	</cfif>
	
</cfloop>