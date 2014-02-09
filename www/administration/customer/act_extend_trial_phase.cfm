

<cfdump var="#form#">

<cfset a_dt_trial_end = lsParseDateTime(form.FRMDT_TRIAL_END)>

<cfoutput>#a_dt_trial_end#</cfoutput>

<cfquery name="q_update_trial_phase" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	DT_TRIALPHASE_END = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_trial_end)#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
	AND
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">
	AND
	status = 1
;
</cfquery>


<cflocation addtoken="no" url="../default.cfm?action=customerproperties#writeurltagsfromform()#">