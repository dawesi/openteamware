<!--- //

	Module:		CRMsales / Reports
	Action:		Reports
	Description: 
	

// --->

<cfset SetHeaderTopInfoString(GetLangVal('crm_wd_reports')) />

<cfinvoke component="#application.components.cmp_crm_reports#" method="GetDefaultReports" returnvariable="q_select_default_reports">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>


<cfsavecontent variable="a_str_content">
	<div style="padding:8px; ">
	<cfoutput>#GetLangVal('crm_ph_default_reports_hint')#</cfoutput>
	</div>
	
	<table class="table table-hover">
	  <tr class="tbl_overview_header">
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('crm_ph_report_last_executed')#</cfoutput>
		</td>
	  </tr>
	<cfoutput query="q_select_default_reports">
	
		<cfset sEntrykey_lang_db = ReplaceNoCase(q_select_default_reports.entrykey, '-', '', 'ALL')>
	  <tr>
		<td class="bb">
			<cfset a_str_report_title = GetLangVal('crm_ph_default_report_name_' & sEntrykey_lang_db)>
			<a style="font-weight:bold;" href="index.cfm?action=GenerateReport&entrykey=#q_select_default_reports.entrykey#">#si_img('report')# #htmleditformat(CheckZeroString(a_str_report_title))#</a>
		</td>
		<td class="bb">
			#htmleditformat(GetLangVal('crm_ph_default_report_description_' & sEntrykey_lang_db))#
			<!---#htmleditformat(q_select_default_reports.description)#--->
			&nbsp;
		</td>
		<td class="bb">
		
			<!--- <cfif q_select_tables.recordcount GT 0>
			
				<cfquery name="q_select_last_report" dbtype="query" maxrows="1">
				SELECT
					*
				FROM
					q_select_tables
				WHERE
					reportkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_default_reports.entrykey#">
				ORDER BY
					dt_created DESC
				;
				</cfquery>
			
			<cfelse>
				<cfset q_select_last_report = QueryNew('dummy')>
			</cfif>
			
			<cfif q_select_last_report.recordcount IS 1>
				#LsDateFormat(q_select_last_report.dt_created, request.stUserSettings.default_dateformat)# #TimeFormat(q_select_last_report.dt_created, request.stUserSettings.default_timeformat)#
				<br>
				#htmleditformat(q_select_last_report.description)#
				<br>
				<a href="../database/index.cfm?action=ViewTable&table_entrykey=#q_select_last_report.entrykey#">#GetLangVal('crm_ph_report_display_now')#</a>
			<cfelse>
				&nbsp;
			</cfif> --->
			
		</td>
	  </tr>
	</cfoutput>
	<!--- add report Product development and Travelling report item --->
	<cfoutput>
	<tr>
		<td class="bb">
			<a style="font-weight:bold;" href="reports/productdevelopment.cfm?format=PDF">#si_img('report')# #GetLangVal('adrb_wd_reportname_pd')#</a>
			
			<a href="reports/productdevelopment.cfm?format=Excel">#si_img('page_white_excel')#</a>
		</td>
		<td class="bb">
			#GetLangVal('adrb_wd_reportname_description_pd')#
		</td>
		<td class="bb">
			
		</td>
	  </tr>
	  <tr>
		<td class="bb">
			<a style="font-weight:bold;" href="reports/travelling.cfm">#si_img('report')# #GetLangVal('adrb_wd_reportname_tr')#</a>
			
			<a href="reports/travelling.cfm?format=Excel">#si_img('page_white_excel')#</a>
		</td>
		<td class="bb">
			#GetLangVal('adrb_wd_reportname_description_tr')#
		</td>
		<td class="bb">
			
		</td>
	  </tr>
	</table>
	</cfoutput>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_default_reports'), '', a_str_content)#</cfoutput>

<!--- 
<br /><br />
  
<cfsavecontent variable="a_str_content">
	<table class="table table-hover">
	  	<tr class="tbl_overview_header">
			<td>
				<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_created')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
			</td>
		</tr>
		<cfoutput query="q_select_tables">
		<tr>
			<td>
				<a href="../database/index.cfm?action=ViewTable&table_entrykey=#q_select_tables.entrykey#">#q_select_tables.tablename#</a>
			</td>
			<td>
				 #LsDateFormat(q_Select_tables.dt_Created, request.stUserSettings.default_dateformat)# #TimeFormat(q_Select_tables.dt_Created, request.stUserSettings.default_timeformat)#
			</td>
			<td>
				#htmleditformat(q_select_tables.description)#
			</td>
		</tr>
		</cfoutput>
		</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_reports_lately_executed'), '', a_str_content)#</cfoutput> --->
