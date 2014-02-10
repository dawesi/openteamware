
<cfquery name="q_select_forwarding" datasource="#request.a_str_db_mailusers#">
SELECT
	id,destination,leavecopy
FROM
	forwarding
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>