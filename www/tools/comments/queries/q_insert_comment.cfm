

<cfquery datasource="#request.a_str_db_tools#" name="q_insert_comment">
INSERT INTO
	comments
	(
	entrykey,
	servicekey,
	objectkey,
	comment,
	dt_created,
	userkey
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmservicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmobjectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.frmcomment)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDatetime(GetUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>