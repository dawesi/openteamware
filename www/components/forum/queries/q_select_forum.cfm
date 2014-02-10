<cfquery name="q_select_forum" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,forumname,description,dt_created,createdbyuserkey,dt_lastposting,announcementforum
FROM
	foren
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>