<!--- //

	Module:		Email
	Description:Insert lookup job ...
	

// --->

<cfquery name="q_insert_lookup_job" datasource="#request.a_str_db_tools#">
INSERT INTO
	lookupuidjobs
	(
	username,
	messageid,
	status,
	reference_ids,
	fullfoldername
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.a_str_msgid#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_current_msg_references#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmsaveinfolder#">
	)
;
</cfquery>

