<cfparam name="SelectCompanyNewsRequest.SelectTopNewsOnly" type="numeric" default="0">

<cfif SelectCompanyNewsRequest.SelectTopNewsOnly IS 1>
	<cfset a_int_recordcount = 1>
<cfelse>
	<cfset a_int_recordcount = 99>
</cfif>

<cfquery name="q_select_news" datasource="#request.a_str_db_tools#" maxrows="#a_int_recordcount#">
SELECT
	entrykey,title,href,forumid,showtimesperuser
FROM
	companynews
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.mycompanykey#">
	AND
	(
		dt_valid_until IS NULL
		OR
		dt_valid_until > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	)
	
	<cfif SelectCompanyNewsRequest.SelectTopNewsOnly IS 1>
		AND (topnews = 1)
	</cfif>
ORDER BY
	topnews,dt_created
;
</cfquery>