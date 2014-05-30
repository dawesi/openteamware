<!--- //

	Module:		CRM
	Description:Outlook on startpage
	

// --->

<cfset a_int_clear_all_stored_criteria_for_simple_filter = GetUserPrefPerson('addressbook', 'clearcriteria.unstoredfilter', '1', '', false) />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>	

<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 5 />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="orderby" value="lastdisplayed">	
	<cfinvokeargument name="filterdatatypes" value="0">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_last_displayed_contacts = stReturn.q_select_contacts />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetFilterCriteriaQuery" returnvariable="q_select_default_filter_criteria">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="viewkey" value="">	
	<cfinvokeargument name="itemttype" value="0">
</cfinvoke>

<cfset q_select_not_approved_issues = application.components.cmp_newsletter.GetIssues(securitycontext = request.stSecurityContext,
							usersettings = request.stUserSettings,
							filter_approved = 0) />							

<cfsavecontent variable="a_str_crm">

<table border="0" cellspacing="0" cellpadding="4" width="100%">
  <tr>
    <td width="50%" valign="top">
	
		<form id="idformtopsearch" name="idformtopsearch" method="POST" onSubmit="ShowLoadingStatus();" action="/addressbook/index.cfm?action=DoAddFilterSearchCriteria" style="margin:0px;">
		<input type="hidden" name="frmfilterviewkey" value="" />
		<input type="hidden" name="frmdisplaydatatype" value="0" />
		<input type="hidden" name="frmarea" value="contact" />
		<input type="hidden" name="frm_fields" value="surname,firstname,company,b_city,b_zipcode" />
		<table class="table_details table_edit_form" style="background-color:white;">
		<tr>
			<td class="field_name"><img src="/images/si/find.png" class="si_img" /></td>
			<td style="font-weight:bold;">
				<cfoutput>#GetLangval('cm_wd_search')#</cfoutput><img src="/images/space_1_1.gif" alt="" class="si_img" />
			</td>
		</tr>
		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>
			</td>
			<td>
				<input type="text" name="frmfirstname" value="" size="10" />
				<input type="hidden" name="frmfirstname_displayname" value="<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>" />
			</td>
		</tr>
		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>
				</td>
			<td>
				<input type="text" name="frmsurname" value="" size="10" />
				<input type="hidden" name="frmsurname_displayname" value="<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>" />
			</td>
		</tr>
		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput>
			</td>
			<td>
				<input type="text" name="frmcompany" value="" size="10" />
				<input type="hidden" name="frmcompany_displayname" value="<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>" />
			</td>
		</tr>

		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>
			</td>
			<td>
				<input type="text" name="frmb_city" value="" size="10" />
				<input type="hidden" name="frmb_city_displayname" value="<cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>" />
			</td>
		</tr>

		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>
			</td>
			<td>
				<input type="text" name="frmb_zipcode" value="" size="10" />
				<input type="hidden" name="frmb_zipcode_displayname" value="<cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>" />
			</td>
		</tr>				
		<cfif q_select_default_filter_criteria.recordcount GT 0>
			<tr>
				<td class="field_name">
					<input type="checkbox" value="1" name="frmclearallstoredcriteria" checked="true" />				
				</td>
				<td>
					<cfoutput>#GetLangVal('adrb_ph_start_new_search')#</cfoutput>
				</td>
			</tr>
		</cfif>
		<tr>
			<td class="field_name">
			</td>
			<td>
				<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn" />
			</td>
		</tr>
		<cfif q_select_last_displayed_contacts.recordcount GT 0>
			<tr>
				<td class="field_name">
					<img src="/images/si/eye.png" class="si_img" />
				</td>
				<td style="font-weight:bold;">
					<cfoutput>#GetLangVal('cm_ph_last_displayed')#</cfoutput><img src="/images/space_1_1.gif" class="si_img" />
				</td>
			</tr>
			<tr>
				<td class="field_name">
				</td>
				<td>
					<cfoutput query="q_select_last_displayed_contacts">
						
						<cfquery name="q_select_contact" dbtype="query">
						SELECT
							*
						FROM
							q_select_last_displayed_contacts
						WHERE
							entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_last_displayed_contacts.entrykey#">
						;
						</cfquery>
												
						<a href="/addressbook/?action=ShowItem&entrykey=#q_select_last_displayed_contacts.entrykey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_contact.entrykey, query_holding_data = q_select_contact)#</a>
					
					<cfif q_select_last_displayed_contacts.currentrow NEQ q_select_last_displayed_contacts.recordcount>,</cfif>
					</cfoutput>
					
				</td>
			</tr>			
		</cfif>
		</table>
		</form>
		
		
	
		
	</td>
	<td width="50%" valign="top">
	
	
		<!--- display activities --->
		<cfset a_struct_filter = StructNew() />
		<cfset a_struct_filter.userkey = request.stSecurityContext.myuserkey />
		<cfset a_struct_filter.done = 0 />
		<cfset a_struct_filter.maxdate = DateAdd('d', 3, Now()) />
	
		<cfinvoke component="#application.components.cmp_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
			<cfinvokeargument name="servicekey" value="">
			<cfinvokeargument name="objectkeys" value="">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="filter" value="#a_struct_filter#">
		</cfinvoke>
		
		<cfquery name="q_select_calls" dbtype="query">
		SELECT
			*
		FROM
			q_select_follow_ups
		WHERE
			followuptype = 2
		;
		</cfquery>
		
		
		<cfquery name="q_select_other_followps" dbtype="query">
		SELECT
			*
		FROM
			q_select_follow_ups
		WHERE
			NOT followuptype = 2
		;
		</cfquery>
		
		<cfset a_int_follow_ups_count = q_select_follow_ups.recordcount - Val(q_select_calls.recordcount) />
		
		<cfinvoke component="#application.components.cmp_projects#" method="GetAllProjects" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>
		
		<cfset q_select_projects = stReturn.q_select_projects />
				
		<cfquery name="q_select_sales_projects" dbtype="query" maxrows="5">
		SELECT
			*
		FROM
			q_select_projects
		WHERE
			project_type = 1
			AND
			closed = 0
		ORDER BY
			sales_probability DESC
		;
		</cfquery>
		
		<cfset a_int_max_records_followups_display = 10 />
		
		<cfset a_struct_filter = StructNew()>
		<cfset a_struct_filter.statusexclude = 0>
		<cfset a_struct_filter.excludenoduedateitems = true>
		
		<cfinvoke component="#application.components.cmp_tasks#" method="GetTasks" returnvariable="stReturn">
		  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		  <cfinvokeargument name="filter" value="#a_struct_filter#">
		  <cfinvokeargument name="loadnotice" value="false">
		</cfinvoke>
		
		<cfset a_int_dt_today = DateFormat(GetLocalTime(Now()), 'yyyymmdd')&'0000'>
		<cfset a_int_dt_tommorrow = DateFormat(DateAdd('d', 1, GetLocalTime(Now())), 'yyyymmdd')&'0000'>
		
		<cfquery name="q_select_tasks" dbtype="query">
		SELECT
			*
		FROM
			stReturn.q_select_tasks
		WHERE
			(
				(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
				OR
				(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
			)	
		ORDER BY
			int_dt_due
		;
		</cfquery>
			
		<table class="table_details">
		
		<cfif q_select_not_approved_issues.recordcount GT 0>
		<tr>
			<td class="field_name">
				<cfoutput>#si_img('page_save')#</cfoutput>
			</td>
			<td style="font-weight:bold;">
				<a href="/mailing/"><cfoutput>#GetLangVal('nl_ph_waiting_jobs')# (#q_select_not_approved_issues.recordcount#)</cfoutput></a>
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
			
				<table class="table_simple">
				<cfoutput query="q_select_not_approved_issues">
				<tr>
					<td>
						#si_img('bullet_orange')# <a href="/mailing/">#htmleditformat(q_select_not_approved_issues.subject)# (#htmleditformat(q_select_not_approved_issues.description)#), #htmleditformat(q_select_not_approved_issues.profile_name)#</a>
					</td>
					<td class="addinfotext" style="text-align:right;">
						#FormatDateTimeAccordingToUserSettings(q_select_not_approved_issues.dt_send)#<img src="/images/space_1_1.gif" class="si_img" />
					</td>
				</tr>
				</cfoutput>
				</table>
			
			</td>
		</tr>
		</cfif>
		
		<cfif q_select_sales_projects.recordcount GT 0>
		<tr>
			<td class="field_name">
				<cfoutput>#si_img('coins')#</cfoutput>
			</td>
			<td style="font-weight:bold;">
				<a href="/project/"><cfoutput>#GetLangval('crm_ph_project_type_1')# (#q_select_sales_projects.recordcount#)</cfoutput></a><img src="/images/space_1_1.gif" class="si_img" />
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
			
			<table class="table_simple">
			<cfoutput query="q_select_sales_projects">
			<tr>
				<td>
					#si_img('bullet_orange')# <a href="/project/?action=ShowProject&entrykey=#q_select_sales_projects.entrykey#">#htmleditformat(q_select_sales_projects.title)#</a> (#q_select_sales_projects.sales_probability# #htmleditformat(q_select_sales_projects.currency)#)
				</td>
				<td class="addinfotext" style="text-align:right;">
					#FormatDateTimeAccordingToUserSettings(q_select_sales_projects.dt_closing)#<img src="/images/space_1_1.gif" class="si_img" />
				</td>
			</tr>
			</cfoutput>
			</table>
			
			</td>
		</tr>
		</cfif>
		<cfif Val(q_select_calls.recordcount) GT 0>
		<tr>
			<td class="field_name">
				<cfoutput>#si_img('telephone')#</cfoutput>
			</td>
			<td style="font-weight:bold;">
				<a href="/crm/?action=activities"><cfoutput>#GetLangval('adb_wd_telephonelist')# (#q_select_calls.recordcount#)</cfoutput><img src="/images/space_1_1.gif" class="si_img" /></a>
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
	
				<table class="table_simple">
				<cfoutput query="q_select_calls">
				<tr>
					<td>
						#si_img('bullet_orange')# #application.components.cmp_tools.GenerateLinkToItem(usersettings = request.stUserSettings, servicekey = q_select_calls.servicekey, title = q_select_calls.objecttitle, objectkey = q_select_calls.objectkey)#
					</td>
					<td class="addinfotext" style="text-align:right;">
						#FormatDateTimeAccordingToUserSettings(q_select_calls.dt_due)#<img src="/images/space_1_1.gif" class="si_img" />
					</td>
				</tr>
				</cfoutput>
				</table>
				
			</td>
		</tr>
		</cfif>
		<cfif q_select_other_followps.recordcount GT 0>
		<tr>
			<td class="field_name">
				<img src="/images/si/flag_red.png" class="si_img" />
			</td>
			<td style="font-weight:bold;">
				<a href="/crm/?action=activities"><cfoutput>#GetLangval('crm_wd_follow_ups')# (#q_select_other_followps.recordcount#)</cfoutput></a><img src="/images/space_1_1.gif" class="si_img" />
			</td>
		</tr>
		<tr>
			<td class="field_name">
			</td>
			<td>
				
				<table class="table_simple">
				<cfoutput query="q_select_other_followps">
				<tr>
					<td>
						<img src="/images/si/bullet_orange.png" class="si_img" /> #application.components.cmp_tools.GenerateLinkToItem(usersettings = request.stUserSettings, servicekey = q_select_other_followps.servicekey, title = q_select_other_followps.objecttitle, objectkey = q_select_other_followps.objectkey)#
					</td>
					<td class="addinfotext" style="text-align:right;">
						#FormatDateTimeAccordingToUserSettings(q_select_other_followps.dt_due)#<img src="/images/space_1_1.gif" class="si_img" />
					</td>
				</tr>
				</cfoutput>
				</table>
				
			</td>
		</tr>
		</cfif>
		<cfif q_select_tasks.recordcount GT 0>
		<tr>
			<td class="field_name">
				<img src="/images/si/bullet_red.png" class="si_img" />
			</td>
			<td style="font-weight:bold;">
				<a href="/tasks/"><cfoutput>#GetLangval('tsk_ph_due_tasks')# (#q_select_tasks.recordcount#)</cfoutput></a><img src="/images/space_1_1.gif" class="si_img" />
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
				
				<table class="table_simple">
				<cfoutput query="q_select_tasks">
				<tr>
					<td>
						<img src="/images/si/bullet_orange.png" class="si_img" /> <a href="/tasks/?action=ShowTask&entrykey=#q_select_tasks.entrykey#">#htmleditformat(CheckZerostring(q_select_tasks.title))#</a>
					</td>
					<td class="addinfotext" style="text-align:right;">
						#FormatDateTimeAccordingToUserSettings(q_select_tasks.dt_due)#<img src="/images/space_1_1.gif" class="si_img" />
					</td>
				</tr>
				</cfoutput>
				</table>

			</td>
		</tr>
		</cfif>
		</table>
		<!--- <img src="/images/si/wrench.png" class="si_img" /> 4 Serviceprojekte --->
			
			
			
		<!--- 	<cfoutput query="q_select_tasks" startrow="1" maxrows="10">
				<tr>
					<td style="width:66%; ">
						<a href="/tasks/?action=ShowTask&entrykey=#q_select_tasks.entrykey#">#htmleditformat(CheckZerostring(q_select_tasks.title))#</a>
						
						<cfif val(q_select_tasks.percentdone) GT 0>
							(#q_select_tasks.percentdone# %)
						</cfif>
					</td>
					<td style="width:33%<cfif q_select_tasks.status GT 0 AND IsDate(q_select_tasks.dt_due) AND q_select_tasks.dt_due LTE Now()>;color:##CC0000;</cfif>">
						<cfif IsDate(q_select_tasks.dt_due)>
							#LsDateFormat(q_select_tasks.dt_due, 'dd.mm.yy')#
						<cfelse>
							&nbsp;
						</cfif>		
					</td>
				</tr>
			</cfoutput>	 --->
	
	
	</td>
  </tr>
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_contacts') & ' & ' & GetLangVal('adrb_wd_activities'), '', a_str_crm)#</cfoutput>
