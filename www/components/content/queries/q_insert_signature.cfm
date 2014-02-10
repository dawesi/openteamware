<cfquery name="q_insert_signature" datasource="#request.a_str_db_tools#">
INSERT INTO
	email_signatures
	(
	userkey,
	title,
	dt_created,
	entrykey,
	email_adr,
	sig_type,
	sig_data
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.title)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email_adr#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.format#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sig_data#">	
	)
;
</cfquery>

<!--- check count of this type of signature ... if just one, make this signature
	the default signature --->

<cfquery name="q_select_count_of_this_type" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	email_signatures
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	sig_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.format#">
;
</cfquery>

<cfif q_select_count_of_this_type.count_id IS 1>

	<cfquery name="q_update_set_default_signature" datasource="#request.a_str_db_tools#">
	UPDATE
		email_signatures
	SET
		default_sig = 1
	WHERE
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
		AND
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	;
	</cfquery>

</cfif>