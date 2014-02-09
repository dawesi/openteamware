<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.entrykey" type="string">

<cfinvoke component="#application.components.cmp_content#" method="GetCompanyNews" returnvariable="q_select_news">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfquery name="q_select_news" dbtype="query">
SELECT
	*
FROM
	q_select_news
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<!---<cfdump var="#q_select_news#">--->

<cfif q_select_news.recordcount IS 0>
	News not found.
	<cfexit method="exittemplate">
</cfif>

<cfset CreateOrEditNews.action = 'edit'>
<cfset CreateOrEditNews.query = q_select_news>

<cfinclude template="dsp_inc_create_or_edit_news.cfm">
