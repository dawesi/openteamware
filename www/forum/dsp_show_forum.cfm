<!--- //

	Module:		Forum
	Action:		ShowForum
	Description: 
	

// --->
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_forum#" method="GetForumPostings" returnvariable="q_select_postings">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<!---<cfdump var="#q_select_postings#">--->

<cfquery name="q_select_postings" dbtype="query">
SELECT
	*
FROM
	q_select_postings
WHERE
	parentpostingkey = ''
;
</cfquery>

<cfset tmp = SetHeaderTopInfoString(q_select_postings.subject) />

<cfsavecontent variable="a_str_content">
<table class="table_overview">
  <tr class="tbl_overview_header">
    <td width="50">&nbsp;</td>
    <td><cfoutput>#GetLangVal('cm_wd_subject')#</cfoutput></td>
    <td align="center">Antworten</td>
    <td align="center"><cfoutput>#GetLangVal('cm_wd_created')#</cfoutput></td>
	<td>Last Posting</td>
  </tr>
  <cfoutput query="q_select_postings">
  <tr>
    <td align="center" width="50" nowrap>
	<img src="/images/si/comment.png" class="si_img" />
		
	<cfif q_select_postings.currentrow LTE 2>
		<img src="/images/si/new.png" class="si_img" />
	<cfelse>
		<img src="/images/space_1_1.gif" class="si_img" />
	</cfif>
	</td>
    <td>
		<a href="default.cfm?action=ShowThread&entrykey=#urlencodedformat(q_select_postings.entrykey)#&forumkey=#urlencodedformat(url.entrykey)#"><b>#htmleditformat(shortenstring(checkzerostring(q_select_postings.subject), 40))#</b></a>
		<br />
		<font class="addinfotext">#trim(shortenstring(striphtml(ReplaceNoCase(q_select_postings.postingbody, '&nbsp;', ' ', 'ALL')), 100))# ...</font>
	</td>
    <td align="center">
		#val(q_select_postings.subpostingscount)#
	</td>
	<td class="addinfotext" align="center">
		<a href="/workgroups/default.cfm?action=ShowUser&entrykey=#urlencodedformat(q_select_postings.lastpostinguserkey)#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_postings.userkey)#</a>
	</td>
	<td class="addinfotext">
		#FormatDateTimeAccordingToUserSettings(q_select_postings.dt_threadlastmodified)#
	</td>
  </tr>
  </cfoutput>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	<input class="btn" onClick="location.href = 'default.cfm?action=NewPosting&forumkey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>';" type="button" value="<cfoutput>#GetLangVal('forum_ph_compose_new_article')#</cfoutput>">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(application.components.cmp_forum.GetForumNameByEntrykey(url.entrykey), a_str_buttons, a_str_content)#</cfoutput>



