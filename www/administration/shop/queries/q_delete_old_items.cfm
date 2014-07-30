<cfquery name="q_delete_old_items">
DELETE FROM
	trialendaccountaction
WHERE
	companykey =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
;
</cfquery>