
<cfoutput>#CreateDefaultTopHeader(GetLangVal('forum_wd_foren'))#</cfoutput>


<!---
<cfparam name="url.forumkey" type="string" default="">

<table class="tablemaincontenttop">
	<tr>
		<td class="addinfotext" style="font-weight:bold; ">
		<a class="addinfotext" href="/forum/">&raquo; <cfoutput>#GetLangVal('forum_wd_foren')#</cfoutput></a>
		
		<cfif url.action IS 'ShowThread'>
			&raquo;
			<a class="addinfotext" href="default.cfm?action=showforum&entrykey=<cfoutput>#urlencodedformat(url.forumkey)#</cfoutput>"><cfoutput>#a_cmp_forum.GetForumNameByEntrykey(url.forumkey)#</cfoutput></a>
		</cfif>
		</td>
	</tr>
</table>

<cfexit method="exittemplate">

<table class="tablemaincontenttop">
	<tr>
		<td>
			<a href="default.cfm" class="TopHeaderLink"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a>
		</td>
		<td class="tdtopheaderdivider">|</td>
		<td>
			<a href="default.cfm?action=currentpostings" class="TopHeaderLink"><cfoutput>#GetLangVal('forum_ph_current_postings')#</cfoutput></a>
		</td>
		<td class="tdtopheaderdivider">|</td>
		<td>
			<a href="default.cfm?action=mypostings" class="TopHeaderLink"><cfoutput>#GetLangVal('forum_ph_my_articles')#</cfoutput></a>
		</td>		
	</tr>
</table>

--->