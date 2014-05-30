<!--- //

	Module:		Forum
	Action:		ShowThread
	Description: 
	

// --->

<!--- entrykey of thread --->
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.forumkey" type="string" default="">
<cfparam name="url.alerthasbeencreated" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

<cfinvoke component="#application.components.cmp_forum#" method="GetWholePosting" returnvariable="q_select_postings">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif Len(url.forumkey) IS 0>
	<cfset url.forumkey = q_select_postings.forumkey>
</cfif>

<!--- no posting? --->
<cfif q_select_postings.recordcount IS 0>
	<cflocation addtoken="no" url="index.cfm?action=showforum&entrykey=#url.forumkey#">
</cfif>

<!--- select the top posting ... --->
<cfquery name="q_select_top_posting" dbtype="query">
SELECT
	subject,forumkey
FROM
	q_select_postings
WHERE
	parentpostingkey = ''
;
</cfquery>

<cfset a_bol_is_moderator = application.components.cmp_forum.IsModeratorOfForum(securitycontext = request.stSecurityContext, forumkey = url.forumkey) />

<cfset a_str_top_header_string = application.components.cmp_forum.GetForumNameByEntrykey(url.forumkey) & ' - ' & q_select_top_posting.subject />

<cfset tmp = SetHeaderTopInfoString(a_str_top_header_string)>


<cfif url.alerthasbeencreated IS 'true'>
	<!--- an alert has been created --->
	<div style="padding:4px;width:95%;border:orange solid 2px; ">
		<cfoutput>#GetLangVal('forum_ph_alert_has_been_created_description')#</cfoutput>
	</div>
	<br>
</cfif>
<cfsavecontent variable="a_str_content">

<cfoutput query="q_select_postings">

	<table class="table_details bb">
	  <tr>
		<td class="field_name">
			<img src="/tools/img/show_small_userphoto.cfm?entrykey=#q_select_postings.userkey#" border="0" align="left" vspace="4" hspace="4" />
			
			<img src="/images/si/comment.png" class="si_img" />###q_select_postings.currentrow#<br /><br />  
			#FormatDateTimeAccordingToUserSettings(q_select_postings.dt_created)#<br />
			by <b><a href="/workgroups/?action=ShowUser&entrykey=#q_select_postings.userkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_postings.userkey)#</a></b>
			

			<cfif a_bol_is_moderator>
				<div style="padding:4px;">
					<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" class="addinfotext" href="actions/act_delete_posting.cfm?forumkey=#url.forumkey#&threadkey=#url.entrykey#&entrykey=#q_select_postings.entrykey#"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('forum_ph_delete_article')#</a>
				</div>
			</cfif>

			<cfif (q_select_postings.userkey IS request.stSecurityContext.myuserkey)>						
				<div style="padding:4px;">
					<a href="index.cfm?action=NewPosting&forumkey=#url.forumkey#&replytopostingkey=#url.entrykey#&postingkey=#q_select_postings.entrykey#"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('forum_ph_edit_article')#</a>
				</div>
			</cfif>
			
		</td>
		<td <cfif q_select_postings.currentrow mod 2 IS 0>class="mischeader"</cfif> style="padding-left:20px;">
			<!--- html or not??
				
				replace links and so on
				--->
			
			<!---<cfset a_str_body = ReplaceNoCase(htmleditformat(q_select_postings.postingbody), chr(10), '<br>', 'ALL')>--->
		

			<cfset a_str_body = htmleditformat(q_select_postings.postingbody) />
			
			#ReplaceNoCase(a_str_body, Chr(10), '<br />', 'ALL')#

			<cfif isDate(q_select_postings.dt_last_updated_by_user)>
				<div style="font-style:italic;padding-top:20px;" class="addinfotext">
				#GetLangVal('forum_ph_posting_last_edited')# #FormatDateTimeAccordingToUserSettings(q_select_postings.dt_last_updated_by_user)#
				</div>
			</cfif>
		</td>
	  </tr>
	</table>
			
  </cfoutput>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<input onClick="GotoLocHref('index.cfm?action=NewPosting&forumkey=<cfoutput>#urlencodedformat(q_select_top_posting.forumkey)#</cfoutput>&replytopostingkey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>');return false;" class="btn btn-primary" type="button" value="<cfoutput>#GetLangVal('forum_ph_compose_new_answer')#</cfoutput>" />
	<input type="button" onclick="SubscribeAlertOnChange();return false;" class="btn" value="<cfoutput>#GetLangVal('forum_ph_alert_on_new_postings_to_this_thread')#</cfoutput>" />
	
</cfsavecontent>

<cfoutput>#WriteNewContentBox(q_select_postings.subject, a_str_buttons, a_str_content)#</cfoutput>

<cfsavecontent variable="a_str_js">
function SubscribeAlertOnChange() {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'SubscribeAlertOnChange';
	req.AddParameter('threadkey', '<cfoutput>#JsStringFormat(url.entrykey)#</cfoutput>');
	req.AddParameter('forumkey', '<cfoutput>#JsStringFormat(url.forumkey)#</cfoutput>');
	req.doCall();	
	}
</cfsavecontent>
	
<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />


