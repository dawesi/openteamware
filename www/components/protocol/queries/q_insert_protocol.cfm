<cfquery name="q_insert_protocol">
INSERT INTO
	action_protocol
	(
	userkey,
	createdbyuserkey,
	dt_created,
	servicekey,
	objectkey,
	action,
	information
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.message#">
	)
;	
</cfquery>