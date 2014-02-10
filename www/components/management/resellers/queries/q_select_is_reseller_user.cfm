
<cfquery name="q_select_is_reseller_user" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	resellerusers
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>