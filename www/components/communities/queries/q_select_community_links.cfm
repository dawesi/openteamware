<cfquery name="q_select_community_links" datasource="#request.a_str_db_tools#">
SELECT
	communitykey,
	servicekey,
	objectkey,
	dt_created,
	entrykey,
	object_title,
	object_description
FROM
	community_links
WHERE
	communitykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.communitykey#">
;
</cfquery>