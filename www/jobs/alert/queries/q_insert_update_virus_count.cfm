
<cfset a_dt_today = CreateDate(Year(now()), Month(Now()), Day(Now()))>

<cfquery name="q_select_today_exists" datasource="#request.a_str_db_mailusers#">
SELECT
	COUNT(id) AS count_id
FROM
	virusmailcount
WHERE
	dt_check = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_today)#">
;
</cfquery>

<cfif q_select_today_exists.count_id IS 0>
	<!--- insert --->
	<cftry>
	<cfquery name="q_update" datasource="#request.a_str_db_mailusers#">
	INSERT INTO
		virusmailcount
		(
		dt_check,
		mailcount
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_today)#">,
		1
		)
	;
	</cfquery>
	<cfcatch type="any"> </cfcatch></cftry>
<cfelse>
	<!--- update --->
	<cfquery name="q_insert" datasource="#request.a_str_db_mailusers#">
	UPDATE
		virusmailcount
	SET
		mailcount = mailcount + 1
	WHERE
		dt_check = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_today)#">
	;
	</cfquery>	
</cfif>