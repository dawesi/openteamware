
<cfquery name="q_select_fax_signature">
UPDATE
	users
SET
	faxsignature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.signature#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>