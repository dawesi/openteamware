<!--- //

	display on startpage
	
	// --->
	
	
<cfset a_int_recordcount = 10>
	
<cfquery name="q_select_partner_entrykey" datasource="#request.a_str_db_users#">
SELECT
	resellerkey
FROM
	companies
WHERE
	(companies.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.mycompanykey#">)
;
</cfquery>

<cfquery name="q_select_partner_companykey" datasource="#request.a_str_db_users#">
SELECT
	companykey
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_partner_entrykey.resellerkey#">
;
</cfquery>

<cfquery name="q_select_company_news" datasource="#request.a_str_db_tools#" maxrows="#a_int_recordcount#">
SELECT
	companynews.entrykey,
	companynews.title,
	companynews.href,
	companynews.forumid,
	companynews.furthertext,
	companynews.showtimesperuser
FROM
	companynews
WHERE
	(
		(companynews.companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.mycompanykey#">)
		OR
			(
				(companynews.companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_partner_companykey.companykey#">)
				AND
				(companynews.deliver_to_customers_too = 1)
			)
	)
	
	AND
	(
		(companynews.dt_valid_until IS NULL)
		OR
		(companynews.dt_valid_until >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	)
	
ORDER BY
	companynews.topnews,
	companynews.dt_created DESC
;
</cfquery>

<cfif q_select_company_news.recordcount IS 0>
	<!--- no news ... --->
	<cfexit method="exittemplate">
</cfif>

<div class="div_startpage_contentbox_title" style="background-color:#FFCC66; ">
		
	<div class="div_startpage_contentbox_image">
	<img src="/images/news/img_news_32x32.gif" width="32" height="32" hspace="2" vspace="2" border="0">
	</div>		

	<div class="bdashedbottom bdashedtop div_startpage_contentbox_title_text"><cfoutput>#GetLangVal('adm_ph_company_news')#</cfoutput></div>

</div>		

<div class="div_startpage_contentbox_content">

	<ul>
	<cfoutput query="q_select_company_news">
		
		<li><b><a href="#q_select_company_news.href#" target="_blank">#htmleditformat(q_select_company_news.title)#</b></a>
			<cfif Len(q_select_company_news.furthertext) GT 0>
				<br>
				#htmleditformat(q_select_company_news.furthertext)#
			</cfif>
		</li>
	
	</cfoutput>
	</ul>


</div>