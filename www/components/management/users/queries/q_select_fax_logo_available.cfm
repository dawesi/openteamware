
<cfquery name="q_select_fax_logo_available">
SELECT
	id
FROM
	faxlogo
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>