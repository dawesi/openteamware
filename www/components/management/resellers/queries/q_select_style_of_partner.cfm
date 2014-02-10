<cfquery name="q_select_style_of_partner" datasource="#request.a_str_db_users#">
SELECT
	style
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>