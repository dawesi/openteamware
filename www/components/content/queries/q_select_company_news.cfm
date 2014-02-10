<cfquery name="q_select_company_news" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,title,href,forumid,showtimesperuser,dt_valid_until,furthertext,
	deliver_to_customers_too,topnews
FROM
	companynews
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>