

<!--- //

	Module:		CRM
	Action:		Activities
	Description:Display all open activities ...


// --->

<cfset SetHeaderTopInfoString( "#GetLangVal('cm_wd_today')# (#LsDateFormat(now(), 'dddd, ' & request.stUserSettings.DEFAULT_DATEFORMAT)#)" ) />

<cfinclude template="/common/scripts/script_utils.cfm" />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.userkey = request.stSecurityContext.myuserkey />
<cfset a_struct_filter.servicekey = '52227624-9DAA-05E9-0892A27198268072' />
<cfset a_struct_filter.done = 0 />
<cfset a_struct_filter.type = 2 />

<cfinvoke component="#application.components.cmp_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset a_str_contactkeys = ValueList(q_select_follow_ups.objectkey) />
<!---
<cfif Len(a_str_contactkeys) GT 0>

	<cfset a_struct_filter = StructNew() />
	<cfset a_struct_filter.entrykeys = a_str_contactkeys />

	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">
	</cfinvoke>

	<cfset q_select_contacts = stReturn.q_select_contacts />

</cfif> --->

<cfsavecontent variable="a_str_content">

<table class="table table-hover">
	<cfoutput>
	<tr class="tbl_overview_header">
		<td width="25%">
			#GetLangVal('cm_wd_contact')#
		</td>
		<td width="25%">
			#GetLangVal('cm_wd_comment')# / #GetLangVal('cm_wd_categories')#
		</td>
		<td width="25%">
			#GetLangVal('cm_ph_timestamp')#
		</td>
		<td width="25%">
			#GetLangVal('cm_wd_user')#
		</td>
		<td align="right">
			#GetLangVal('cm_wd_action')#
		</td>
	</tr>
	</cfoutput>
	<cfoutput query="q_select_follow_ups">
		<tr>
			<td>
				<span class="glyphicon glyphicon-earphone"></span>
				#application.components.cmp_tools.GenerateLinkToItem(usersettings = request.stUserSettings, servicekey = q_select_follow_ups.servicekey, title = q_select_follow_ups.objecttitle, objectkey = q_select_follow_ups.objectkey)#
			</td>
			<td>
				#htmleditformat(q_select_follow_ups.comment)#
				#q_select_follow_ups.categories#
			</td>
			<td>
				#FormatDateTimeAccordingToUserSettings(q_select_follow_ups.dt_due)#

				<cfif IsDate(q_select_follow_ups.dt_due) AND q_select_follow_ups.dt_due LT Now()>
					<span class="glyphicon glyphicon-exclamation-sign"></span>
				</cfif>
			</td>
			<td>
				<a href="/workgroups/?action=ShowUser&amp;entrykey=#q_select_follow_ups.userkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_follow_ups.userkey)#</a>
			</td>
			<td align="right" nowrap="true">
				<a href="/crm/?action=EditFollowup&amp;entrykey=#q_select_follow_ups.entrykey#" class="nl"><span class="glyphicon glyphicon-pencil"></span></a>
				<a class="nl" href="##" onclick="ShowSimpleConfirmationDialog('index.cfm?action=DeleteFollowups&amp;entrykeys=#q_select_follow_ups.entrykey#');"><span class="glyphicon glyphicon-trash"></span></a>
			</td>
		</tr>
	</cfoutput>
</table>
</cfsavecontent>

<cfif q_select_follow_ups.recordcount GT 0>
	<cfoutput>#WriteNewContentBox(GetLangVal('adb_wd_telephonelist') & ' (' & q_select_follow_ups.recordcount & ')', '', a_str_content)#</cfoutput>
</cfif>

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.userkey = request.stSecurityContext.myuserkey />
<cfset a_struct_filter.done = 0 />
<cfset a_struct_filter.not_type = 2 />

<cfinvoke component="#application.components.cmp_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<!--- merge with follow-ups created by myself --->
<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.createdbyuserkey = request.stSecurityContext.myuserkey />
<cfset a_struct_filter.not_userkey = request.stSecurityContext.myuserkey />
<cfset a_struct_filter.servicekey = '52227624-9DAA-05E9-0892A27198268072' />
<cfset a_struct_filter.done = 0 />

<cfinvoke component="#application.components.cmp_followups#" method="GetFollowUps" returnvariable="qFollowUpsAssignedToOthers">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfquery name="q_select_follow_ups" dbtype="query">
SELECT	*
FROM	q_select_follow_ups
UNION ALL
SELECT	*
FROM	qFollowUpsAssignedToOthers
</cfquery>


<cfset sContactKeys = ValueList(q_select_follow_ups.objectkey) />

<cfif Len(sContactKeys) GT 0>

	<cfset a_struct_filter = StructNew() />
	<cfset a_struct_filter.entrykeys = sContactKeys />

	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stContacts">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">
	</cfinvoke>

	<cfset qContacts = stContacts.q_select_contacts />

</cfif>

<cfif q_select_follow_ups.recordcount GT 0>
<cfsavecontent variable="a_str_content">

<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td width="20%">
			<cfoutput>#GetLangVal('cm_wd_title')#</cfoutput>
		</td>
		<td width="20%">
			<cfoutput>#GetLangVal('cm_wd_comment')#/#GetLangVal('cm_wd_categories')#</cfoutput>
		</td>
		<td width="20%">
			<cfoutput>#GetLangVal('adrb_ph_contact_data')#</cfoutput>
		</td>
		<td width="20%">
			<cfoutput>#GetLangVal('cm_ph_timestamp')#</cfoutput>
		</td>
		<td width="15%">
			<cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>
		</td>
		<td align="right" class="hideprint">
			<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
		</td>
	</tr>
	<cfoutput query="q_select_follow_ups">


		<!--- get the contact --->
		<cfquery name="qContact" dbtype="query">
		SELECT	*
		FROM	qContacts
		WHERE	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_follow_ups.objectkey#" />
		</cfquery>

		<tr>
			<td style="font-weight:bold">
				#application.components.cmp_tools.GenerateLinkToItem(usersettings = request.stUserSettings, servicekey = q_select_follow_ups.servicekey, title = q_select_follow_ups.objecttitle, objectkey = q_select_follow_ups.objectkey)#

			</td>
			<td title="#htmleditformat(q_select_follow_ups.comment)#">
				<!--- TODO: print mode? --->

				<cfparam name="url.format" type="string" default="" />

				<cfswitch expression="#url.format#">

					<cfcase value="pdf">
						#htmleditformat( q_select_follow_ups.comment )#
					</cfcase>
					<cfdefaultcase>
						#htmleditformat( ShortenString( q_select_follow_ups.comment, 140 ))#
					</cfdefaultcase>
				</cfswitch>

				#htmleditformat( q_select_follow_ups.categories )#

				<cfif q_select_follow_ups.followuptype GT 0>
					<br />
					<span class="addinfotext">#GetLangVal('crm_ph_followup_type_' & q_select_follow_ups.followuptype)#</span>
				</cfif>
			</td>
			<td>
				<cfsavecontent variable="sContactData">

					<cfif len(qContact.b_telephone) GT 0>
						/ <a href="javascript:OpenCallPopup('#qContact.entrykey#', '#jsstringformat(qContact.b_telephone)#');">#htmleditformat(qContact.b_telephone)#</a>
					<cfelseif len(qContact.b_MOBILE) GT 0>
						/ <a href="javascript:OpenCallPopup('#urlencodedformat(qContact.b_MOBILE)#', 'mobile');">#htmleditformat(qContact.b_mobile)#</a>
					<cfelseif len(qContact.p_telephone) GT 0>
						/ <a href="javascript:OpenCallPopup('#urlencodedformat(qContact.p_telephone)#', 'mobile');">#htmleditformat(qContact.p_telephone)#</a>
					</cfif>

				</cfsavecontent>

				<cfset sContactData = ReReplace(Trim(sContactData), '^/', '', 'one') />

				<cfif Len(sContactData)>#sContactData#<br /></cfif>

				#htmleditformat(qContact.b_zipcode)# #htmleditformat(qContact.b_city)#
			</td>
			<td>
				#FormatDateTimeAccordingToUserSettings(q_select_follow_ups.dt_due)#

				<cfif q_select_follow_ups.priority IS 5>
					<span class="glyphicon glyphicon-exclamation-sign"></span>
				</cfif>
			</td>
			<td>
				<cfset username = application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_follow_ups.userkey) />

				<!--- <div style="background-color:<cfif username IS 'andrea.ristl'>darkgreen<cfelseif username IS 'barbara.posch'>orange<cfelse>darkred</cfif>;color:white;width: auto;float:left;padding: 8px;font-size:16px;text-transform:uppercase;font-weight:bold">#Left( username, 1 )#</div> --->

				#username#
			</td>
			<td align="right" nowrap="true" class="hideprint">
				<a href="index.cfm?action=EditFollowup&amp;entrykey=#q_select_follow_ups.entrykey#" class="nl"><span class="glyphicon glyphicon-pencil"></span></a>
				<a class="nl" href="##" onclick="ShowSimpleConfirmationDialog('index.cfm?action=DeleteFollowups&amp;entrykeys=#q_select_follow_ups.entrykey#');"><span class="glyphicon glyphicon-trash"></span></a>
			</td>
		</tr>
	</cfoutput>
</table>
</cfsavecontent>
</cfif>


<cfsavecontent variable="a_str_btn">
	<input onClick="window.open('<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&amp;format=pdf&amp;extractcontentid=followuplist');return false" type="button" value=" Export as PDF " class="btn btn-primary" />
</cfsavecontent>

<!--- <cfset a_str_btn = '' /> --->

<div id="followuplist">
<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_follow_ups') & ' (' & q_select_follow_ups.recordcount & ')', a_str_btn, a_str_content)#</cfoutput>
</div>

<cfinvoke component="#application.components.cmp_projects#" method="GetAllProjects" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset q_select_projects = stReturn.q_select_projects />

<cfset a_dt_closing = DateAdd('d', -21, Now()) />

<cfquery name="q_select_sales_projects" dbtype="query" maxrows="20">
SELECT
	*
FROM
	q_select_projects
WHERE
	closed = 0
ORDER BY
	sales_probability DESC
;
</cfquery>

<cfsavecontent variable="a_str_content">

<table class="table table-hover">
  <tr class="tbl_overview_header">
	<cfoutput>
    <td>#GetLangVal('cm_wd_title')#</td>
	<td>#GetLangVal('cm_wd_stage')#</td>
	<td>#GetLangVal( 'cm_ph_probability' )#</td>
    <td>#GetLangVal('crm_ph_expected_sales')#</td>
	<td>#GetLangVal('cm_wd_contact')#</td>
	<td>#GetLangVal('cm_wd_responsible_person')#</td>
	<td>#GetLangVal('crm_ph_closing_date')#</td>
	</cfoutput>
  </tr>

<cfoutput query="q_select_sales_projects">
  <tr>
    <td>
		<a href="/project/index.cfm?action=ShowProject&amp;entrykey=#q_select_sales_projects.entrykey#"><span class="glyphicon glyphicon-usd"></span>#htmleditformat(CheckZeroString(q_select_sales_projects.title))#</a>
	</td>
	<td>
		#GetLangVal('crm_wd_sales_stage_' & q_select_sales_projects.stage)#
	</td>
	<td>
		<div class="progress">
		  <div class="progress-bar" role="progressbar" aria-valuenow="#q_select_sales_projects.sales_probability#" aria-valuemin="0" aria-valuemax="100" style="width: #q_select_sales_projects.sales_probability#%;">
		  </div>
		</div>
	</td>
    <td>
		#Val(q_select_sales_projects.sales)# #q_select_sales_projects.currency#
	</td>
	<td>
		<a href="/addressbook/?action=ShowItem&amp;entrykey=#q_select_sales_projects.contactkey#">#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_sales_projects.contactkey)#</a>
	</td>
    <td>
		#application.components.cmp_user.GetUsernameByEntrykey(q_select_sales_projects.projectleaderuserkey)#
	</td>
	<td>
		<cfif IsDate(q_select_sales_projects.dt_closing)>
			#LSDateFormat(q_select_sales_projects.dt_closing, request.stUserSettings.default_dateformat)#
		</cfif>
	</td>
  </tr>
</cfoutput>
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_sales_projects'), '', a_str_content)#</cfoutput>


<!---


<!--- today outlook --->
<cfsavecontent variable="a_str_today">
	<cfinclude template="../calendar/dsp_outlook_default.cfm">
</cfsavecontent>

<cfsavecontent variable="a_str_btn">
	<cfoutput>
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewDay');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_day')#" />
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewWeek');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_week')#" />
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewMonth');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_month')#" />
	</cfoutput>
</cfsavecontent>

<!--- write "today" box --->
<cfoutput>#WriteNewContentBox('', a_str_btn, a_str_today)#</cfoutput>
 --->

