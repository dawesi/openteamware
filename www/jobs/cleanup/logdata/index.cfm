<!--- //

	Module:
	Description:delete various old logdata


// --->

<!--- // delete old deleted data // --->

<cfset a_dt_deleted = DateAdd('d', -90, Now())>

<cfquery name="q_delete_old_deleted_data">
DELETE FROM
	deleteddata
WHERE
	dt_deleted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_deleted)#">
;
</cfquery>

<!--- // delete old edited versions // --->

<cfset a_dt_edited = DateAdd('d', -120, Now())>

<cfquery name="q_delete_old_edited_data">
DELETE FROM
	editeddata
WHERE
	dt_edited < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_edited)#">
;
</cfquery>

<cfquery name="q_optimize_table_editeddata">
OPTIMIZE TABLE
	editeddata
;
</cfquery>

<!--- // outlooksync log // --->

<cfset a_dt_olsync = DateAdd('d', -21, Now())>
<cfquery name="q_delete_old_olsync">
DELETE FROM
	outlooksync_app
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_olsync)#">
;
</cfquery>

<cfquery name="q_optimize_olsync">
OPTIMIZE TABLE
	outlooksync_app
;
</cfquery>
