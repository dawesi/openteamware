<!--- //

	Module:        Import
	Description:   Insert new import job


// --->
<cfquery name="q_select_import_table">
SELECT
	servicekey,
	table_wddx,
	datatype
FROM
	importjobs
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">
;
</cfquery>