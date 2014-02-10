<!--- //

	check if already exists ...
	
	// --->
	
<cfquery name="q_select_re_job_exists" datasource="#GetDSName('SELECT')#">
SELECT
	entrykey
FROM
	remoteedit
WHERE
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfif q_select_re_job_exists.recordcount IS 0>
<cfquery name="q_insert_re_job" datasource="#GetDSName('INSERT')#">
INSERT INTO
	remoteedit
(
	objectkey,
	entrykey,
	userkey,
	dt_created,
	languageid
)
	VALUES
(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_job_key#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_lang_of_contact)#">
)
;
</cfquery>
<cfset a_bol_new = true>
<cfelse>
	
	<cfif arguments.forcenewsend>
		<!--- update create date --->
		<cfquery name="q_update_re_job_create_date" datasource="#GetDSName('UPDATE')#">
		UPDATE
			remoteedit
		SET
			dt_created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
		WHERE
			objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
			AND
			userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
		;
		</cfquery>
	
	</cfif>

	<cfset a_str_job_key = q_select_re_job_exists.entrykey>
	<cfset a_bol_new = false>
</cfif>