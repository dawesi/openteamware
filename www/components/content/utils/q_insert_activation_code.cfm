<!--- insert the activation code --->
<cfset a_str_code = ''>

<cfloop from="1" to="5" index="ii">
	<cfset a_int_num_or_char = RandRange(0,3)>
	
	<cfif a_int_num_or_char LTE 2>
		<cfset a_str_code = a_str_code & Chr(RandRange(49,57))>
	<cfelse>
		<cfset a_str_code = a_str_code & Chr(RandRange(97,122))>
	</cfif>
	
</cfloop>

<cfquery name="q_insert_code" datasource="#request.a_str_db_users#">
INSERT INTO
	activatecodes
	(
	companykey,
	code,
	dt_created,
	entrykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_code#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">
	)
;
</cfquery>