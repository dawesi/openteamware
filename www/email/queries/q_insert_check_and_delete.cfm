<!--- //

	insert into check and delete ...
	
	a) insert into emailaccounts table
	
	b) insert into scheduleddelete ...
	
	// --->
	
<!--- account id --->
<cfparam name="InsertCheckAndDelete.id" type="numeric" default="0">
<!--- when should the address be removed ... --->
<cfparam name="InsertCheckAndDelete.Minutes" type="numeric" default="30">
<!--- holding the properties of the email account --->
<cfparam name="InsertCheckAndDelete.query" type="query">

<cfset a_dt_delete = DateAdd("n", InsertCheckAndDelete.Minutes, now())>

<cfquery name="q_insert_schedulesdeleteemailaccounts" datasource="#request.a_str_db_mailusers#">
INSERT INTO schedulesdeleteemailaccounts
(userid,accountid,dt_delete)
VALUES
(<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertCheckAndDelete.id#">,
<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_delete)#">);
</cfquery>


<!--- load data from original ... --->


<cfquery name="q_insert_fetchmail_entry" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	emailaccount
	(
	userkey,
	userid,
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
	active
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertCheckAndDelete.id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
	
	<cfif InsertCheckAndDelete.query.deletemsgonserver IS 1>
		0,
	<cfelse>
		1,
	</cfif>
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertCheckAndDelete.query.POP3Server#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertCheckAndDelete.query.pop3username#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertCheckAndDelete.query.pop3password#">,
	110,
	<cfqueryparam cfsqltype="cf_sql_integer" value="60">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertCheckAndDelete.query.emailadr#">,
	1
	)
;
</cfquery>