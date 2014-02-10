<!--- //

	Module:		Projects
	Description:welcome page, display overview of current projects
	

// --->	
	
<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_projects')) />

<cfinvoke component="#application.components.cmp_projects#" method="GetAllProjects" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset q_select_projects = stReturn.q_select_projects />

<!--- select sub projects ... --->
<cfquery name="q_select_sales_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	project_type = 1
	AND
	closed = 0
;
</cfquery>

<cfquery name="q_select_technical_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	project_type = 2
	AND
	closed = 0
;
</cfquery>

<cfquery name="q_select_common_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	project_type = 0
	AND
	closed = 0
;
</cfquery>

		
<cfquery name="q_select_sum" dbtype="query">
SELECT
	SUM(sales) AS sum_sales
FROM
	q_select_sales_projects
;
</cfquery>
		
			
<cfsavecontent variable="a_str_content">
<table class="table_overview">
  <tr class="tbl_overview_header">
	<cfoutput>
    <td>#GetLangVal('cm_wd_title')#</td>
	<td>#GetLangVal('cm_wd_stage')#</td>
    <td>#GetLangVal('crm_ph_expected_sales')#</td>
	<td>#GetLangVal('cm_wd_contact')#</td>
	<td>#GetLangVal('cm_wd_responsible_person')#</td>
	<td>#GetLangVal('crm_ph_closing_date')#</td>
	<td align="right">#GetLangVal('cm_wd_action')#</td>
	</cfoutput>
  </tr>

<cfoutput query="q_select_sales_projects">
  <tr>
    <td>
		<a href="default.cfm?action=ShowProject&entrykey=#q_select_sales_projects.entrykey#"><img src="/images/si/coins.png" class="si_img" />#htmleditformat(CheckZeroString(q_select_sales_projects.title))#</a>
	</td>
	<td>
		#GetLangVal('crm_wd_sales_stage_' & q_select_sales_projects.stage)#
	</td>
    <td>
		#Val(q_select_sales_projects.sales)# #q_select_sales_projects.currency#
	</td>
	<td>
		<a href="/addressbook/?action=ShowItem&entrykey=#q_select_sales_projects.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_sales_projects.contactkey)#</a>
	</td>
    <td>
		#application.components.cmp_user.GetUsernameByEntrykey(q_select_sales_projects.projectleaderuserkey)#
	</td>
	<td>
		<cfif IsDate(q_select_sales_projects.dt_closing)>
			#LSDateFormat(q_select_sales_projects.dt_closing, request.stUserSettings.default_dateformat)#
		</cfif>
	</td>
	<td align="right">
		<a class="nl" href="default.cfm?action=editproject&entrykey=#q_select_sales_projects.entrykey#"><img src="/images/si/pencil.png" class="si_img" /></a>
		<a class="nl" href="##" onclick="ShowSimpleConfirmationDialog('default.cfm?action=DoDeleteproject&entrykey=#q_select_sales_projects.entrykey#');"><img src="/images/si/delete.png" class="si_img" /></a>
	</td>
  </tr>
</cfoutput>
</table>

<cfquery name="q_select_sum" dbtype="query">
SELECT
	SUM(sales) AS sum_sales
FROM
	q_select_sales_projects
;
</cfquery>
<br /> 
<cfchart format="png" gridlines="true" show3d="false" showlegend="false" title="#GetLangVal('prj_ph_sales_pipeline_total_is')#: #q_select_sum.sum_sales#">
	<cfchartseries type="bar">
		
	<cfloop from="10" to="50" step="10" index="ii">
		
		<cfquery name="q_select_sum" dbtype="query">
		SELECT
			SUM(sales) AS sum_sales
		FROM
			q_select_sales_projects
		WHERE
			stage = <cfqueryparam cfsqltype="cf_sql_integer" value="#ii#">
		;
		</cfquery>
		
		<cfchartdata item="#GetLangVal('crm_wd_sales_stage_' & ii)#" value="#Val(q_select_sum.sum_sales)#">
	</cfloop>
	</cfchartseries>
</cfchart>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<input type="button" class="btn" value="<cfoutput>#GetLangval('cm_wd_new')#</cfoutput>" onclick="GotoLocHref('default.cfm?action=NewProject&type=1');" />
</cfsavecontent>
<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_project_type_1') & ' (' & q_select_sales_projects.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>
<br /> 



<cfsavecontent variable="a_str_content">
<table class="table_overview">
  <tr class="tbl_overview_header">
	<cfoutput>
    <td>#GetLangVal('cm_wd_title')#</td>
	<td>#GetLangVal('cal_wd_begin')#</td>
    <td>#GetLangVal('cal_wd_end')#</td>
	<td>#GetLangVal('cm_wd_contact')#</td>
	<td>#GetLangVal('cm_wd_responsible_person')#</td>
	<td align="right">#GetLangVal('cm_wd_action')#</td>
	</cfoutput>
  </tr>

<cfoutput query="q_select_common_projects">
  <tr>
    <td>
		<a href="default.cfm?action=ShowProject&entrykey=#q_select_common_projects.entrykey#"><img src="/images/si/chart_organisation.png" class="si_img" />#htmleditformat(CheckZeroString(q_select_common_projects.title))#</a>
	</td>
	<td>
		<cfif IsDate(q_select_common_projects.dt_begin)>
			#LSDateFormat(q_select_common_projects.dt_begin, request.stUserSettings.default_dateformat)#
		</cfif>
	</td>
    <td>
		<cfif IsDate(q_select_common_projects.dt_end)>
			#LSDateFormat(q_select_common_projects.dt_end, request.stUserSettings.default_dateformat)#
		</cfif>
	</td>
	<td>
		<a href="/addressbook/?action=ShowItem&entrykey=#q_select_sales_projects.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_sales_projects.contactkey)#</a>
	</td>
    <td>
		#application.components.cmp_user.GetUsernameByEntrykey(q_select_sales_projects.projectleaderuserkey)#
	</td>
	<td align="right">
		<a class="nl" href="default.cfm?action=editproject&entrykey=#q_select_common_projects.entrykey#"><img src="/images/si/pencil.png" class="si_img" /></a>
		<a class="nl" href="##" onclick="ShowSimpleConfirmationDialog('default.cfm?action=DoDeleteproject&entrykey=#q_select_sales_projects.entrykey#');"><img src="/images/si/delete.png" class="si_img" /></a>
	</td>
  </tr>	<!--- 
  <tr>	
    <td colspan="9">
		<img src="/images/space_1_1.gif" class="si_img" />#htmleditformat(q_select_common_projects.description)#
	</td>
  </tr> --->
</cfoutput>
</table>
</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<input type="button" class="btn" value="<cfoutput>#GetLangval('cm_wd_new')#</cfoutput>" onclick="GotoLocHref('default.cfm?action=NewProject&type=0');" />
</cfsavecontent>
<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_project_type_0') & ' (' & q_select_common_projects.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>
<br /> 

<cfquery name="q_select_closed_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	closed = 1
;
</cfquery>

<cfsavecontent variable="a_str_content">

<table class="table_overview">
  <tr class="tbl_overview_header">
	<cfoutput>
    <td>#GetLangVal('cm_wd_title')#</td>
	<td>#GetLangVal('cal_wd_begin')#</td>
    <td>#GetLangVal('cal_wd_end')#</td>
	<td>#GetLangVal('cm_wd_contact')#</td>
	<td>#GetLangVal('cm_wd_responsible_person')#</td>
	<td align="right">#GetLangVal('cm_wd_action')#</td>
	</cfoutput>
  </tr>

<cfoutput query="q_select_closed_projects">
  <tr>
    <td>
		<a href="default.cfm?action=ShowProject&entrykey=#q_select_closed_projects.entrykey#"><img src="/images/si/chart_organisation.png" class="si_img" />#htmleditformat(CheckZeroString(q_select_closed_projects.title))#</a>
	</td>
	<td>
		#FormatDateTimeAccordingToUserSettings(q_select_closed_projects.dt_begin)#
	</td>
    <td>
		#FormatDateTimeAccordingToUserSettings(q_select_closed_projects.dt_end)#
	</td>
	<td>
		<a href="/addressbook/?action=ShowItem&entrykey=#q_select_closed_projects.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_closed_projects.contactkey)#</a>
	</td>
    <td>
		#application.components.cmp_user.GetUsernameByEntrykey(q_select_closed_projects.projectleaderuserkey)#
	</td>
	<td align="right">
		<!--- <a class="nl" href="default.cfm?action=editproject&entrykey=#q_select_closed_projects.entrykey#"><img src="/images/si/pencil.png" class="si_img" /></a> --->
		<a class="nl" href="##" onclick="ShowSimpleConfirmationDialog('default.cfm?action=DoDeleteproject&entrykey=#q_select_sales_projects.entrykey#');"><img src="/images/si/delete.png" class="si_img" /></a>
	</td>
  </tr>	<!--- 
  <tr>	
    <td colspan="9">
		<img src="/images/space_1_1.gif" class="si_img" />#htmleditformat(q_select_common_projects.description)#
	</td>
  </tr> --->
</cfoutput>
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox('Abgeschlossene Projekte (' & q_select_closed_projects.recordcount & ')', '', a_str_content)#</cfoutput>

<cfsavecontent variable="a_str_js">
	function DoDeleteProject(entrykey, title) {
	
		}
</cfsavecontent>
