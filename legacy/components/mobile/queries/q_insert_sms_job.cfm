
<cfquery name="q_insert_sms_job" datasource="#request.a_str_db_tools#">
INSERT INTO
	faxdejobs
	(
	entrykey,
	userkey,
	senderuserkey,
	companykey,
	dt_created,
	recipient,
	subject,
	dt_time2send,
	messagetype,
	sender,
	jobsource,
	specialaccount
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#createuuid()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recipient#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.body#">,
	<cfif IsDate(arguments.dt_2send)>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(dt_2send)#">,
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
	</cfif>
	1,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.jobsource#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_specialaccount#">
	)
;
</cfquery>