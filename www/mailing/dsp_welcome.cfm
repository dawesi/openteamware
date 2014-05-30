<!--- //

	Module:		Mailing
	Action:		ShowWelcome
	Description: 
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_mailings')) />

<!--- entrykey of issue just approved --->
<cfparam name="url.approvedkey" type="string" default="">

<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>	

<cfset q_select_issues = application.components.cmp_newsletter.GetIssues(securitycontext = request.stSecurityContext,
							usersettings = request.stUserSettings) />

<cfif Len(url.approvedkey) GT 0>
	
	<!--- has been approved ... --->
	<cfquery name="q_select_approved_issue" dbtype="query">
	SELECT
		*
	FROM
		q_select_issues
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.approvedkey#">
	;
	</cfquery>
	
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message = "<b>#htmleditformat(q_select_approved_issue.issue_name)#</b> ...<br><br>#GetLangVal('nl_ph_start_sending_issue')#"
		backlink = "false"
		caption = "">
	
	<br /> 
</cfif>

<!--- get all not already approved issues ... --->
<cfquery name="q_select_un_approved_issues" dbtype="query">
SELECT
	*
FROM
	q_select_issues
WHERE
	approved = 0
ORDER BY
	listkey
;
</cfquery>

<cfif q_select_un_approved_issues.recordcount GT 0>
<cfsavecontent variable="a_str_content">
	<br /> 
	<div class="mischeader" style="padding:6px;border:orange solid 1px;">
		<img src="/images/si/lock.png" class="si_img" /> <cfoutput>#GetLangVal('nl_ph_waiting_jobs_need_authorisation')#</cfoutput>
	</div>
	<br /> 
	<table class="table table-hover">
	<cfoutput query="q_select_un_approved_issues">
		<tr>
			<td>
				<img src="/images/si/page_key.png" class="si_img" /><b>#htmleditformat(q_select_un_approved_issues.profile_name)#</b>
				<br /> 
				#htmleditformat(q_select_un_approved_issues.issue_name)# (#htmleditformat(q_select_un_approved_issues.description)#)
				<br /><br />  
				
				<!--- number of recipients --->
				<cftry>
				<cfset q_select_subscribers = application.components.cmp_newsletter.GetSubscribers(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, listkey = q_select_un_approved_issues.listkey, options = '')>					
				<a href="index.cfm?action=editsubscribers&listkey=#q_select_un_approved_issues.listkey#">#si_img('group')# #GetLangVal('nl_wd_recipients')#: #q_select_subscribers.recordcount#</a>
				<cfcatch type="any"> </cfcatch></cftry>
			</td>
			<td style="white-space:nowrap; ">
				<a style="background-color:##009900;font-weight:bold;padding:2px;color:white;text-transform:uppercase;font-size:10px;border:silver solid 1px; " onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="index.cfm?action=approveissue&entrykey=#q_select_un_approved_issues.entrykey#">#GetLangVal('nl_ph_release_for_sending')# ...</a>
			</td>
			<td>
				<a href="javascript:SendTestMails('#q_select_un_approved_issues.listkey#', '#q_select_un_approved_issues.entrykey#');">#GetLangVal('nl_ph_send_test_issues')# ...</a>
			</td>
			 <td align="right">
			 	<a href="index.cfm?action=editissue&entrykey=#q_select_un_approved_issues.entrykey#&listkey=#q_select_un_approved_issues.listkey#"><img src="/images/si/pencil.png" class="si_img" alt="#GetLangVal('cm_wd_edit')#" /></a>
				
			 	<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_delete_waiting_issue.cfm?entrykey=#q_select_un_approved_issues.entrykey#"><img src="/images/si/delete.png" class="si_img" alt="#GetLangVal('cm_wd_delete')#" /></a>
			 </td>				
		</tr>
	</cfoutput>
	</table>	
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('nl_ph_waiting_jobs') & ' (' & q_select_un_approved_issues.recordcount & ')', '', a_str_content)#</cfoutput>

</cfif>

<cfsavecontent variable="a_str_content">

		<br />  
		<cfoutput>#GetLangVal('nl_ph_welcome_text')#</cfoutput>
		<br /><br />  
	
		<cfset q_select_profiles = application.components.cmp_newsletter.GetNewsletterProfiles(securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings) />
	
	
		<cfif q_select_profiles.recordcount IS 0>
			<a style="font-weight:bold; " href="index.cfm?action=newprofile"><cfoutput>#GetLangVal('nl_ph_no_profiles_created_please_do_that')#</cfoutput></a>
			<br /><br />  
		<cfelse>
		
			<table class="table table-hover">
			<tr class="tbl_overview_header">
				<td>
					<cfoutput>#GetLangVal('cm_wd_name')#/#GetLangVal('cm_wd_description')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('cm_wd_type')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('nl_ph_new_issue')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('nl_ph_last_issues')#</cfoutput>
				</td>
				<td align="center">
					<cfoutput>#GetLangVal('nl_wd_subscribers')#</cfoutput>
				</td>
				<td align="right">
					<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
				</td>
			  </tr>
			  <cfoutput query="q_select_profiles">
			  <tr>
				<td>
					<font style="font-weight:bold; ">#si_img('page_save')# #htmleditformat(q_select_profiles.profile_name)#</font>&nbsp;
					<br /> 			
					#htmleditformat(q_select_profiles.description)#
				</td>
				<td>
					<cfswitch expression="#q_select_profiles.listtype#">
						<cfcase value="0">

							<cfif Len(q_select_profiles.crm_filter_key) IS 0>
								#GetLangVal('nl_ph_all_contacts_no_filter')#
							<cfelse>

								<cfquery name="q_select_filter_name" dbtype="query">
								SELECT
									*
								FROM
									q_select_all_filters
								WHERE
									entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_profiles.crm_filter_key#">
								;
								</cfquery>

								#GetLangVal('nl_ph_dynamic_by_crm_filter')#<br><i>#htmleditformat(q_select_filter_name.viewname)#</i>
							
							</cfif>							

						</cfcase>
						<cfcase value="1">
							#GetLangVal('nl_ph_email_Addresses_only')#
						</cfcase>
						<cfcase value="2">
							#GetLangVal('nl_ph_fix_from_address_book')#
						</cfcase>
					</cfswitch>					
				</td>
				<td>	
					<a style="font-weight:bold;" href="index.cfm?action=newissue&listkey=#q_select_profiles.entrykey#">#GetLangVal('nl_ph_new_issue')# ...</a>
				</td>
				<td>
				
					<cfquery name="q_select_sent_issues" dbtype="query" maxrows="3">
					SELECT
						*
					FROM
						q_select_issues
					WHERE
						(approved = 1)
						AND
						listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_profiles.entrykey#">
						AND
						(hidden_issue = 0)
					ORDER BY
						dt_send DESC
					;
					</cfquery>
										
					<cfif q_select_sent_issues.recordcount GT 0>
						<ul class="img_points">
						<cfloop query="q_select_sent_issues">
							<li>
								<a href="index.cfm?action=stat&listkey=#q_select_sent_issues.listkey#&issuekey=#q_select_sent_issues.entrykey#">#htmleditformat(q_select_sent_issues.issue_name)#</a>
								<br />
								#FormatDateTimeAccordingToUserSettings(q_select_sent_issues.dt_send)#
							</li>
						</cfloop>
						</ul>
					</cfif>
				</td>
				<td align="center" id="id_td_calc_subscribers_#q_select_profiles.currentrow#">
					
					<!--- load number of subscribers --->
					<a href="##" onclick="CalcNumberOfSubscribers('#JsStringFormat(q_select_profiles.entrykey)#', '#jsStringFormat('id_td_calc_subscribers_' & q_select_profiles.currentrow)#');return false;">#si_img('calculator')# #GetLangVal('cm_wd_show')#</a>
					<br /> 
					<a href="index.cfm?action=editsubscribers&listkey=#q_select_profiles.entrykey#">#si_img('pencil')# #GetLangVal('cm_wd_show')#</a>
					
					<cfsavecontent variable="a_str_js">
						
					</cfsavecontent>
					
					<cfset tmp = AddJSToExecuteAfterPageLoad(a_str_js, '') />
				</td>
				<td style="white-space:nowrap; " align="right">
					<a href="index.cfm?action=editprofile&entrykey=#q_select_profiles.entrykey#"><img src="/images/si/pencil.png" class="si_img" alt="#GetLangVal('cm_wd_edit')#" /></a>
					
					<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_make_profile_invisible.cfm?entrykey=#q_select_profiles.entrykey#"><img src="/images/si/delete.png" class="si_img" alt="#GetLangVal('cm_wd_delete')#" /></a>
					
					<cfif q_select_profiles.listtype IS 1>
						<!---
						<br>
						<a href="index.cfm?action=generatesubscribeform">Anmeldeformular erstellen</a>
						--->
					</cfif>
				</td>
			  </tr>
			  </cfoutput>
			</table>
			
		</cfif>

</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	<cfoutput>
		<input onClick="location.href = 'index.cfm?action=newprofile';" type="button" value="#GetLangVal('cm_ph_create_new_profile')#" class="btn btn-primary">
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('nl_ph_stored_profiles'), a_str_buttons, a_str_content)#</cfoutput>


<br /><br />
<cfquery name="q_select_approved" dbtype="query">
SELECT
	*
FROM
	q_select_issues
WHERE
	approved = 1
	AND
	hidden_issue = 0
ORDER BY
	dt_send DESC
;
</cfquery>

<cfif q_select_approved.recordcount GT 0>

<cfsavecontent variable="a_str_content">

		<table class="table table-hover">
			<tr class="tbl_overview_header">
				<td>
					<cfoutput>#GetLangVal('cm_wd_name')#/#GetLangVal('cm_wd_description')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('nl_wd_sent')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('cm_wd_subject')#</cfoutput>
				</td>
				<td align="center">
					<cfoutput>#GetLangVal('nl_wd_recipients')#</cfoutput>/
					<br/>
					<cfoutput>#GetLangVal('adm_wd_statistics')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
				</td>
				<td align="center">
					<cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput>
				</td>
			</tr>
			<cfoutput query="q_select_approved">
			<tr>
				<td>
					<a title="" href="index.cfm?action=stat&listkey=#q_select_approved.listkey#&issuekey=#q_select_approved.entrykey#">#si_img('page_green')# #htmleditformat(q_select_approved.issue_name)#</a>
					<br />
					&nbsp;&nbsp;<font class="addinfotext">#htmleditformat(q_select_approved.description)#</font>
				</td>
				<td >
					<cfif isDate(q_select_approved.dt_send)>
						#FormatDateTimeAccordingToUserSettings(q_select_approved.dt_send)#
					<cfelse>
						<a href="act_cancel_approval.cfm?entrykey=#q_select_approved.entrykey#">Cancel approval</a>
					</cfif>
				</td>
				<td>
					#htmleditformat(CheckZeroString(q_select_approved.subject))#
				</td>
				<td align="center">
				
					<cfif q_select_approved.prepare_done IS 1>
						<cfquery name="q_select_recipients_count" datasource="#request.a_str_db_crm#">
						SELECT
							COUNT(id) AS count_id
						FROM
							newsletter_recipients
						WHERE
							issuekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_approved.entrykey#">
						;
						</cfquery>
						
						#val(q_select_recipients_count.count_id)#
						/
						<a href="index.cfm?action=stat&listkey=#q_select_approved.listkey#&issuekey=#q_select_approved.entrykey#">#GetLangVal('adm_wd_statistics')# ...</a>
					<cfelse>
						<img src="/images/img_bar_status_loading.gif" width="107" height="13" border="0">
						<br />
						#GetLangVal('nl_ph_status_sending_issue')#
					</cfif>
				</td>
				<td>
					<a href="index.cfm?action=newissue&listkey=#q_select_approved.listkey#&templatekey=#q_select_approved.entrykey#">Als Vorlage verwenden ...</a>
				</td>
				<td align="center">
					<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_remove_issue.cfm?listkey=#q_select_approved.listkey#&issuekey=#q_select_approved.entrykey#">#si_img('delete')#</a>
				</td>
			</tr>
			</cfoutput>
		</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('nl_ph_last_sent_issues')& ' / ' & GetLangVal('adm_wd_statistics'), '', a_str_content)#</cfoutput>


</cfif>

