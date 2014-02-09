<!--- // 



	update the session key ... 

	

	update the sessionkeys table with the custom timeout	

	

	// --->

	

<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "session"
	entryname = "timeout"
	defaultvalue1 = "30">	

<cfset a_int_timeout = a_str_person_entryvalue1>
	

<cfset Variables.a_dt_timeout = DateAdd("n", a_int_timeout, now())>

<!--- update now ... --->

<cfquery name="q_update_session_key" datasource="#request.a_str_db_users#">
UPDATE
	sessionkeys
SET
	dt_expires = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(Variables.a_dt_timeout)#">,
	dt_lastcontact = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(Now())#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>