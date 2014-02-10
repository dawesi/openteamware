

<cfquery name="q_insert_task" datasource="#request.a_str_db_tools#">
INSERT INTO tasks
	(userkey,
	 entrykey,
	 dt_created,
	 dt_lastmodified,
	 dt_due,
	 title,
	 notice,
	 priority,
	 percentdone,
	 categories,
	 status,
	 actualwork,
	 totalwork,
	 lasteditedbyuserkey,
	 assignedtouserkeys,
	 private
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUtcTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUtcTime(now()))#">,
	
	<cfif StructKeyExists(arguments, "due") AND IsDate(arguments.due)>
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.due)#">,
	<cfelse>
	<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
	</cfif>
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.notice#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.percentdone#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#" maxlength="255">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actualwork#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.totalwork#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedtouserkeys#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.private#">
	)
;	
</cfquery>