

<cfquery name="q_select_email_aliases" datasource="#request.a_str_db_users#">
SELECT
	dt_created,destinationaddress,aliasaddress,createdbyuserkey,companykey
FROM
	emailaliases
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>