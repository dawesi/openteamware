<!--- //

	Module:		Framework/Jobs
	Description:Execute backup
	

// --->
<cfsetting requesttimeout="40000">


<!--- execute backups ... --->
<cftry>

<!--- load jobs ... --->
<cfquery name="q_select_jobs" datasource="#request.a_str_db_backup#">
SELECT
	companykey,username
FROM
	 datarep_users
WHERE
	enabled = 1
ORDER BY
	id DESC
;
</cfquery>

<cfloop query="q_select_jobs">

<!--- delete old backups ... --->



<cfset a_begin = GetTickCount()>
<cfinvoke component="/components/backup_export/cmp_backup_export" method="BackupWholeCompany" returnvariable="stReturn">
	<cfinvokeargument name="companykey" value="#q_select_jobs.companykey#">
</cfinvoke>

</cfloop>

<cfcatch type="any">
	
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="backup exception" type="html">
		<cfdump var="#cfcatch#">
	</cfmail>

</cfcatch>

</cftry>


