
<cfquery name="q_select_fax_signature" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	faxsignature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.signature#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>