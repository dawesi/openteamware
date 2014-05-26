<!--- //

	Module:		
	Description:delete various old logdata
	

// --->
	
<!--- // delete old deleted data // --->
	
<cfset a_dt_deleted = DateAdd('d', -90, Now())>
	
<cfquery name="q_delete_old_deleted_data" datasource="#request.a_str_db_log#">
DELETE FROM
	deleteddata
WHERE
	dt_deleted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_deleted)#">
;
</cfquery>

<!--- // delete old edited versions // --->

<cfset a_dt_edited = DateAdd('d', -120, Now())>
	
<cfquery name="q_delete_old_edited_data" datasource="#request.a_str_db_log#">
DELETE FROM
	editeddata
WHERE
	dt_edited < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_edited)#">
;
</cfquery>

<cfquery name="q_optimize_table_editeddata" datasource="#request.a_str_db_log#">
OPTIMIZE TABLE
	editeddata
;
</cfquery>

<!--- // updata clickstream table ... set empty title for older items // --->
	
<cfset a_dt_clickstream = DateAdd('d', -14, Now())>
	
<cfquery name="q_update_clickstream" datasource="#request.a_str_db_log#">
UPDATE
	clickstream
SET
	title = ''
WHERE
	(dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_clickstream)#">)
	AND
	(Length(userkey) > 0)
	AND
	(Length(title) > 0)
;
</cfquery>

<cfquery name="q_optimize_clickstream" datasource="#request.a_str_db_log#">
OPTIMIZE TABLE
	clickstream
;
</cfquery>

<!--- // outlooksync log // --->

<cfset a_dt_olsync = DateAdd('d', -21, Now())>
<cfquery name="q_delete_old_olsync" datasource="#request.a_Str_Db_log#">
DELETE FROM
	outlooksync_app
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_olsync)#">
;
</cfquery>

<cfquery name="q_optimize_olsync" datasource="#request.a_Str_Db_log#">
OPTIMIZE TABLE
	outlooksync_app
;
</cfquery>

<!--- data replication ... --->
<cfset a_dt_backup = DateAdd('d', -21, Now()) />

<cfquery name="q_delete_old_datareplication_logs" datasource="#request.a_str_db_backup#">
DELETE FROM
	datarep_log
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_backup)#">
;
</cfquery>


