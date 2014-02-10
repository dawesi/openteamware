<!--- //

	Module:		Project
	Fn:			GetOwnerUserkey
	Description: 
	

// --->

<cfquery name="q_select_owner_userkey" datasource="#request.a_str_db_crm#">
SELECT
	userkey
FROM
	projects
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

