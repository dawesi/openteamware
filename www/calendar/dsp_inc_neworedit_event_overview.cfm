<!--- //

	Module:		Calendar
	Action:		CreateEvent / EditEvent
	Description:Show first tab with overview 
	

// --->


<table class="table table_details table_edit_form">
  <tr>
    <td class="field_name" style="font-weight:bold; ">
		<cfoutput>#GetLangVal('cal_wd_title')#</cfoutput>
	</td>
    <td>
		<input style="font-weight:bold;" type="text" name="frmtitle" size="60" value="<cfoutput>#htmleditformat(Variables.NewOrEditEvent.query.title)#</cfoutput>" />
	</td>
	<td class="field_name">
		<cfoutput>#GetLangVal('cal_ph_private_item')#</cfoutput>
	</td>
	<td>
		  <input style"width:auto;" class="autow" onClick="SetPrivateItem(this.value);" type="checkbox" id="frmprivateevent" name="frmprivateevent" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.privateevent, 1)#</cfoutput> value="1" class="noborder" />
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#GetLangVal('cal_wd_start')#</cfoutput>
	</td>
	<td>
		<input onChange="CheckOtherEvents('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#');return true;" onBlur="CheckOtherEvents('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#');return true;" type="text" name="frm_dt_start" id="frm_dt_start" size="8" value="<cfoutput>#lsDateFormat(Variables.NewOrEditEvent.Query.date_start, request.a_str_default_dt_format)#</cfoutput>" class="autow" />
		
		<a onClick="cal1.select(document.formneworeditevent.frm_dt_start,'anchor1','<cfoutput>#request.a_str_default_js_dt_format#</cfoutput>'); return false;" href="#" id="anchor1"><img src="/images/si/calendar.png" alt="" class="si_img" /></a>
		
		<select name="frm_dt_start_hour" onChange="CheckOtherEvents('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#');" class="autow">
			<cfloop from="0" to="23" index="a_int_hour">
				<cfoutput>
				<option #writeselectedelement(a_int_hour, hour(Variables.NewOrEditEvent.Query.date_start))# value="#a_int_hour#">#a_int_hour#</option>
				</cfoutput>
			</cfloop>
		</select>
		:
		<select name="frm_dt_start_minute" onChange="CheckOtherEvents('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#');" class="autow">
			<cfloop from="0" to="59" index="a_int_minute" step="5">
				<cfoutput>
				<option #writeselectedelement(a_int_minute, minute(Variables.NewOrEditEvent.Query.date_start))# value="#a_int_minute#">#a_int_minute#</option>
				</cfoutput>
			</cfloop>
		</select>
			
		&nbsp;&nbsp;
		<input type="checkbox" name="frmwholedayevent" class="autow" value="1" class="noborder" onClick="SetWholeDayEvent(this.checked);" /> <cfoutput>#GetLangVal('cal_ph_wholedayevent')#</cfoutput>
		
	</td>
	<td class="field_name">
		<cfoutput>#GetLangVal('cal_wd_colour')#</cfoutput>
	</td>
	<td>
          <select name="frmcolor" class="autow">
              <option value=""></option>
              <option value="#FF9484" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.color, '##FF9484')#</cfoutput> style="background-color:#FF9484; ">&nbsp;</option>
              <option value="#C1C8D9" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.color, '##C1C8D9')#</cfoutput> style="background-color:#C1C8D9; ">&nbsp;</option>
              <option value="#A5DE63" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.color, '##A5DE63')#</cfoutput> style="background-color:#A5DE63; ">&nbsp;</option>
              <option value="#FFB573" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.color, '##FFB573')#</cfoutput> style="background-color:#FFB573; ">&nbsp;</option>
              <option value="#D6CE84" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.color, '##D6CE84')#</cfoutput> style="background-color:#D6CE84; ">&nbsp;</option>
              <option value="#FFE773" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.color, '##FFE773')#</cfoutput> style="background-color:#FFE773; ">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          </select>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#GetLangVal('cal_wd_duration')#</cfoutput>
	</td>
	<td>
		<div id="iddivdurationsimple">
			<select name="frmdurationsimple" class="autow">
				<option value="15">15 <cfoutput>#GetLangVal('cal_wd_minutes')#</cfoutput></option>
				<option value="30">30 <cfoutput>#GetLangVal('cal_wd_minutes')#</cfoutput></option>
				<option value="45" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.action, 'create')#</cfoutput>>45 <cfoutput>#GetLangVal('cal_wd_minutes')#</cfoutput></option>
				<cfloop from="1" to="24" step="1" index="a_int_hour">
				<cfoutput><option value="#(a_int_hour*60)#">#a_int_hour# #GetLangVal('cal_wd_hours')#</option></cfoutput>
				</cfloop>
			</select>	
			
			&nbsp;&nbsp;<a href="javascript:ChangeDurationType('exact');"><cfoutput>#GetLangVal('cal_ph_newedit_set_exact_time')#</cfoutput></a>	
		</div>
	


		<div id="iddivdurationexact"  style="display:none;">
		
			<input class="autow" type="text" name="frm_dt_end" size="8" onchange="CheckOtherEvents('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#');" value="<cfoutput>#lsDateFormat(Variables.NewOrEditEvent.Query.date_end, request.a_str_default_dt_format)#</cfoutput>" />
			
			<a onClick="cal1.select(document.formneworeditevent.frm_dt_end,'anchor2','<cfoutput>#request.a_str_default_js_dt_format#</cfoutput>'); return false;" href="#" id="anchor2"><img src="/images/si/calendar.png" alt="" class="si_img" /></a>
			
				<select name="frm_dt_end_hour" class="autow">
					<cfloop from="0" to="23" index="a_int_hour">
						<cfoutput>
						<option #writeselectedelement(a_int_hour, hour(Variables.NewOrEditEvent.Query.date_end))# value="#a_int_hour#">#a_int_hour#</option>
						</cfoutput>
					</cfloop>
				</select>
				:
				<select name="frm_dt_end_minute" class="autow">
					<cfloop from="0" to="59" index="a_int_minute" step="5">
						<cfoutput>
						<option #writeselectedelement(a_int_minute, minute(Variables.NewOrEditEvent.Query.date_end))# value="#a_int_minute#">#a_int_minute#</option>
						</cfoutput>
					</cfloop>
				</select>
			
			&nbsp;&nbsp;<a href="javascript:ChangeDurationType('simple');"><cfoutput>#GetLangVal('cal_ph_newedit_select_basic_time')#</cfoutput></a>
			
		</div>
	
	</td>
	    <td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput>
		</td>
	    <td>
			<input type="text" name="frmcategories" size="60" value="<cfoutput>#htmleditformat(Variables.NewOrEditEvent.Query.categories)#</cfoutput>" maxlength="255" />&nbsp;&nbsp;<a href="javascript:OpenCategoriesPopup();"><img src="/images/si/pencil.png" class="si_img" /></a>
		</td>
  </tr>

<!--- 		   --->

  <tr id="idtrotherevents">
  	<td class="field_name">
	</td>
  	<td>
		<div id="id_div_related_other_events"></div>
	</td>
	<td class="field_name"></td>
	<td><select name="frmshowas" class="autow">
              <option value="0" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.showtimeas, '0')#</cfoutput>><cfoutput>#GetLangVal('cal_wd_showas_0')#</cfoutput></option>
              <option value="1" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.showtimeas, '1')#</cfoutput>><cfoutput>#GetLangVal('cal_wd_showas_1')#</cfoutput></option>
              <option value="2" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.showtimeas, '2')#</cfoutput>><cfoutput>#GetLangVal('cal_wd_showas_2')#</cfoutput></option>
              <option value="3" <cfoutput>#WriteSelectedElement(Variables.NewOrEditEvent.Query.showtimeas, '3')#</cfoutput>><cfoutput>#GetLangVal('cal_wd_showas_3')#</cfoutput></option>
          </select></td>
  </tr>
  <tr>
    <td class="field_name">
		<cfoutput>#GetLangVal('cal_wd_location')#</cfoutput>
	</td>
    <td>
		<input type="text" name="frmlocation" id="frmlocation" size="60" value="<cfoutput>#htmleditformat(Variables.NewOrEditEvent.Query.location)#</cfoutput>" maxlength="255" />
	</td>
		<td class="field_name">
		<cfif Variables.NewOrEditEvent.action is 'create'>
			<cfoutput>#GetLangVal('cal_ph_newedit_create_for')#</cfoutput>
		</cfif>
		</td>
		<td>
  		<cfif Variables.NewOrEditEvent.action is 'create'>
			  <!---
				is this user able to act as a 'secretary' (create events for other users)?
				
				or in one of the workgroups in the "mainuser" role?
				
				--->

			<select name="frmuserkey">
				<option value="<cfoutput>#htmleditformat(request.stSecurityContext.myuserkey)#</cfoutput>"><cfoutput>#GetLangVal('cal_ph_newedit_createfor_myself')#</cfoutput> (<cfoutput>#request.stSecurityContext.myusername#</cfoutput>)</option>
				
				<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">
			
					 <cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupStandardPermissionsForService" returnvariable="a_str_permissions">
						<cfinvokeargument name="workgroupkey" value="#request.stSecurityContext.q_select_workgroup_permissions.workgroup_key#">
						<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
						<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
					 </cfinvoke>
					 
					 <cfif ListFindNoCase(a_str_permissions, 'delegate') GT 0>
						<!--- ok, load users ... --->
						
						<cfinvoke component="#application.components.cmp_workgroups#" method="GetWorkgroupMembers" returnvariable="q_select_workgroup_members">
							<cfinvokeargument name="workgroupkey" value="#request.stSecurityContext.q_select_workgroup_permissions.workgroup_key#">
						</cfinvoke>
						
						<!---<cfdump var="#q_select_workgroup_members#">--->
						
						<cfloop query="q_select_workgroup_members">
							<cfif CompareNoCase(q_select_workgroup_members.userkey, request.stSecurityContext.myuserkey) NEQ 0>
							<option #writeselectedelement(Variables.NewOrEditEvent.assigned_userkey,q_select_workgroup_members.userkey)# style="background-color:orange; " value="#q_select_workgroup_members.userkey#">#q_select_workgroup_members.fullname# (#q_select_workgroup_members.username#)</option>
							</cfif>
						</cfloop>
						
					 </cfif>
				 
				 </cfoutput>
				
				<!--- secretary mode --->
				<cfif q_select_attended_users.recordcount GT 0>
					
					<option class="mischeader" value="<cfoutput>#htmleditformat(request.stSecurityContext.myuserkey)#</cfoutput>">- <cfoutput>#q_select_attended_users.recordcount#</cfoutput> Secretary -</option>
					
					<cfoutput query="q_select_attended_users">
					<option #writeselectedelement(Variables.NewOrEditEvent.assigned_userkey,q_select_attended_users.userkey)# value="#htmleditformat(q_select_attended_users.userkey)#" style="background-color:orange;">#application.components.cmp_user.GetUsernamebyentrykey(q_select_attended_users.userkey)#</option>
					</cfoutput>
					
				</cfif>
				
			</select>
			
		&nbsp;&nbsp;&nbsp;
		<cfelse>
		
			<input type="hidden" name="frmuserkey" value="<cfoutput>#htmleditformat(Variables.NewOrEditEvent.Query.userkey)#</cfoutput>" />
		
			<cfif CompareNoCase(request.stSecurityContext.myuserkey, Variables.NewOrEditEvent.Query.userkey) NEQ 0>
				<!--- item for a differnt user ... --->
				<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_other_user_data">
					<cfinvokeargument name="userkey" value="#Variables.NewOrEditEvent.Query.userkey#">
				</cfinvoke>	  
				
				<cfif q_select_other_user_data.smallphotoavaliable  IS 1>
					<img src="/tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#Variables.NewOrEditEvent.Query.userkey#</cfoutput>">
					<br>
				<cfelse>
					<img src="/images/si/user.png" class="si_img" />
				</cfif>
	  				<cfoutput>
					<a href="/workgroups/?action=showuser&entrykey=#urlencodedformat(q_select_other_user_data.entrykey)#"> #GetLangVal('cal_ph_is_event_of')# <b>#htmleditformat(q_select_other_user_data.firstname)# #htmleditformat(q_select_other_user_data.surname)#</b> (#htmleditformat(q_select_other_user_data.username)#)</a>
					</cfoutput>
				<br>
			</cfif>
		</cfif>
		
		</td>
  </tr>
  <tr>
    <td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
	</td>
    <td valign="top">
		<textarea  name="frmdescription" class="b_all" rows="3" cols="60" style="font-family:Verdana;font-size:11px;"><cfoutput>#htmleditformat(newOrEditEvent.query.description)#</cfoutput></textarea>
	</td>
  </tr> 
 
	  
	  <cfif q_select_virtual_calendars.recordcount GT 0>
		  <tr>
		      <td class="field_name">
		    	<cfoutput>#GetLangVal('cal_wd_virtual_calendar')#</cfoutput>
		      </td>
		      <td>
                  <select name="frmvirtualcalendarkey">
    				<option value=""></option>
					<cfoutput query="q_select_virtual_calendars">
						<option value="#q_select_virtual_calendars.entrykey#" #writeselectedelement(q_select_virtual_calendars.entrykey, neworeditevent.query.virtualcalendarkey)#>#htmleditformat(q_select_virtual_calendars.title)#</option>
					</cfoutput>
				</select>
		      </td>
		  </tr>
	</cfif>
  
  <cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount GT 0>
  <tr>
  	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput>
	</td>
	<td>
		<a href="javascript:OpenWorkgroupShareDialog('<cfoutput>#jsstringformat(Variables.NewOrEditEvent.query.entrykey)#</cfoutput>');"><cfoutput>#GetLangVal('cm_ph_workgroups_share_with_groups')#</cfoutput></a><!--- | Aktuell: Keine Freigabe--->
	</td>
  </tr>
  </cfif>
  <tr>
  	<td></td>
	<td>
	<div id="iddivworkgroups" style="display:none;width:100%;height:80px;" class="b_all">
		<iframe id="idiframeworkgroups" name="idiframeworkgroups" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" src="/tools/security/permissions/iframe/?servicekey=<cfoutput>#urlencodedformat(request.sCurrentServiceKey)#</cfoutput>&sectionkey=&entrykey=<cfoutput>#urlencodedformat(Variables.NewOrEditEvent.query.entrykey)#</cfoutput>"></iframe>
	</div>
	
	</td>
  </tr>  
  
    <cfif Variables.NewOrEditEvent.action is 'edit'>
  
		<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
			<cfinvokeargument name="entrykey" value="#Variables.NewOrEditEvent.query.entrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		</cfinvoke>  
		
		<cfif q_select_shares.recordcount GT 0>
			<script type="text/javascript">
				$('#iddivworkgroups').show();
			</script>
		</cfif>
	
	</cfif>
</table>

<cfif Variables.NewOrEditEvent.action is 'edit'>
	<script type="text/javascript">
		ChangeDurationType('exact');
	</script>
</cfif>

