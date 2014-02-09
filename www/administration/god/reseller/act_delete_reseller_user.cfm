<!--- delete a reseller --->

<cfdump var="#url#">

<cfquery name="q_delete" datasource="#request.a_str_db_users#">
DELETE FROM
	resellerusers
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userkey#">
;
</cfquery>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">