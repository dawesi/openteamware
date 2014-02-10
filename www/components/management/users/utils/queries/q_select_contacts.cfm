<cfquery name="q_select_contacts" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	addressbook
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadDataRequest.userkey#">
;
</cfquery>