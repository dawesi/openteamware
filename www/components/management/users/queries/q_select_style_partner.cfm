<cfquery name="q_select_style_partner">
SELECT
	style
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_partnerkey#">
;
</cfquery>