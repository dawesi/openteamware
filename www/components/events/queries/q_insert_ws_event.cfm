<cfquery name="q_insert_ws_event" datasource="#request.a_str_db_log#">
INSERT INTO
	webservices_events
	(
	applicationkey,
	clientkey,
	dt_created,
	servicekey,
	handlerkey,
	actionname,
	eventsent,
	objectkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_event_handlers.applicationkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_event_handlers.clientkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_event_handlers.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
	)
;
</cfquery>