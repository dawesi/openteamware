
<cfparam name="url.entrykey" type="string" default="">

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	assignedtoreseller = 1
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">