<cfquery name="q_select_mailprofile" datasource="#request.a_str_db_users#">
SELECT
	entrykey,dt_created,createdbyuserkey,accesstype,imaphost,imapusername,imappassword
FROM
	mailprofiles
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>