<!--- //

	Module:		Do the export
	Action:		
	Description:	
	

// --->

<cfsetting enablecfoutputonly="false" requesttimeout="20000">

<cfset a_cmp_export = CreateObject( 'component', '/components/backup_export/cmp_backup_export' ) />

<cfset request.A_STR_DATAREP_LOG_COMPANYKEY = request.stSecurityContext.mycompanykey />
<cfset request.A_STR_DATAREP_LOG_USERKEY = request.stSecurityContext.myuserkey />
<cfset request.A_STR_DATAREP_LOG_JOBKEY = CreateUUID() />

<cfset stReturn = a_cmp_export.BackupUserAccountData( userkey = request.stSecurityContext.myuserkey ) />

<cfif NOT stReturn.result>
	<h4>Export fehlgeschlagen. Bitte kontaktieren Sie feedback@openTeamware.com!</h4>
	
	<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="export FAILURE #request.stSecurityContext.myusername#" type="html">
		<cfdump var="#stReturn#">
	</cfmail>
	
	<cfexit method="exittemplate">
	
</cfif>

<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="export SUCCESS #request.stSecurityContext.myusername#" type="html">
	<cfdump var="#stReturn#">
</cfmail>

<cfset a_str_downloadkey = CreateUUID() />

<cfquery name="q_insert_dl_link" datasource="#request.a_str_db_tools#">
INSERT INTO
	download_links
	(
	filelocation,
	entrykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#stReturn.USER_BACKUP_ARCHIVE#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_downloadkey#">
	)
;
</cfquery>


<cfset a_str_url = "/tools/download/dl.cfm?dl_entrykey=#a_str_downloadkey#&source=#GetFileFromPath( stReturn.USER_BACKUP_ARCHIVE )#&contenttype=#urlencodedformat( 'application/unknown ' )#&filename=#urlencodedformat( 'archiv ' & request.stSecurityContext.myusername & '.tar.gz' )#&app=#urlencodedformat(application.applicationname)#" />


<!--- <cfmail from="feedback@openTeamware.com" to="#request.stSecurityContext.myusername#" subject="Downloadlink fuer Archiv-Datei" type="html">
<html>
	<head>
		<title>Download-Link</title>
	</head>
<body>
Guten Tag!
<br /><br />
<a href="https://www.openTeamware.com#a_str_url#" target="_blank">Klicken Sie bitte hier, um den Download nun zu starten!</a>
<br /><br />
Einen schonen Tag wuenscht<br />
das openTeamware.com Team
</body>
</html>
</cfmail> --->

<cflocation addtoken="yes" url="#a_str_url#">
