

<!--- 

	select all companies ...
	
	--->
	
<cfquery name="q_select_all_companies" datasource="#request.a_str_db_users#">
SELECT companyname,entrykey FROM companies;
</cfquery>