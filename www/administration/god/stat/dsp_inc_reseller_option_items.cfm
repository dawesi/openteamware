<cfparam name="attributes.entrykey" type="string" default="">
<cfparam name="attributes.level" type="numeric" default="0">

<cfquery name="q_select_items" dbtype="query">
SELECT
	*
FROM
	request.q_select_reseller
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrykey#">
;
</cfquery>

<cfoutput query="q_select_items">
	<option value="#q_select_items.entrykey#"><cfloop from="1" to="#(attributes.level * 2)#" index="ii">&nbsp;</cfloop>#q_select_items.companyname#</option>
	<cfmodule template="dsp_inc_reseller_option_items.cfm" entrykey=#q_select_items.entrykey# level=#(attributes.level+1)#>
</cfoutput>