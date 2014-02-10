<cfquery name="q_select_communities" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,dt_created,userkey,community_name,description,public,lang
FROM
	communities
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>