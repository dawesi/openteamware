<cfquery name="q_select_mailspeed_folders_count" datasource="#request.a_str_db_email#">
SELECT
	COUNT(id) AS count_id
FROM
	folders
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(q_select_userid_by_username.userid)#">
;
</cfquery>