


<!--- 

	insert into pop3_data

	...
	
	--->
	
<cfquery name="q_insert_pop3_data" datasource="#request.a_str_db_users#">
INSERT INTO
	pop3_data
	(
	userid,
	userkey,
	entrykey,
	pop3server,
	pop3username,
	pop3password,
	deletemsgonserver,
	confirmed,
	emailadr,
	origin,
	port,
	usessl,
	displayname)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.server#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.emailaddress)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">,
	1,
	1,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.emailaddress)#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.port#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.usessl#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.displayname#">
	)
;	
</cfquery> 