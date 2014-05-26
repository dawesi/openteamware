<!--- //

	Module:		Background
	Description:clean up data old replication backups (older than 21 days)
	

// --->

<cfquery name="q_select_backups" datasource="#request.a_str_Db_backup#">
SELECT
	*
FROM
	datarep_backups
WHERE
	dt_started < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(DateAdd('d', -14, now()))#">
ORDER BY
	dt_started
;
</cfquery>

<cfoutput query="q_select_backups" startrow="1" maxrows="150">

	<cfset sFilename = '/mnt/filestorage/datareplication/' & q_select_backups.companykey & '/' & q_select_backups.entrykey & '.tar.gz'>

	#q_select_backups.dt_started# #sFilename# #FileExists(sFilename)#<br><br>
	
	<cfif FileExists(sFilename)>
		<cffile action="delete" file="#sFilename#">
	</cfif>
	
	<cfquery name="q_delete_item" datasource="#request.a_str_db_backup#">
	DELETE FROM
		datarep_backups
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_backups.companykey#">
		AND
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_backups.entrykey#">
	;
	</cfquery>
</cfoutput>

