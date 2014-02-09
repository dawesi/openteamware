


<cfquery name="q_update_workgroup" datasource="#request.a_str_db_users#">
UPDATE
	workgroups
SET
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FRMPARENTGROUPKEY#">,
	groupname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmname#">,
	shortname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmshortname#">,
	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdescription#">,
	colour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcolour#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmworkgroupkey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
;
</cfquery>

<cfdump var="#form#">

<cflocation addtoken="no" url="../default.cfm?action=workgroups&resellerkey=#urlencodedformat(form.frmresellerkey)#&companykey=#urlencodedformat(form.frmcompanykey)#">