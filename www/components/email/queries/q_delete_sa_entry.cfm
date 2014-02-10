

<cfquery name="q_delete_sa_entry" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	spamassassin
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>