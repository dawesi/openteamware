<!--- //

	Component:	Forum
	Function:	ShowOverview
	Description:Show available forums
	
	Header:	

// --->

<cfinvoke component="#application.components.cmp_forum#" method="GetForumList" returnvariable="q_select_foren">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>


<cfsavecontent variable="a_str_content">
	
<div style="padding:10px;">
	<cfoutput>#GetLangVal('forum_ph_foren_welcome_intro')#</cfoutput>
</div>

<table class="table table-hover">
  <tr class="tbl_overview_header">
    <td>
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('forum_ph_last_postings')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select_foren">
  <tr>

    <td>
		<a style="font-weight:bold;" href="index.cfm?action=ShowForum&entrykey=#q_select_foren.entrykey#"><img src="/images/si/comments.png" class="si_img" /> #htmleditformat(q_select_foren.forumname)#</a>
		<br />
		<img src="/images/space_1_1.gif" class="si_img" /> #htmleditformat(q_select_foren.description)#
	</td>
    <td>

		<cfset q_select_latest_postings = application.components.cmp_forum.SelectNewestPostings(forenkeys = q_select_foren.entrykey,
											securitycontext = request.stSecurityContext,
											usersettings = request.stUserSettings) />
											
		<table class="table table-hover">
		<cfloop query="q_select_latest_postings">
		  <tr>
			<td width="33%" valign="top">
				<img src="/images/si/bullet_orange.png" class="si_img" /> <a href="index.cfm?Action=ShowThread&forumkey=#q_select_latest_postings.forumkey#&entrykey=#q_select_latest_postings.entrykey#">#htmleditformat(CheckZeroString(q_select_latest_postings.subject))#</a>
			</td>
			<td width="33%" valign="top">
				#application.components.cmp_user.GetFullNameByEntrykey(q_select_latest_postings.lastpostinguserkey)#
			</td>
			<td width="33%" class="addinfotext" valign="top">
				#FormatDateTimeAccordingToUserSettings(q_select_latest_postings.dt_threadlastmodified)#

				<cfif isDate(q_select_latest_postings.dt_threadlastmodified) AND (DateDiff('h', q_select_latest_postings.dt_threadlastmodified, Now()) LTE 36)>
					<img src="/images/si/new.png" class="si_img" />
				</cfif>
			</td>
		  </tr>
		</cfloop>
		</table>

	</td>
  </tr>
  </cfoutput>
</table>
</cfsavecontent>
<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_overview'), '', a_str_content)#</cfoutput>



<!---
<br>


<cfset q_select_newest_postings = a_cmp_forum.SelectNewestPostings(forenkeys = ValueList(q_select_foren.entrykey), securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, max_rows = 20)>

<fieldset class="bg_fieldset">
	<legend>
		<img src="/images/arrows/img_indent_small.png" align="absmiddle" vspace="4" hspace="4" border="0"> <cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput>
	</legend>
	<div>
		<cfdump var="#q_select_newest_postings#">
	</div>
</fieldset>--->

