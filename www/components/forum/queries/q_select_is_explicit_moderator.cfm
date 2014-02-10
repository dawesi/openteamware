<cfquery name="q_select_is_explicit_moderator" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	explicit_moderators
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	forumkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forumkey#">
;
</cfquery>