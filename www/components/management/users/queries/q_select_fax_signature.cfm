
<cfquery name="q_select_fax_signature">
SELECT
	faxsignature
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>