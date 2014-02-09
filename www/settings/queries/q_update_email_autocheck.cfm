<!--- //
	update autocheck
	// --->


<!--- delete old entry ... --->
<cfquery name="q_delete_fetchmail_entry" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	emailaccount
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
AND
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
AND
	accountid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmid#">
;
</cfquery>

	
<cfif val(form.frmAutoCheckEachMinutes) gt 0>

	<cfif form.frmdeletemsgonserver is 0>
		<cfset a_int_leave = 1>
	<cfelse>
		<cfset a_int_leave = 0>
	</cfif>
	
	<!--- insert now ... --->
	<cfquery name="q_insert_fetchmail_entry" datasource="#request.a_str_db_mailusers#">
	INSERT INTO
		emailaccount
		(
		userid,
		userkey,
		accountid,
		email,
		leavemessages,
		host,
		hosttype,
		username,
		password,
		port,
		minterval,
		nextfetch,
		emailaddresstocheck,
		emailaccount.ssl,
		active
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmid)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_leave)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3server#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3username#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3password#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmpop3port#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmAutoCheckEachMinutes#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmemailaddress#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmcbusessl)#">,
		1		
		)
	;
	</cfquery>

</cfif>