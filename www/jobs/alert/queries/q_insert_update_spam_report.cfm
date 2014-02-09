
<cfset a_dt_today = CreateDate(Year(now()), Month(Now()), Day(Now()))>

<cfquery name="q_select_today_exists" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	spamguardreport
WHERE
	dt_check = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_today)#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_accountid.userkey#">
;
</cfquery>

<cfif q_select_today_exists.count_id IS 0>
	<!--- insert --->
	<cftry>
	<cfquery name="q_update" datasource="#request.a_str_db_tools#">
	INSERT INTO
		spamguardreport
		(
		dt_check,
		userkey,
		
		numberofmails
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_today)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_accountid.userkey#">,
		1
		)
	;
	</cfquery>
	<cfcatch type="any">CFCATCH </cfcatch></cftry>
<cfelse>
	<!--- update --->
	<cfquery name="q_insert" datasource="#request.a_str_db_tools#">
	UPDATE
		spamguardreport
	SET
		numberofmails = numberofmails + 1
	WHERE
		dt_check = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_today)#">
		AND
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_accountid.userkey#">
	;
	</cfquery>	
</cfif>