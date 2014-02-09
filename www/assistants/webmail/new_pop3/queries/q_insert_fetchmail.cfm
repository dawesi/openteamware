
<!--- insert into the fetchmail table ... --->

<cfif ADelMsgOnServer is 1>
	<cfset a_int_leave = 0>
<cfelse>
	<cfset a_int_leave = 1>
</cfif>

<cfquery name="q_insert_fetchmail_entry" datasource="#request.a_str_db_mailusers#">
INSERT INTO emailaccount
(userid,accountid,email,leavemessages,host,hosttype,username,password,port,minterval,
nextfetch,emailaddresstocheck,active)
VALUES
(<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_accountid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_leave#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPOPServer#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpopusername#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpoppassword#">,
110,
<cfqueryparam cfsqltype="cf_sql_integer" value="30">,
<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmEmail#">,
1);
</cfquery>