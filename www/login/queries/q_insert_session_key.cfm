<!--- //



	insert new session key

	

	// --->



<cfparam name="InsertSessionKeyRequest.sessionkey" type="string" default="">



<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "session"
	entryname = "timeout"
	defaultvalue1 = "30">	

<cfset a_int_timeout = a_str_person_entryvalue1>

	

<cfset Variables.a_dt_timeout = DateAdd("n", a_int_timeout, now())>



<cfquery name="q_insert_session_key" datasource="#request.a_str_db_users#">
INSERT INTO
	sessionkeys
	(userid,userkey,dt_lastcontact,id,dt_expires)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertSessionKeyRequest.sessionkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(Variables.a_dt_timeout)#">
	)
;
</cfquery>