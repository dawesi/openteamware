<!--- //

	Component:	Security
	Function:	AddSwitchUserRelation
	Description:Add relation record in DB
	

// --->

<cfquery name="q_insert_switch_user_relation.cfm" datasource="#request.a_str_db_users#">
INSERT INTO
	switchuserrelations
	(
	entrykey,
	dt_created,
	createdbyuserkey,
	userkey,
	otheruserkey,
	otherpassword_md5,
	comment
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(Now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.otheruserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.otherpassword_md5#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">
	)
;
</cfquery>


