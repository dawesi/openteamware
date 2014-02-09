<!--- //

	select the whole log book of the fetchmail process
	
	// --->
<cfquery name="q_select_fetchmail_logbook" datasource="#request.a_str_db_mailusers#">
SELECT
	dt_check,emailadr,exitcode
FROM
	fetchmailexitcodes
WHERE
	(account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
ORDER BY
	dt_check DESC
;
</cfquery>