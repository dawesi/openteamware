<!--- //

	Module:        Import
	Description:   Insert new import job
	

// --->
<cfquery name="q_select_import_table" datasource="#request.a_str_db_tools#">
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

<!---
	$Log: q_select_import_table.cfm,v $
	Revision 1.4  2007/05/22 16:23:41  hansjp
	added log
	
	--->