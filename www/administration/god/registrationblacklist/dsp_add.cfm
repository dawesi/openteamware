<!--- add now --->
<cfset a_str_address = lcase(form.frmaddress)>

<cftry>
<cfquery name="q_insert" datasource="#request.a_str_db_users#">
INSERT INTO
	registrationblacklist
	(
	emailadr,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_address#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	)
;	
</cfquery>
<cfcatch type="any">
</cfcatch></cftry>