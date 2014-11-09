<!--- //

	Module:		jobs / cleanup / logs
	Description:Delete old log items ...


// --->

<cfset a_dt_check_adminactions = DateAdd('d', -90, Now())>
<cfset a_dt_check_deleteddata = DateAdd('d', -90, Now())>
<cfset a_dt_check_editeddata = DateAdd('d', -90, Now())>
<cfset a_dt_check_publicsharestraffic = DateAdd('d', -90, Now())>

<!--- admin actions --->
<cfquery name="q_delete_old_admin_actions">
DELETE FROM
	adminactions
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_adminactions)#">
;
</cfquery>

<!--- deleteddata --->
<cfquery name="q_delete_old_admin_actions">
DELETE FROM
	deleteddata
WHERE
	dt_deleted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_deleteddata)#">
;
</cfquery>

<!--- editeddata --->
<cfquery name="q_delete_old_admin_actions">
DELETE FROM
	editeddata
WHERE
	dt_edited < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_editeddata)#">
;
</cfquery>