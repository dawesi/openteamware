<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	reseller
;
</cfquery>