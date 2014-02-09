<!--- //

	Module:		Project
	Action:		ShowProject
	Description:show connected notices, files, emails, tasks, events AND custom  database entries
	

// --->

<cfparam name="url.entrykey" default="" type="string">

<!--- <cfinvoke component="#request.a_str_component_project#" method="GetAllProjects" returnvariable="q_select_projects">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke> --->

<cfinvoke component="#application.components.cmp_projects#" method="GetProject" returnvariable="a_struct_project">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_struct_project.result>
	Not found.
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_project = a_struct_project.q_select_project />
<cfset q_select_sales_project_stage_trends = a_struct_project.q_select_sales_project_stage_trends />

<!--- load all assigned items ... --->
<cfinvoke component="#application.components.cmp_projects#" method="GetAssignedItemsMetaInformation" returnvariable="q_select_connected_items">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="projectkey" value="#url.entrykey#">
</cfinvoke> 

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_project') & ' ' & q_select_project.title) />

<cfsavecontent variable="a_str_content">
<cfoutput query="q_select_project">
	<table class="table_details">
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_title')#
		</td>
		<td>
			#htmleditformat(q_select_project.title)#
		</td>
		<td class="field_name">
			#GetLangVal('cm_wd_description')#
		</td>
		<td>
			#htmleditformat(q_select_project.description)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_contact')#
		</td>
		<td>
			<cfif Len(q_select_project.contactkey) GT 0>
				<a href="/addressbook/?action=ShowItem&entrykey=#q_select_project.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_project.contactkey)#</a>
			</cfif>
		</td>
		<td class="field_name">
			#GetLangVal('cm_wd_responsible_person')#
		</td>
		<td>
			<a href="/workgroups/?action=ShowUser&entrykey=#q_select_project.projectleaderuserkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_project.projectleaderuserkey)#</a>
		</td>	
	</tr>
	
	<cfif q_select_project.project_type IS 1>
		<tr>
			<td class="field_name">			
				#GetLangVal('cm_wd_stage')#
			</td>
			<td>
				#GetLangVal('crm_wd_sales_stage_' & q_select_project.stage)#
			</td>
			<td class="field_name">
				#GetLangVal('crm_ph_expected_sales')#
			</td>
			<td>
				#val(q_select_project.sales)# #q_select_project.currency#
			</td>	
		</tr>
		<tr>
			<td class="td_title field_name">
				#GetLangVal('cm_ph_probability')#
			</td>
			<td>
				#val(q_select_project.probability)#%
			</td>
			<td class="td_title field_name">
			#GetLangVal('cm_wd_type')#
			</td>
			<td>
				<cfswitch expression="#q_select_project.business_type#">
					<cfcase value="0">
						#GetLangVal('crm_ph_deal_totally_new')#
					</cfcase>
					<cfcase value="1">
						#GetLangVal('crm_ph_deal_totally_followup')#
					</cfcase>
				</cfswitch>
			</td>
		</tr>
		<tr>
		<td class="td_title field_name">
			#GetLangVal('crm_ph_lead_source')#
		</td>
		<td>
			#GetLangVal('crm_ph_leadsource_' & q_select_project.lead_source)#
			
			<cfif Len(q_select_project.lead_source_id) GT 0>
				(#htmleditformat(q_select_project.lead_source_id)#)
			</cfif>			
		</td>
		<td class="field_name">
			
		</td>
		<td>
			
		</td>		
	</tr>
	</cfif>
	<tr>
		<td class="field_name">
			#GetLangVal('crm_ph_closing_date')#
		</td>
		<td>
			#FormatDateTimeAccordingToUserSettings(q_select_project.dt_closing)#
		</td>
		<td class="field_name"></td>
		<td></td>
	</tr>	
	<cfif IsDate(q_select_project.dt_begin) OR IsDate(q_select_project.dt_end)>
	<tr>
		<td class="field_name">
			#GetLangVal('crm_ph_project_start')#
		</td>
		<td>
			#FormatDateTimeAccordingToUserSettings(q_select_project.dt_begin)#
		</td>
		<td class="field_name">
			#GetLangVal('crm_ph_project_end')#
		</td>
		<td>
			#FormatDateTimeAccordingToUserSettings(q_select_project.dt_end)#
		</td>
	</tr>
	</cfif>
	<tr>
		<td class="field_name">
			#GetLangVal('prj_wd_progress')#
		</td>
		<td>
			#val(q_select_project.percentdone)# %
		</td>
		<td class="field_name">
			#GetLangVal('cm_wd_workgroups')#
		</td>
		<td>
			
		</td>
	</tr>
	<cfif q_select_project.closed IS 1>
		<tr>
			<td class="field_name">
				#GetLangVal('prj_wd_closed')#
			</td>
			<td>
			
			</td>
			<td class="field_name">
				#GetLangVal('prj_ph_closed_by_user')#
			</td>
			<td>
				#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_project.closedbyuserkey)#
			</td>
		</tr>
	</cfif>
	</table>
</cfoutput>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
<cfoutput>
	<input type="button" value="#MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#" onclick="GotoLocHref('default.cfm?action=EditProject&entrykey=#url.entrykey#');" class="btn" />
	
	<cfif q_select_project.closed IS 0>
		<input type="button" value="#GetLangVal('prj_ph_close_project')#" onclick="DoCloseProject('#jsstringformat(q_select_project.title)#', '#url.entrykey#');" class="btn2" />
	</cfif>
	<input type="button" value="#MakeFirstCharUCase(GetLangVal('cm_wd_delete'))#" onclick="GotoLocHref('default.cfm?action=DeleteProject&entrykey=#url.entrykey#');" class="btn2" />
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_project') , a_str_buttons, a_str_content)#</cfoutput>

<cfsavecontent variable="a_str_js">
function DoCloseProject(title, entrykey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = '<cfoutput>#GetLangValJS('prj_ph_close_project')#</cfoutput>';
	a_simple_modal_dialog.customcontent_load_from_url = 'default.cfm?Action=CloseProject&entrykey=' + escape(entrykey) + '&title=' + escape(title);
	a_simple_modal_dialog.ShowDialog();	
	return false;
	}
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />



<cfif q_select_project.project_type IS 1 AND q_select_sales_project_stage_trends.recordcount GT 0>
	<cfsavecontent variable="a_str_content">
	
		<table class="table_overview" cellspacing="0">
			<cfoutput>
			<tr class="tbl_overview_header">
				<td width="25%">
					#GetLangVal('crm_wd_stage')#
				</td>
				<td>
					#GetLangVal('crm_ph_expected_sales')#
				</td>
				<td>
					#GetLangVal('cm_ph_probability')# (%)
				</td>
				<td width="25%">
					#GetLangVal('crm_ph_closing_date')#
				</td>
				<td width="25%">
					#GetLangVal('cm_wd_created')#
				</td>
			</tr>
			</cfoutput>
			<cfoutput query="q_select_sales_project_stage_trends">
				<tr>
					<td>
						#GetLangVal('crm_wd_sales_stage_' & q_select_sales_project_stage_trends.stage)#
					</td>
					<td>
						#val(q_select_sales_project_stage_trends.sales)#
					</td>
					<td>
						#q_select_sales_project_stage_trends.probability#%
					</td>
					<td>
						<cfif IsDate(q_select_sales_project_stage_trends.dt_closing)>
							#LsDateFormat(q_select_sales_project_stage_trends.dt_closing, request.stUserSettings.default_dateformat)#
						</cfif>
					</td>
					<td>
						#LsDateFormat(q_select_sales_project_stage_trends.dt_created, request.stUserSettings.default_dateformat)#
					</td>
				</tr>
			</cfoutput>
		</table>
	
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(GetLangval('crm_ph_stage_trends'), '', a_str_content)#</cfoutput>
</cfif>

<cfexit method="exittemplate">

<!--- tasks ... --->
<cfquery name="q_select_connected_tasks_meta_information" dbtype="query">
SELECT
	*
FROM
	q_select_connected_items
WHERE
	servicekey = '52230718-D5B0-0538-D2D90BB6450697D1'
;
</cfquery>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = valueList(q_select_connected_tasks_meta_information.objectkey)>

<cfinvoke component="#application.components.cmp_tasks#" method="GetTasks" returnvariable="stReturn_tasks">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_tasks = stReturn_tasks.q_select_tasks>

<!--- contacts ... --->
<cfquery name="q_select_connected_contacts_meta_information" dbtype="query">
SELECT
	*
FROM
	q_select_connected_items
WHERE
	servicekey = '52227624-9DAA-05E9-0892A27198268072'
;
</cfquery>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = valueList(q_select_connected_contacts_meta_information.objectkey)>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_contacts = stReturn_contacts.q_select_contacts>

<!--- events ... --->
<cfquery name="q_select_connected_calendar_meta_information" dbtype="query">
SELECT
	*
FROM
	q_select_connected_items
WHERE
	servicekey = '5222B55D-B96B-1960-70BF55BD1435D273'
;
</cfquery>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = valueList(q_select_connected_calendar_meta_information.objectkey)>

<cfset a_dt_start = CreateDate(1800, 1, 1)>
<cfset a_dt_end = CreateDate(2100, 1, 1)>


<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn_events">
  	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#a_dt_end#">  
</cfinvoke>

<cfset q_select_events = stReturn_events.q_select_events>

<!--- the return url --->
<cfset sReturnurl = urlencodedformat(cgi.SCRIPT_NAME&"?"&cgi.QUERY_STRING)>

<div class="mischeader" style="padding:3px;"><font class="contrasttext" style="font-weight:bold;"><img src="/images/hyperlink.gif" align="absmiddle">&nbsp;Verkn&uuml;pfte Elemente</font></div>

<br>



<div class="bb"><b><img src="/images/tasks/menu_neue_aufgabe.gif" align="absmiddle" border="0" hspace="4" vspace="4">Aufgaben (<cfoutput>#q_select_tasks.recordcount#</cfoutput>)</b></div>

	

		<table border="0" cellspacing="0" cellpadding="3"  width="100%">

		<tr class="mischeader">

			<td class="bb">Betreff</td>

			<td class="bb">Status</td>

			<td class="bb">F&auml;llig</td>

			<td class="bb">Zust&auml;ndig</td>

		</tr>

		<cfoutput query="q_select_tasks" startrow="1" maxrows="5">

		  <tr id="idtrtasks#q_select_tasks.currentrow#"  onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">

			<td><a href="../tasks/default.cfm?action=ShowTask&entrykey=#q_select_tasks.entrykey#&returnurl=#sReturnurl#"><img src="/images/icon/notizen.gif" align="absmiddle" vspace="0" hspace="0" border="0" height="12" width="12">&nbsp;#q_select_tasks.title#</a></td>

			<td>#q_select_tasks.status#</td>

			<td>

			<cfif isDate(q_select_tasks.dt_due)>

			<a href="../calendar/default.cfm?action=ViewDay&Date=#urlencodedformat(dateformat(q_select_tasks.dt_due, "mm/dd/yyyy"))#">#lsdateformat(q_select_tasks.dt_due, "ddd, dd.mm.yy")#</a>

			</cfif>

			</td>

			<td></td>

		  </tr>

		 </cfoutput>

		 <cfif q_select_tasks.recordcount gt 5>

		 <tr>

		 	<td colspan="4">&gt; <a href="../tasks/default.cfm?action=ShowTasks&filterprojectkey=<cfoutput>#url.entrykey#</cfoutput>">Alle verbundenen Aufgaben anzeigen</a></td>

		 </tr>

		 </cfif>

		 <tr>

		 	<td colspan="4">&gt; <a href="../tasks/default.cfm?action=NewEntry&projectkey=<cfoutput>#url.entrykey#</cfoutput>&returnurl=<cfoutput>#sReturnurl#</cfoutput>">Neue Aufgabe hinzuf&uuml;gen</a></td>

		 </tr>

		</table>



<table border="0" cellspacing="0" cellpadding="8">

  <tr>

    <td valign="top">

		

		<div class="bb"><img src="/images/addressbook/menu_gruppen.gif" align="absmiddle" vspace="4" hspace="4" border="0"><b>Kontakte (<cfoutput>#q_select_contacts.recordcount#</cfoutput>)</b></div>

		

		

		<table border="0" cellspacing="0" cellpadding="3" style="margin-left:15px;">

		<cfoutput query="q_select_contacts" startrow="1" maxrows="5">

			<tr>

				<td><a href="../addressbook/default.cfm?action=View&entrykey=#q_select_contacts.entrykey#"><img src="/images/icon/kalender_klein.gif" align="absmiddle" vspace="0" hspace="0" border="0">&nbsp;#q_select_contacts.surname#, #q_select_contacts.firstname#</a>

				<cfif Len(q_select_contacts.company) gt 0>(#q_select_contacts.company#)</cfif></td>

			</tr>

		</cfoutput>

		<cfif q_select_contacts.recordcount gt 5>

			<tr>

				<td>

				<a href="#">Alle verbundenen Kontakte anzeigen</a>

				</td>

			</tr>

		</cfif>	

		</table>	

	

		

	

	</td>

	<td valign="top">

		

		<div class="bb"><img src="/images/webmail/menu_posteingang.gif" hspace="4" vspace="4" align="absmiddle" border="0"><b>E-Mails</b></div>

	</td>

  </tr>

  <tr>

    <td valign="top">

	

	

	</td>

    <td valign="top">

	

	

	</td>

   </tr>

   <tr>

    <td valign="top">

	<div class="bb"><img src="/images/storage/menu_neues-verzeichnis.gif" align="absmiddle" hspace="4" vspace="4" border="0"><b>Dateien</b></div>

	

	</td>

	<td valign="top">

	<div class="bb"><img src="/images/webmail/menu_als_entwurf_speichern.gif" align="absmiddle" vspace="4" hspace="4" border="0"><b>Eigene Datenbanken</b></div>

	

	</td>

 </tr>

    <tr>

   	<td>Forum</td>

	<td>Bookmarks</td>

   </tr>

   <tr>

   	<td>Umfragen</td>

	<td>Notizen</td>

   </tr>

</table>

<div class="mischeader" style="padding:3px;"><font class="contrasttext" style="font-weight:bold;"><img src="/images/authors.gif" align="absmiddle">&nbsp;Aktivit&auml;ten</font></div>

<table>

	<tr>

	<td valign="top">

	<div class="bb"><b><img src="/images/calendar/menu_heute.gif" vspace="4" hspace="4" align="absmiddle" border="0">Termine (<cfoutput>#q_select_events.recordcount#</cfoutput>)</b></div>

	

		<table border="0" cellspacing="0" cellpadding="3" style="margin-left:15px;">

		<cfoutput query="q_select_events">

			<tr>

				<td><a href="../calendar/default.cfm?action=DisplayEvent&entrykey=#q_select_connected_events.entrykey#"><img src="/images/icon/kalender_klein.gif" align="absmiddle" vspace="0" hspace="0" border="0">&nbsp;#q_select_events.title#</a> (#DateFormat(q_select_events.date_start, "dd.mm.yy")# #TimeFormat(q_select_events.date_start, "HH:mm")#)</td>

			</tr>

		</cfoutput>	

		</table>

	</td>

  </tr>

</table>

<br>

<div class="mischeader" style="padding:3px;"><font class="contrasttext" style="font-weight:bold;"><img src="/images/icon/notizen.gif" align="absmiddle">&nbsp;Neue Notiz/Kommentar verfassen</font></div>

<form action="act_new_notice.cfm" method="post">

<input type="hidden" name="frmprojectkey" value="<cfoutput>#url.entrykey#</cfoutput>">

<textarea name="frmNotice" cols="40" rows="7"></textarea><br>

<input type="submit" name="frmSubmit" value="Hinzuf&uuml;gen">

</form>

