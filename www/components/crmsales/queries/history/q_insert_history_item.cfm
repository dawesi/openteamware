<!--- //

	Module:		CRMSALES
	Function:	CreateHistoryItem
	Description:create a history item
	

// --->

<cfquery name="q_insert_history_item" datasource="#request.a_str_db_crm#">
INSERT INTO
	history
	(
	entrykey,
	servicekey,
	objectkey,
	subject,
	comment,
	projectkey,
	dt_created,
	dt_created_internally,
	dt_lastmodified,
	item_type,
	createdbyuserkey,
	linked_servicekey,
	linked_objectkey,
	hash_unique,
	categories
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sReturn_entryky#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(arguments.dt_created)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.item_type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.linked_servicekey#">,	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.linked_objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_hash_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#">
	)
;
</cfquery>

