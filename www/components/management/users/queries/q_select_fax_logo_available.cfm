
<cfquery name="q_select_fax_logo_available" datasource="#request.a_str_db_tools#">
SELECT
	id
FROM
	faxlogo
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>