<cfquery name="q_select_forums_of_a_company" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,forumname,description,dt_created,createdbyuserkey,dt_lastposting,announcementforum
FROM
	foren
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
ORDER BY
	forumname
;
</cfquery>