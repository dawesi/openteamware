<!--- //

	select ...
	
	// --->
	
<cfquery name="q_select_users" datasource="#request.a_str_db_users#">
SELECT firstname,surname,username,entrykey FROM users
WHERE companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.company#">


<cfif len(url.username) gt 0>
AND UPPER(username) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.username)#%">
</cfif>

</cfquery>