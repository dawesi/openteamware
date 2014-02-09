<!--- //

	Module:		Forum
	Description:Outlook on startpage
	

// --->

<!--- exit if no workgroups --->
<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_foren_count = application.components.cmp_forum.GetForenCountForUser(securitycontext = request.stSecurityContext,
										usersettings = request.stUserSettings) />

<!--- no foren exist ... --->
<cfif a_int_foren_count IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- select foren ... --->
<cfset q_select_foren = application.components.cmp_forum.GetForumList(securitycontext = request.stSecurityContext,
										usersettings = request.stUserSettings) />

<cfset q_select_newest_postings = application.components.cmp_forum.SelectNewestPostings(forenkeys = ValueList(q_select_foren.entrykey),
										securitycontext = request.stSecurityContext,
										usersettings = request.stUserSettings,
										max_rows = 10) />
										
<cfif q_select_newest_postings.recordcount GT 0>
	<tr>
		<td colspan="2">
			<cfoutput>#GetLangVal('cm_ph_new_in_forum')#</cfoutput>
		</td>
	</tr>
</cfif>

<cfoutput query="q_select_newest_postings">
	<tr>
		<td colspan="2">
			<a href="/forum/default.cfm?action=showthread&entrykey=#q_select_newest_postings.entrykey#&forumkey=#q_select_newest_postings.forumkey#"><img src="/images/si/comment.png" class="si_img" /> #htmleditformat(checkzerostring(q_select_newest_postings.subject))#</a>
			
			
			(<!--- <a href="/forum/default.cfm?action=ShowForum&entrykey=#q_select_newest_postings.forumkey#"> --->#htmleditformat(application.components.cmp_forum.GetForumNameByEntrykey(q_select_newest_postings.forumkey))#<!--- </a> --->)
		</td>
	</tr>
</cfoutput>


