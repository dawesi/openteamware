<!--- //



	select all workgroups for the specified companies

	

	// --->

	

<cfquery name="q_select_workgroups" datasource="#request.a_str_db_users#">
SELECT
	entrykey,groupname,description,dt_created,parentkey,createdbyuserkey,companykey,colour,shortname
FROM
	workgroups
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
ORDER BY
	groupname
;
</cfquery>