<cfinvoke component="#application.components.cmp_tasks#" method="GetTask" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT StructKeyExists(stReturn, 'q_select_task')>
	<cfoutput>#GetLangVal('tsk_ph_task_not_found')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_contact_connections = stReturn.q_select_contact_connections>
<cfset q_select_task = stReturn.q_select_task>
<cfset struct_rights = stReturn.rights>

<cfif q_select_task.recordcount is 0>
	<cfoutput>#GetLangVal('tsk_ph_task_not_found')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>


<!--- load comments ... --->
<cfinvoke component="/components/tools/cmp_comments" method="GetComments" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="objectkey" value="#url.entrykey#">
</cfinvoke>



<cfset q_select_comments = stReturn.q_select_comments>

<cfsavecontent variable="a_Str_js_edit_actions">
	function EditThisTaskNow() {
		DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_status_please_wait')#</cfoutput>');
		location.href = 'index.cfm?action=edittask&entrykey=<cfoutput>#url.entrykey#</cfoutput>';
		}
	function DeleteThisTaskNow() {
		DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_status_please_wait')#</cfoutput>');
		location.href = 'index.cfm?action=deletetask&entrykey=<cfoutput>#url.entrykey#</cfoutput>';
		}
	function UpdateStatusOfThisTaskNow(status) {
		DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_status_please_wait')#</cfoutput>');
		location.href = 'act_set_new_status.cfm?status=' + escape(status) + '&entrykey=<cfoutput>#url.entrykey#</cfoutput>';
		}		
</cfsavecontent>

<cfscript>
	AddJSToExecuteAfterPageLoad('', a_Str_js_edit_actions);
</cfscript>


<!---
<cfif IsInternalIPOrUser()>
<script type="text/javascript">
// type: confirmation,warning, information
// additionaltext: display additional text
// executeurl: url to call if answer of user is "yes"
// BGexec: call executeurl in the background or location.href?
// BGExecCallbackFunction: function to call after bg action has been done
function OpenSimpleModalDialog(type,additionaltext,executeurl,BGexec,BGExecCallbackFunction)
	{
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.ShowDialog();
/*
	
	var a_additional_text = '';
	var a_execute_url = '';
	var a_bg_exec = false;
	var a_exec_url = '';
	var a_bg_exec_callback;
	
	if (additionaltext) {a_additional_text = additionaltext;}
	if (executeurl) {a_execute_url = executeurl;}
	if (BGexec) {a_bg_exec = BGexec;}
	if (BGExecCallbackFunction) {a_bg_exec_callback = BGExecCallbackFunction;}*/
	}
function OpenInPagePopup(url, type, modal_dialog)
	{
	// modal dialog?
	var a_modal_dialog = false;
	
	if (modal_dialog) { a_modal_dialog = modal_dialog; }
	
	DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_status_please_wait')#</cfoutput>');
	
	CloseOpenActionPopups();	
		
	a_http_load_in_page_popup = GetNewHTTPObject();
	CallHTTPGet(a_http_load_in_page_popup, url, processReqDisplayInPagePopupLoad);
	
	// display the background
	findObj('id_div_background_mask_in_page_popup').style.display = 'block';
	}
function ShowInfoDialog()
	{
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'information';
	a_simple_modal_dialog.customcontent = 'nur so zur info mal nebenbei ...';
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
function CustomInfoDialog()
	{
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'titel dieses fensters';
	a_simple_modal_dialog.customcontent = 'dies ist ein custom dialog';
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
function ConfirmInfoDialog()
	{
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.customcontent = '';
	a_simple_modal_dialog.executeurl = 'act_delete_task.cfm?entrykey=<cfoutput>#url.entrykey#</cfoutput>';
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
	
function EnterEmailAddress()
	{
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	
	a_simple_modal_dialog.customtitle = 'Erweiterte Eigenschaften';
	
	a_simple_modal_dialog.customcontent_load_from_url = '/tasks/inc_load_test.cfm';
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
function CreateCustomFlag()
	{
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.executeurl = 'act_test_url.cfm';
	a_simple_modal_dialog.backgroundexecute = true;
	a_simple_modal_dialog.backgroundexecute_callback_function = function() {alert('123');}
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
function processReqCustomConfirmActionChange()
	{
	
	}
</script>


	<!---// delete // --->

	<a href="javascript:ShowInfoDialog();">info dialog</a>
	<br>
	<br>
	<a href="javascript:CustomInfoDialog();">custom dialog</a>
	<br>
	<br>
	<a href="javascript:ConfirmInfoDialog();">confirm dialog</a>
	<br>
	<br>
	<a href="javascript:EnterEmailAddress();">enter custom content from url</a>
	<br>
	<br>
	<a href="javascript:CreateCustomFlag();">enter custom content from url</a>
</cfif>--->


<br>
<cfsavecontent variable="a_str_task_view">
		
		
			<table border="0" cellspacing="0" cellpadding="6" class="table_details">

			<cfoutput query="q_select_task">
			  <tr class="mischeader">
				<td colspan="2" class="bb"><b><cfoutput>#GetLangVal('cm_wd_summary')#</cfoutput></b></td>
			  </tr>
			  <tr>
				<td align="right" valign="top" class="field_name">
					#GetLangVal('tsk_wd_title')#
				</td>
				<td valign="top" style="font-weight:bold;">
					#htmleditformat(checkzerostring(q_select_task.title))#
				</td>
			  </tr>
			  <tr>
				<td align="right" valign="top" class="field_name">
					#GetLangVal('cm_wd_text')#
				</td>
				<td>

				<cfset a_str_text = ReplaceNoCase(htmleditformat(trim(q_select_task.notice)), chr(10), "<br>", "ALL")>
				#a_str_text#&nbsp;
				</td>
			  </tr>
			  

			 	  
			  
			  <tr>
			  	<td></td>
				<td>
					<cfif (struct_rights.write is true) OR ListFind(q_select_task.assignedtouserkeys, request.stSecurityContext.myuserkey) GT 0>
					
						[ <a href="javascript:AddComment('#jsstringformat(request.sCurrentServiceKey)#','#jsstringformat(url.entrykey)#');">#GetLangVal('cm_ph_add_comment')#</a> ]
						
					  </cfif>
				</td>
			  </tr> 
			  
			  <tr>
				<td valign="top" align="right" class="field_name">#GetLangVal('cm_wd_status')#</td>
				<td valign="top">
				<cfswitch expression="#q_select_task.status#">
					<cfcase value="0">
					#GetLangVal("tsk_wd_done")#
					</cfcase>
					<cfcase value="1">
					#GetLangVal("tsk_ph_status_notstartedyet")#
					</cfcase>
					<cfcase value="2">
					#GetLangVal("tsk_ph_status_inprogress")#
					</cfcase>
					<cfcase value="3">
					#GetLangVal("tsk_wd_status_deferred")#
					</cfcase>
				</cfswitch>
				
				(#q_select_task.percentdone#%)
				
				 <cfif val(q_select_task.percentdone) gt 0>
				 <br>
				 <div class="b_all" style="margin-top:5px;width:100px;"><img src="/images/bar_small.gif" height="3" width="#q_select_task.percentdone#"></div>
				 </cfif>
				</td>
			  </tr>
			  <cfif isdate(q_select_task.dt_done)>
			  <tr>
				<td align="right" class="field_name">#GetLangVal('task_wd_done')#</td>
				<td>
				#q_select_task.dt_done#
				</td>
			  </tr>
			  </cfif>
			  <tr>
				<td align="right" class="field_name">#GetLangVal('cm_wd_priority')#</td>
				<td>
				<cfswitch expression="#q_select_task.priority#">
					<cfcase value="1">
					#GetLangVal("cm_wd_priority_low")#
					</cfcase>
					<cfcase value="2">
					#GetLangVal("cm_wd_priority_normal")#
					</cfcase>
					<cfcase value="3">
					#GetLangVal("cm_wd_priority_high")#
					</cfcase>
				</cfswitch>
				</td>
			  </tr>
			  
			  <!--- the categories --->
			  <cfif len(q_select_task.categories) GT 0>
			  <tr>
				<td align="right" valign="top" class="field_name">#GetLangVal('cm_Wd_categories')#</td>
				<td valign="top">
				<!--- offer a link to related tasks --->
				<cfloop list="#q_select_task.categories#" delimiters="," index="a_str_category">
				<a href="index.cfm?action=ShowTasks&filtercategory=#urlencodedformat(a_str_category)#">#a_str_category#</a>&nbsp;
				</cfloop>
				</td>
			  </tr>
			  </cfif>
			  
			  <!--- assigned to ... --->
			  <cfif len(q_select_task.assignedtouserkeys) GT 0>
			  <tr>
			  	<td align="right" valign="top" class="field_name">#GetLangVal('task_ph_assignedto')#</td>
				<td valign="top">
				<cfloop list="#q_select_task.assignedtouserkeys#" delimiters="," index="a_str_userkey">
				
					<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
						<cfinvokeargument name="entrykey" value="#a_str_userkey#">
					</cfinvoke>
					<a href="../workgroups/index.cfm?action=ShowUser&entrykey=#urlencodedformat(a_str_userkey)#">#htmleditformat(a_str_username)#</a><br />
					
				</cfloop>
				</td>
			  </tr>
			  </cfif>
			  
			  <cfif q_select_contact_connections.recordcount GT 0>
			  	<tr>
					<td align="right" class="field_name">
						<cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput>
					</td>
					<td>
						<cfset a_struct_filter = StructNew()>
						<cfset a_struct_filter.entrykeys = ValueList(q_select_contact_connections.contactkey)>
					
						<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
							<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
							<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
							<cfinvokeargument name="filter" value="#a_struct_filter#">
						</cfinvoke>
						
						<cfset q_select_contacts = stReturn_contacts.q_select_contacts>
						
						<cfloop query="q_select_contacts">
							<a href="/addressbook/?action=ShowItem&entrykey=#q_select_contacts.entrykey#">#htmleditformat(q_select_contacts.company)#, #htmleditformat(CheckZeroString(Trim(q_select_contacts.surname & q_select_contacts.firstname)))#</a><br>
						</cfloop>
					</td>
				</tr>
			  </cfif>
			  
			  <cfif q_select_task.status neq 0>
			  <!--- not yet done, show the due date --->
			  <tr>
				<td align="right" valign="top" class="field_name">#GetLangVal('tsk_wd_due')#</td>
				<td valign="top">
				<cfif isDate(q_select_task.dt_due)>
				<a href="../calendar/index.cfm?action=ViewDay&date=#dateformat(q_select_task.dt_due, "mm/dd/yyyy")#">#lsdateformat(q_select_task.dt_due, "ddd, dd.mm.yy")#</a>
				
					<!--- overdue? --->
					<cfif (Now() GT q_select_task.dt_due) AND (ListLen(q_select_task.assignedtouserkeys) GT 0)>
						(vor <cfoutput>#DateDiff('d',q_select_task.dt_due,  now())#</cfoutput> Tage(n))
						<div style="border:orange solid 2px;padding:6px; ">
							<input type="button" value="#GetLangVal('tsk_ph_btn_urge_task')#" onClick="SendReminderAboutTask();">
						</div>
						
						<script type="text/javascript">
							function SendReminderAboutTask()
								{
								location.href = 'act_urge_task.cfm?entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>';
								}
						</script>
					</cfif>
				<cfelse>
				n/a
				</cfif>
				</td>
			  </tr>
			  </cfif>
			  <tr class="mischeader">
				<td colspan="2" class="bb"><b>#GetLangVal('cm_wd_details')#</b></td>
			  </tr>
			  <tr>
				<td align="right" class="field_name">#GetLangVal('tsk_ph_input_current')#</td>
				<td>
				<cfif val(q_select_task.actualwork) gt 0>
				#q_select_task.actualwork#
				<cfelse>
				n/a
				</cfif>
				</td>
			  </tr>
			  <tr>
				<td align="right" class="field_name">#GetLangVal('tsk_ph_input_total')#</td>
				<td>
				<cfif val(q_select_task.totalwork) gt 0>
				#q_select_task.totalwork#
				<cfelse>
				n/a
				</cfif>
				</td>
			  </tr>
 			   <tr>
				<td align="right"  class="field_name" valign="top">#GetLangVal('cm_wd_created')#</td>
				<td valign="top">
				#lsdateformat(q_select_task.dt_created, "dd.mm.yyy")# #TimeFormat(q_select_task.dt_created, "HH:mm")#
				
				<cfif q_select_task.userkey neq request.stSecurityContext.myuserkey>
						
						<cfinvoke component="/components/management/users/cmp_user" method="GetUsernamebyentrykey" returnvariable="a_str_username">
							<cfinvokeargument name="entrykey" value="#q_select_task.userkey#">
						</cfinvoke>
				#GetLangVal('cm_wd_by')# #a_str_username#
				
				<cfif struct_rights.managepermissions is true>
					<br><a href="act_take_ownership.cfm?entrykey=#urlencodedformat(url.entrykey)#">Eigentuemerschaft dieses Objektes uebernehmen</a>
				</cfif>
				
				</cfif>
				</td>
			  </tr>
			  
			  <!--- load workgroups of object ... --->
			  <cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
					<cfinvokeargument name="entrykey" value="#url.entrykey#">
					<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
					<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
			  </cfinvoke>			  			  
				
			  <cfif q_select_shares.recordcount GT 0>
			  <tr class="mischeader">
				<td colspan="2" class="bb"><b>#GetLangVal('cm_ph_workgroup_share')#</b></td>
			  </tr>
			  <tr>
			  <tr>
				<td colspan="2" style="padding-left:20px;">
				<!--- check if member is allowed to watch that information ... --->
				<cfloop query="q_select_shares">
				
				<!--- load workgroup name ... --->
				<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupNameByEntryKey" returnvariable="a_str_workgroup_name">
					<cfinvokeargument name="entrykey" value="#q_select_shares.workgroupkey#">
				</cfinvoke>
					
				<img src="/images/calendar/16kalender_gruppen.gif" width="11" height="12" align="absmiddle" border="0" hspace="4" vspace="4">#a_str_workgroup_name#<br>
				</cfloop>  
				</td>  
			  </tr>  			 
			  </cfif>
			  
			  
			   <cfif q_select_comments.recordcount GT 0>
			  <tr>
			  	<td valign="top" class="bt bb" align="right">#GetLangVal('cm_wd_comments')#:</td>
			  	<td valign="top" class="bt bb">
				
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
					  <cfloop query="q_select_comments">
					  <tr>

						<td valign="top">
						
						<cfset a_str_text = ReplaceNoCase(trim(q_select_comments.comment), chr(10), '<br>', 'ALL')>
						
						#a_str_text#
						
		
						<cfinvoke component="/components/management/users/cmp_user" method="GetUsernamebyentrykey" returnvariable="a_str_username">
							<cfinvokeargument name="entrykey" value="#q_select_comments.userkey#">
						</cfinvoke>					
						</td>
						<td valign="top">
							<a href="/workgroups/index.cfm?Action=showuser&entrykey=#urlencodedformat(q_select_comments.userkey)#">#htmleditformat(a_str_username)#</a>						
						</td>
						<td valign="top">
							#lsdateformat(q_select_comments.dt_created, "dd.mm.yy")#
						</td>
						<!---
						<cfif struct_rights.delete is true>
							<img src="/images/del.gif" width="12" height="12" border="0" align="absmiddle">
						</cfif>
						--->
						
					  </tr>
					  </cfloop>
					</table>


					  
				</td>
			  </tr>

			  </cfif>		
			  
			 </cfoutput>
			</table>
					

</cfsavecontent>
			
		
		<!---

			<table border="0" cellspacing="0" cellpadding="6" width="240">
			  			  

			  
			  <!--- show related tasks ...
			  	load all tasks and select the desired items ... --->
		
			<!---<cfinvoke component="#request.a_str_component_tasks#" method="GetTasks" returnvariable="stReturn">
			  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			  <cfinvokeargument name="loadnotice" value="false">
			</cfinvoke>
			
			<cfset q_select_tasks = stReturn.q_select_tasks>
			  <tr>
				<td class="bb">Verwandte Aufgaben</td>
			  </tr>
			  <tr>
				<td>
				<!---<cfdump var="#stReturn#">--->
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
			  </tr>--->
			  
			  <!--- is the user is allowed to that, let him watch the log
			  
			  	owner or main user --->
			  <cfif (q_select_task.userkey is request.stSecurityContext.myuserkey)>
			  
			  <cfinvoke component="#request.a_str_component_logs#" method="GetLogEntriesForObject" returnvariable="q_select_log">
			  	<cfinvokeargument name="entrykey" value="#url.entrykey#">
				<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			  </cfinvoke>
			  <tr>
				<td class="bb"><cfoutput>#GetLangVal('adm_wd_logbook')#</cfoutput> (<cfoutput>#q_select_log.recordcount#</cfoutput>)</td>
			  </tr>			  
			  <cfif q_select_log.recordcount is 0>
			  <tr>
			  	<td>Keine Eintraege</td>
			  </tr>
			  <cfelse>			 
			  <tr>
			  	<td>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
				  	<td class="addinfotext"><cfoutput>#GetLangVal('cm_ph_date_time')#</cfoutput></td>
					<td class="addinfotext"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput></td>
					<td class="addinfotext"><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
				  </tr>
				<cfoutput query="q_select_log" startrow="1" maxrows="5">
						
						<cfinvoke component="/components/management/users/cmp_user" method="GetUsernamebyentrykey" returnvariable="a_str_username">
							<cfinvokeargument name="entrykey" value="#q_select_log.userkey#">
						</cfinvoke>
				  <tr>
					<td valign="top">#dateformat(q_select_log.dt_done, "dd.mm.yy")# #TimeFormat(q_select_log.dt_done, "HH:mm")#</td>
					<td valign="top">#Shortenstring(a_str_username, 20)#</td>
					<td valign="top">#q_select_log.actionname#</td>
				  </tr>
				</cfoutput>
				<cfif q_select_log.recordcount GT 5>
					<tr>
						<td colspan="3">
						<a href="#">weitere Eintraege anzeigen</a>
						</td>
					</tr>
				</cfif>
				</table>

				
				</td>
			  </tr>
			  </cfif>
			  </cfif>
			</table>

		
		
		
		--->



	<cfsavecontent variable="a_str_buttons">
			<input class="btn btn-primary" type="button" name="frm_btn_edit_task" onClick="EditThisTaskNow();" value="<cfoutput>#GetLangVal('cm_wd_edit')#</cfoutput>">
			<input class="btn btn-primary" type="button" name="frm_btn_delete_task" onClick="DeleteThisTaskNow();" value="<cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput>">
			
			<cfif q_select_task.status NEQ 0>
				<input class="btn btn-primary" type="button" onClick="UpdateStatusOfThisTaskNow(0);" name="frm_set_done" value="<cfoutput>#GetLangVal('tsk_ph_set_done')#</cfoutput>">
			<cfelse>
				<input class="btn btn-primary" type="button" onClick="UpdateStatusOfThisTaskNow(1);" name="frm_set_done" value="<cfoutput>#GetLangVal('tsk_ph_set_open')#</cfoutput>">
			</cfif>
		
	</cfsavecontent>

	
		
		<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_task'), a_str_buttons, a_str_task_view)#</cfoutput>
	
