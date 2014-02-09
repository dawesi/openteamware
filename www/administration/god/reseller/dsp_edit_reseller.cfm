<!---
	edit
	--->
	

<cfinclude template="queries/q_select_reseller.cfm">

<cfquery name="q_select_reseller" dbtype="query">
SELECT
	*
FROM
	q_select_reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>


<cfset CreateEditReseller.action = 'edit'>
<cfset CreateEditReseller.query = q_select_reseller>

<cfinclude template="dsp_inc_create_edit_reseller.cfm">

