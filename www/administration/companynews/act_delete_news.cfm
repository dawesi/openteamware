<cfinclude template="../dsp_inc_select_company.cfm">

<cfquery name="q_delete" datasource="#request.a_str_db_tools#">
DELETE FROM
	companynews
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cflocation addtoken="no" url="../default.cfm?action=companynews#writeurltags()#">