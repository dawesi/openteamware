
<cfif StructKeyExists(request, 'q_company_admin') AND request.q_company_admin.recordcount IS 1 AND (IsDefined("url.companykey") OR IsDefined("url.frmcompanykey"))>

	<cfquery name="q_select_resellerkey" datasource="#request.a_str_db_users#">
	SELECT
		resellerkey
	FROM
		companies
	WHERE
		<cfif IsDefined("url.companykey")>
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
		<cfelse>
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.frmcompanykey#">
		</cfif>
	;
	</cfquery>
	
	<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
	SELECT
		companyname,street,zipcode,city,telephone,emailadr,customercontact
	FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_resellerkey.resellerkey#">
	;
	</cfquery>

	<div class="mischeader" style="padding:4px;border-bottom: orange solid 1px;">
	
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td>
			<img src="/images/si/world.png" class="si_img" />
		</td>
		<td>
			<b><cfoutput>#GetLangVal('adm_ph_your_partner_for_questions')#</cfoutput>:</b>
			<br>
			<a href="default.cfm?action=partnerfeedbackform"><cfoutput query="q_select_reseller">
			 #ReplaceNoCase(q_select_reseller.customercontact, chr(13), '<br>', 'ALL')#</a>
			<br>
			<a href="mailto:#q_select_reseller.emailadr#">#q_select_reseller.emailadr#</a>
			</cfoutput>		
		</td>
	  </tr>
	</table>
	</div>
</cfif>

<div style="padding:6px;">
<a href="https://www.openTeamWare.com/rd/about/" target="_blank"><cfoutput>#GetLangVal('hpg_wd_about')#</cfoutput></a>
</div>