<!--- //

	Module:		Address Book
	Description:Remove all cached ID information
	

// --->

<cfquery name="q_delete_cached_ids_of_company" datasource="#request.a_str_db_tools#">
DELETE FROM
	cached_ids
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">
;
</cfquery>

