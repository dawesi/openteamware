<!--- //

	Module:		Check if the sync status is OK
	Action:		
	Description:	
	

// --->

<!--- last update must not be older than 5 minutes! --->
<cfset a_dt_check_lastupdate = DateAdd('n', -5, Now()) />

<cfquery name="q_select_speedmail_folder_sync_status" datasource="#request.a_str_db_email#">
SELECT
	folders.syncstatus,
	folders.id,
	mailspeed_lastupdate.dt_lastupdate
FROM
	folders
WHERE
	folders.account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.accessdata.a_str_imap_username)#">
	AND
	folders.foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
	AND
	mailspeed_lastupdate.dt_lastupdate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check_lastupdate)#">
;
</cfquery>
