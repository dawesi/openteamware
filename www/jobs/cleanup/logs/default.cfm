<!--- //

	Module:		jobs / cleanup / logs
	Description:Delete old log items ...
	

	
	
	move old clickstream to history ...
	
// --->

<cfset a_dt_check_clickstream = DateAdd('d', -14, Now())>
<cfset a_dt_check_adminactions = DateAdd('d', -90, Now())>
<cfset a_dt_check_deleteddata = DateAdd('d', -90, Now())>
<cfset a_dt_check_editeddata = DateAdd('d', -90, Now())>
<cfset a_dt_check_publicsharestraffic = DateAdd('d', -90, Now())>

<!--- admin actions --->
<cfquery name="q_delete_old_admin_actions" datasource="#request.a_str_db_log#">
DELETE FROM
	adminactions
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_adminactions)#">
;
</cfquery>

<!--- deleteddata --->
<cfquery name="q_delete_old_admin_actions" datasource="#request.a_str_db_log#">
DELETE FROM
	deleteddata
WHERE
	dt_deleted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_deleteddata)#">
;
</cfquery>

<!--- editeddata --->
<cfquery name="q_delete_old_admin_actions" datasource="#request.a_str_db_log#">
DELETE FROM
	editeddata
WHERE
	dt_edited < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_editeddata)#">
;
</cfquery>

<!--- storage.publictraffic --->
<cfquery name="q_delete_old_admin_actions" datasource="#request.a_str_db_tools#">
DELETE FROM
	publicshares_traffic
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_publicsharestraffic)#">
;
</cfquery>

