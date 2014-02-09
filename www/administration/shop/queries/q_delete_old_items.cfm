<cfquery name="q_delete_old_items" datasource="#request.a_str_db_users#">
DELETE FROM
	trialendaccountaction
WHERE
	companykey =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
;
</cfquery>