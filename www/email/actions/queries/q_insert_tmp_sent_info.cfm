<!--- //

		Module:	Email
	Description:Insert information about sent msg
	

// --->

<cfset a_str_key = CreateUUID() />

<cfquery name="q_insert_tmp_sent_info" datasource="#request.a_str_db_tools#">
INSERT INTO
	sendmailtempinfo
	(
	afrom,
	ato,
	subject,
	cc,
	bcc,
	entrykey,
	destinationfolder,
	dt_created,
	tmpfilename,
	smjobkey,
	sm_action,
	messageid,
	format,
	body
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailfrom#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailto#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailsubject#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailcc#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailbcc#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_key#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmsaveinfolder#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_written_filename#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmjobkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_msgid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmformat#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.mailbody#">
	)
;
</cfquery>

<cfset sReturn_entrykey = a_str_key />

