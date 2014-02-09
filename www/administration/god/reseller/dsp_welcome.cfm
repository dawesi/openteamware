<cfparam name="url.contractingpartyonly" type="boolean" default="false">

<h4>&Uuml;bersicht!</h4>
<cfinclude template="queries/q_select_reseller.cfm">

<cfif url.contractingpartyonly>
<cfquery name="q_select_reseller" dbtype="query">
SELECT
	*
FROM
	q_select_reseller
WHERE
	contractingparty = 1
;
</cfquery>
	<a href="default.cfm">Alle VP anzeigen</a>
<cfelse>
	<a href="default.cfm?contractingpartyonly=true">nur VP anzeigen</a><br>
</cfif>

<cfset request.q_select_reseller = q_select_reseller>

<cfquery name="q_select_top" dbtype="query">
SELECT
	*
FROM
	q_select_reseller
WHERE
	parentkey = ''
;
</cfquery>

<cfoutput query="q_select_top">
	ROOT: #q_select_top.companyname#
	<cfmodule template="dsp_inc_select_items.cfm" entrykey=#q_select_top.entrykey#>
</cfoutput>