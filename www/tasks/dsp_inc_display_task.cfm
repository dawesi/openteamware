

<cfoutput query="q_select_task">
			  <tr>
				<td colspan="2" class="bb"><b>#GetLangVal('tsk_wd_summary')#</b></td>
			  </tr>
			  <tr>
				<td align="right" valign="top">#GetLangVal('tsk_wd_title')#:</td>
				<td valign="top">
				<b>#htmleditformat(checkzerostring(q_select_task.title))#</b>
				</td>
			  </tr>
			  <tr>
				<td align="right" valign="top">#GetLangVal('tsk_wd_text')#:</td>
				<td>

				<cfset a_str_text = ReplaceNoCase(htmleditformat(trim(q_select_task.notice)), chr(10), "<br>", "ALL")>
				#a_str_text#
				</td>
			  </tr>
			  

			 	  			  
			  <tr>
				<td valign="top" align="right">Status:</td>
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
				<td align="right">erledigt:</td>
				<td>
				#q_select_task.dt_done#
				</td>
			  </tr>
			  </cfif>
			  <tr>
				<td align="right">Prioritaet:</td>
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
				<td align="right" valign="top">Kategorien:</td>
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
			  	<td align="right" valign="top">Zustaendig:</td>
				<td valign="top">
				<cfloop list="#q_select_task.assignedtouserkeys#" delimiters="," index="a_str_userkey">
				
					<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
						<cfinvokeargument name="entrykey" value="#a_str_userkey#">
					</cfinvoke>
					<a href="../workgroups/index.cfm?action=ShowUser&entrykey=#urlencodedformat(a_str_userkey)#">#htmleditformat(a_str_username)#</a><br>					
					
				</cfloop>
				</td>
			  </tr>
			  </cfif>
			  
			  <cfif q_select_task.status neq 0>
			  <!--- not yet done, show the due date --->
			  <tr>
				<td align="right">Faellig:</td>
				<td>
				<cfif isDate(q_select_task.dt_due)>
				<a href="../calendar/index.cfm?action=ViewDay&date=#dateformat(q_select_task.dt_due, "mm/dd/yyyy")#">#lsdateformat(q_select_task.dt_due, "ddd, dd.mm.yy")#</a>
				<cfelse>
				n/a
				</cfif>
				</td>
			  </tr>
			  </cfif>
			  <tr>
				<td colspan="2" class="bb"><b>Details</b></td>
			  </tr>
			  <tr>
				<td align="right">Ist-Aufwand:</td>
				<td>
				<cfif val(q_select_task.actualwork) gt 0>
				#q_select_task.actualwork#
				<cfelse>
				n/a
				</cfif>
				</td>
			  </tr>
			  <tr>
				<td align="right">Totalaufwand:</td>
				<td>
				<cfif val(q_select_task.totalwork) gt 0>
				#q_select_task.totalwork#
				<cfelse>
				n/a
				</cfif>
				</td>
			  </tr>
 			   <tr>
				<td align="right" valign="top">erstellt:</td>
				<td valign="top">
				#lsdateformat(q_select_task.dt_created, "dd.mm.yyy")# #TimeFormat(q_select_task.dt_created, "HH:mm")#
				
				<cfif q_select_task.userkey neq request.stSecurityContext.myuserkey>
						
						<cfinvoke component="/components/management/users/cmp_user" method="GetUsernamebyentrykey" returnvariable="a_str_username">
							<cfinvokeargument name="entrykey" value="#q_select_task.userkey#">
						</cfinvoke>
				von #a_str_username#
				
				<cfif struct_rights.managepermissions is true>
					<br><a href="act_take_ownership.cfm?entrykey=#urlencodedformat(q_select_task.entrykey)#">Eigentuemerschaft dieses Objektes uebernehmen</a>
				</cfif>
				
				</cfif>
				</td>
			  </tr>
			  
			  <!--- load workgroups of object ... --->
			  <cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
					<cfinvokeargument name="entrykey" value="#q_select_task.entrykey#">
					<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
					<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
			  </cfinvoke>			  			  
				
			  <cfif q_select_shares.recordcount GT 0>
			  <tr>
				<td colspan="2" class="bb"><b>Arbeitsgruppen-Freigabe</b></td>
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
</cfoutput>