<!--- //

	Component:	CRMSales
	Function:	GetItemActivitiesAndData
	Description:Display projects assigned to certain contacts


// --->


<cfset a_struct_filter.contactkeys = arguments.contactkeys />
<cfset a_struct_filter.active_only = true />

<cfinvoke component="#application.components.cmp_projects#" method="GetAllProjects" returnvariable="a_struct_projects">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_projects = a_struct_projects.q_select_projects />

<cfset stReturn.recordcount = q_select_projects.recordcount />

<cfif q_select_projects.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfif arguments.usersettings.device.type IS 'pda'>
	<cfset a_str_td_break = ' / ' />
	<cfset a_int_shortenstring = 20 />
<cfelse>
	<cfset a_str_td_break = '</td><td>' />
	<cfset a_int_shortenstring = 50 />
</cfif>

<cfquery name="q_select_common_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	project_type = 0
;
</cfquery>

<cfquery name="q_select_service_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	project_type = 2
;
</cfquery>

<cfquery name="q_select_sales_projects" dbtype="query">
SELECT
	*
FROM
	q_select_projects
WHERE
	project_type = 1
;
</cfquery>

<cfsavecontent variable="sReturn">
<!--- // start with sales projects // --->
<cfif q_select_sales_projects.recordcount GT 0>
<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td width="25%"><cfoutput>#GetLangVal('prj_ph_project_type_1')# (#q_select_projects.recordcount#)</cfoutput></td>
		<td width="25%"><cfoutput>#GetLangVal('crm_ph_expected_sales')#</cfoutput></td>
		<td width="25%">
			<cfoutput>
			#GetLangVal('cm_wd_stage')# / #GetLangVal('cm_ph_probability')#
			</cfoutput>
		</td>
		<td width="25%"><cfoutput>

			<cfif ListLen(arguments.contactkeys) GT 1>
				#GetLangVal('cm_wd_contact')# /
			</cfif>

			#GetLangVal('crm_ph_closing_date')# / #GetLangVal('cm_wd_responsible_person')#</cfoutput></td>
	</tr>
	<cfoutput query="q_select_sales_projects">
	<tr>
		<td>
			<a href="/project/?action=ShowProject&entrykey=#q_select_sales_projects.entrykey#"><span class="glyphicon glyphicon-usd"></span> #htmleditformat(CheckZeroString(q_select_sales_projects.title))#</a>
		</td>
		<td>
			#q_select_sales_projects.sales# #htmleditformat(q_select_sales_projects.currency)#
		</td>
		<td>
			#GetLangVal('crm_wd_sales_stage_' & q_select_sales_projects.stage)# / #q_select_sales_projects.probability#%
		</td>
		<td>
			<cfif ListLen(arguments.contactkeys) GT 1>
				<a href="/addressbook/?action=ShowItem&entrykey=#q_select_sales_projects.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_sales_projects.contactkey)#</a> /
			</cfif>

			<!--- <cfif IsDate( q_select_sales_projects.dt_closing )>
				#FormatDateTimeAccordingToUserSettings(q_select_sales_projects.dt_closing)#
			</cfif> --->

			<cfif Len(q_select_sales_projects.projectleaderuserkey) GT 0>
			/ <a href="/workgroups/?action=Showuser&entrykey=#q_select_sales_projects.projectleaderuserkey#">#htmleditformat(application.components.cmp_user.GetFullNameByentrykey(q_select_sales_projects.projectleaderuserkey))#</a>
			</cfif>

			<cfif arguments.managemode>
				<br />
				<a href="/project/index.cfm?action=EditProject&entrykey=#q_select_sales_projects.entrykey#"><span class="glyphicon glyphicon-pencil"></span> #MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a>
			</cfif>
		</td>
	</tr>
	</cfoutput>
</table>
</cfif>

<!--- // common projects ... // --->
<cfif q_select_common_projects.recordcount GT 0>

	<table class="table table-hover">
		<tr class="tbl_overview_header">
			<td width="25%"><cfoutput>#GetLangVal('prj_ph_project_type_0')# (#q_select_projects.recordcount#)</cfoutput></td>
			<td width="25%"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
			</td>
			<td width="25%"><cfoutput>#GetLangVal('prj_wd_progress')#</cfoutput></td>
			<td width="25%"><cfoutput>
				<cfif ListLen(arguments.contactkeys) GT 1>
				#GetLangVal('cm_wd_contact')# /
				</cfif>
				#GetLangVal('crm_ph_project_start')# / #GetLangVal('cm_wd_responsible_person')#</cfoutput></td>
		</tr>
		<cfoutput query="q_select_common_projects">
		<tr>
			<td>
				<a href="/project/?action=ShowProject&entrykey=#q_select_common_projects.entrykey#"><img src="/images/si/chart_organisation.png" class="si_img" /> #htmleditformat(CheckZeroString(q_select_common_projects.title))#</a>
			</td>
			<td>
				#htmleditformat(q_select_common_projects.description)#
			</td>
			<td>
				#q_select_common_projects.percentdone# %
			</td>
			<td>
				<cfif ListLen(arguments.contactkeys) GT 1>
					<a href="/addressbook/?action=ShowItem&entrykey=#q_select_common_projects.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_common_projects.contactkey)#</a> /
				</cfif>

				#FormatDateTimeAccordingToUserSettings(q_select_common_projects.dt_begin)#

				#htmleditformat(application.components.cmp_user.GetFullNameByentrykey(q_select_common_projects.projectleaderuserkey))#

				<cfif arguments.managemode>
				<br />
				<a href="/project/index.cfm?action=EditProject&entrykey=#q_select_common_projects.entrykey#"><span class="glyphicon glyphicon-pencil"></span> #MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a>
			</cfif>
			</td>
		</tr>
		</cfoutput>
	</table>
</cfif>
</cfsavecontent>


<cfset stReturn.a_str_content = sReturn />

<!---<cfif ListFindNoCase(arguments.parameters, 'displayallcolumns') GT 0>
			<td width="17%">
				#GetLangVal('cm_wd_title')#
			</td>
			<td width="17%">
				#GetLangVal('cm_wd_contact')#
			</td>
			<td width="17%">
				#GetLangVal('crm_ph_expected_sales')#
			</td>
			<td width="15%">
				#GetLangVal('cm_wd_stage')# / #GetLangVal('cm_ph_probability')#
			</td>
			<td width="15%">
				#GetLangVal('crm_ph_closing_date')#
			</td>
			<td width="17%">
				#GetLangVal('cm_wd_concerned')#
			</td>
		<cfelse>
			<td width="25%">
				#GetLangVal('cm_wd_title')#
			</td>
			<td width="25%">
				#GetLangVal('crm_ph_expected_sales')#
			</td>
			<td width="25%">
				#GetLangVal('cm_wd_stage')#
			</td>
			<td width="25%">
				#GetLangVal('crm_ph_closing_date')#
			</td>
		</cfif> --->

