<cfquery name="q_select_community_links_of_object" datasource="#request.a_str_db_tools#">
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
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
;
</cfquery>