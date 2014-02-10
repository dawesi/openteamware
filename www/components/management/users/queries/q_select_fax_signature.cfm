
<cfquery name="q_select_fax_signature" datasource="#request.a_str_db_users#">
SELECT
	faxsignature
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>