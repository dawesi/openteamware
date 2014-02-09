<cfquery name="q_select_signup_address" datasource="#request.a_str_db_users#">
SELECT
	emailadr,
	companykey,
	workgroupkey
FROM
	team_invitations
WHERE
	<cfif StructkeyExists(form, 'frmentrykey')>
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
	<cfelse>
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.k#">
	</cfif>
;
</cfquery>