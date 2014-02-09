<!--- //

	Module:		Address Book
	Description:Track opening of remote edit mail
	

// --->

<cfset sEntrykey = cgi.PATH_INFO />

<cfset sEntrykey = ReplaceNoCase(sEntrykey, '/', '', 'ALL') />

<cfquery name="q_update_opened" datasource="#request.a_str_db_tools#">
UPDATE
	remoteedit
SET
	dt_opened = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">)
;
</cfquery>

<cfcontent deletefile="no" file="#request.a_str_img_1_1_pixel_location#" type="image/gif">

