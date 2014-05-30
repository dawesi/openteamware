<!--- //

	Module:		Open Tracking of Mailing tool
	Description: 
	

// --->

<cfset a_str_path_info = cgi.PATH_INFO />

<cfset a_str_path_info = ReplaceNoCase(a_str_path_info, 'spacer.gif', '') />
<cfset a_str_path_info = ReplaceNoCase(a_str_path_info, '/', '', 'ALL') />

<!--- now we've got the entrykey --->
<cfquery name="q_update_opened">
UPDATE
	newsletter_recipients
SET
	opened = 1,
	dt_opened = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	open_ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_path_info#">
;
</cfquery>

<cfcontent file="#request.a_str_img_1_1_pixel_location#" type="image/gif" deletefile="no">


