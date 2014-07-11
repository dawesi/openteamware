<!--- 

	this is the common part for editing and creating new tasks
	
	--->

<!--- display source --->
<cfparam name="url.source" type="string" default="">
<cfparam name="NewOrEditTask.action" type="string" default="create">
<cfparam name="NewOrEditTask.query" type="query" default="#QueryNew('title,notice,status,priority,dt_due,categories,percentdone,actualwork,totalwork,assignedtouserkeys,private')#">

<cfif NewOrEditTask.query.recordcount IS 0>
	<cfset tmp = QueryAddRow(NewOrEditTask.query, 1)>
	<cfset tmp = QuerySetCell(NewOrEditTask.query, 'status', 1, 1)>
	<cfset tmp = QuerySetCell(NewOrEditTask.query, 'priority', 2, 1)>
	<cfset tmp = QuerySetCell(NewOrEditTask.query, 'private', 0, 1)>	
</cfif>

<!--- assign users to this task (by url parameter --->
<cfif StructKeyExists(url, 'assigned_userkey') AND Len(url.assigned_userkey) GT 0>
	<cfset tmp = QuerySetCell(NewOrEditTask.query, 'assignedtouserkeys', url.assigned_userkey, 1)>
</cfif>

<input type="hidden" name="frmsource" value="<cfoutput>#url.source#</cfoutput>">

<table class="table table_details table_edit_form">
<cfoutput>
#application.components.cmp_tools.GenerateEditingTableRow(datatype = 'string', field_name = GetLangVal('cm_wd_subject'), input_name = 'frmtitle', input_value = NewOrEditTask.query.title)#
#application.components.cmp_tools.GenerateEditingTableRow(datatype = 'memo', field_name = GetLangVal('cm_wd_text'), input_name = 'frmNotice', input_value = NewOrEditTask.query.notice)#
</cfoutput>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal("cm_wd_status")#</cfoutput>:</td>
	<td>
		<select name="frmstatus">
			<option value="0" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.status, 0)#</cfoutput>><cfoutput>#GetLangVal("tsk_wd_done")#</cfoutput>	
			<option value="1" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.status, 1)#</cfoutput>><cfoutput>#GetLangVal("tsk_ph_status_notstartedyet")#</cfoutput>
			<option value="2" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.status, 2)#</cfoutput>><cfoutput>#GetLangVal("tsk_ph_status_inprogress")#</cfoutput>
			<option value="3" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.status, 3)#</cfoutput>><cfoutput>#GetLangVal("tsk_wd_status_deferred")#</cfoutput>
		</select>
		&nbsp;&nbsp;
		<input style="width:auto; " type="text" name="frmpercentdone" size="2" maxlength="2" value="<cfoutput>#val(NewOrEditTask.query.percentdone)#</cfoutput>">% <cfoutput>#GetLangVal("tsk_wd_done")#</cfoutput>
		
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal("tsk_wd_due")#</cfoutput>:
	</td>
	<td>
	
		<input type="text" readonly="1" size="20" name="frmdt_due" id="frmdt_due" value="<cfoutput>#lsdateformat(NewOrEditTask.query.dt_due, request.a_str_default_dt_format)#</cfoutput>" />
	
		<input style="width:auto; " align="absmiddle" <cfif NOT isDate(NewOrEditTask.query.dt_due)>checked</cfif> onClick="ChangeNoDueDateEnabled(this.checked);" class="noborder" type="checkbox" name="frmNoduedate" value="1" /> <cfoutput>#GetLangVal("tsk_ph_noduedate")#</cfoutput>
	
		<cfif NOT isDate(NewOrEditTask.query.dt_due)>
	
			<!--- hide selection ... --->
			<script type="text/javascript">
				ChangeNoDueDateEnabled(true);
			</script>
			
		</cfif>
	</td>
</tr>
<tr style="display:none;">
	<td></td>
	<td>
	<input type="checkbox" class="noborder" name="frmDueAlert"> <cfoutput>#GetLangVal("tsk_ph_send_remind_on_the_day_before")#</cfoutput>
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal("cm_wd_priority")#</cfoutput>:
	</td>
	<td>
	<select name="frmPriority">
		<option value="1" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.Priority, 1)#</cfoutput>><cfoutput>#GetLangVal("cm_wd_priority_low")#</cfoutput>
		<option value="2" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.Priority, 2)#</cfoutput>><cfoutput>#GetLangVal("cm_wd_priority_normal")#</cfoutput>
		<option value="3" <cfoutput>#WriteSelectedElement(NewOrEditTask.query.Priority, 3)#</cfoutput>><cfoutput>#GetLangVal("cm_wd_priority_high")#</cfoutput>		
	</select>
	</td>
</tr>
<script type="text/javascript">


	function ShowOrHideWorkgroupExtensions(workgroup_id)
	{
	if (workgroup_id == -1)
		{
		obj = findObj("trassignedto");
		obj.style.display="none";
		obj = findObj("tridproject");
		obj.style.display="none";		
		}
		else
			{
			obj = findObj("trassignedto");
			obj.style.display="";
			obj = findObj("tridproject");
			obj.style.display="";
			
			// load projects for this workgroup
			obj1 = findObj("frmavaliableprojectsforworkgroup"+workgroup_id);
			obj2 = findObj("frmProjectid");
			
			if (obj1 !== null)
				{
				var str1=obj1.value;
			
				var neuOption = new Option(strval);
				obj2.options[optionlength] = "(keinem Projekt zugeordnet)";
				obj2.options[optionlength].value = 0;
			
				var strnum=""
				var strval=""
				var s=0;
				var optionlength=1;
				while (str1.indexOf("|") > 0)
				{
				  s=str1.indexOf(";")
				  strval=str1.substr(0,s)
				  str1=str1.substr(s+1)
		
				  s=str1.indexOf("|")
				  strnum=str1.substr(0,s)
				  str1=str1.substr(s+1)
		
				  obj2.length = optionlength+1
				  var neuOption = new Option(strval);
				  obj2.options[optionlength] = neuOption;
				  obj2.options[optionlength].value = strnum;
				  optionlength=optionlength+1;
						
				}
				obj2.selectedIndex = 0;						
				} else
					{
					// no items avalible
					obj2.length = 1;
					var neuOption = new Option(strval);
					obj2.options[optionlength] = "(keinem Projekt zugeordnet)";
					obj2.options[optionlength].value = 0;
					obj2.selectedIndex = 0;					
					}
			}
	}
	function setworkgroupusername(username)
		{
		obj = findObj("frmAssignedTo");
		obj.value = username;
		}
</script>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput>:</td>
	<td valign="top">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td id="idtdopenworkgorupiframe">
		<a href="javascript:OpenWorkgroupShareDialog('<cfoutput>#sEntrykey#</cfoutput>');"><cfoutput>#GetLangVal('cm_ph_workgroups_share_with_groups')#</cfoutput></a>
		</td>
		<td id="idtdcloseworkgroupiframe" style="padding:6px;display:none;" class="mischeader bl br bt" align="center">
		<a href="javascript:CloseWorkgroupShareIframe();">[X] <cfoutput>#GetLangVal('cm_wd_close_btn_caption ')#</cfoutput></a>
		
		</td>
	  </tr>
	</table>

	<div id="iddivworkgroups" style="display:none;width:100%;height:80px;" class="b_all">
	<iframe id="idiframeworkgroups" name="idiframeworkgroups" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" src="/tools/security/permissions/iframe/?servicekey=<cfoutput>#urlencodedformat(request.sCurrentServiceKey)#</cfoutput>&sectionkey=&entrykey=<cfoutput>#urlencodedformat(sEntrykey)#</cfoutput>"></iframe>
	</div>	
	
	</td>
</tr>


<tr style="display:none; ">
	<td class="field_name">Projekt(e):</td>
	<td>
	<select name="frmprojectkeys" class="addinfotext" style="width:270px;">
		<option value="">(keinem Projekt zuweisen)</option>
		
	</select>
	<!---&nbsp;&nbsp;
	<a class="addinfotext" href="javascript:OpenProjectConnections('<cfoutput>#jsstringformat(sEntrykey)#</cfoutput>','<cfoutput>#request.sCurrentServiceKey#</cfoutput>', '', document.formeditnewtask.frmprojectkeys.value);">Bearbeiten ...</a>--->
	</td>
</tr>
<input type="hidden" name="frmassignedtouserkeys" value="<cfoutput>#htmleditformat(NewOrEditTask.query.assignedtouserkeys)#</cfoutput>">
<tr>
	<td class="field_name"><cfoutput>#GetLangVal("task_ph_assignedto")#</cfoutput>:</td>
	<td>
	<select name="frmassigendto" size="1"  style="width:270px;">
		<cfif Len(NewOrEditTask.query.assignedtouserkeys) IS 0>
		<option value="">(<cfoutput>#GetLangVal('cm_ph_none_selected')#</cfoutput>)</option>
		</cfif>
		<cfloop list="#NewOrEditTask.query.assignedtouserkeys#" delimiters="," index="a_str_userkey">
		
			<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
				<cfinvokeargument name="entrykey" value="#a_str_userkey#">
			</cfinvoke>
		
		<cfoutput><option value="#htmleditformat(a_str_userkey)#">#htmleditformat(a_str_username)#</option></cfoutput>
		</cfloop>
	</select>
	&nbsp;&nbsp;
	<a href="javascript:OpenAssignTaskWindow('<cfoutput>#jsstringformat(sEntrykey)#</cfoutput>',document.formeditnewtask.frmassignedtouserkeys.value);">Bearbeiten ...</a>
	</td>
</tr>
<cfif IsInternalIPorUser()>

	<cfif NewOrEditTask.action IS 'create' AND Len(url.assigned_addressbookkeys) GT 0>
	
		<cfset a_struct_filter = StructNew()>
		<cfset a_struct_filter.entrykeys = url.assigned_addressbookkeys>
	
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
			<cfinvokeargument name="filter" value="#a_struct_filter#">
			<cfinvokeargument name="convert_lastcontact_utc" value="false">
		</cfinvoke>
		
		<cfset q_Select_contacts = stReturn_contacts.q_Select_contacts>
		
		<cfif q_Select_contacts.recordcount GT 0>
	
		<input type="hidden" name="frm_assigned_addressbookkeys" value="<cfoutput>#url.assigned_addressbookkeys#</cfoutput>">
		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput>:
			</td>
			<td>
				<cfoutput query="q_Select_contacts">
					#htmleditformat(q_Select_contacts.surname)#, #htmleditformat(q_Select_contacts.firstname)# (#htmleditformat(q_Select_contacts.company)#)
					<br>
				</cfoutput>
			</td>
		</tr>
		</cfif>
	</cfif>
	
</cfif>

<tr id="trassignedto" style="display:none;">
	<td class="field_name"><cfoutput>#GetLangVal("task_ph_assignedto")#</cfoutput>:</td>
	<td>
	
	<script type="text/javascript">
	function OpenAssignWindowOOOLLLDDD() {
	
		if (frmnewtask.frmWorkgroup_id.value == -1)
			{
			alert('Sie haben keine Arbeitsgruppe ausgew&auml;hlt');
			
			}
	    mywindow=open('../workgroups/show_workgroup_members_to_assign.cfm?workgroup_id='+frmnewtask.frmWorkgroup_id.value,'show_select_date_notepad','resizable=no,width=350,height=270');
	    mywindow.location.href = '../workgroups/show_workgroup_members_to_assign.cfm?workgroup_id='+frmnewtask.frmWorkgroup_id.value;
	    if (mywindow.opener == null) mywindow.opener = self;
		mywindow.focus();
	}
	</script>
	
	<input type="text" name="frmAssignedTo" value="" size="40" readonly="true">&nbsp;<input onClick="OpenAssignWindow();" type="button" value="<cfoutput>#GetLangVal("tsk_wd_select_assigned_user")#</cfoutput>">
	</td>
</tr>
<input type="hidden" name="frmProjectid" value="0">
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput>:
	</td>
	<td>
		<input type="Text" name="frmcategories" required="No" maxlength="250" size="40" style="width:270px;" value="<cfoutput>#htmleditformat(NewOrEditTask.query.categories)#</cfoutput>">
	
		&nbsp;&nbsp;
		<a href="javascript:OpenCategoriesPopup();"><cfoutput>#GetLangVal('cm_wd_edit')#</cfoutput> ...</a>

	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('tsk_ph_total_expenditure')#</cfoutput>:
	</td>
	<td>
		<input type="text" style="width:auto" value="<cfoutput>#htmleditformat( NewOrEditTask.query.totalwork )#</cfoutput>" name="frmtotalwork" size="4" maxlength="4" /> <cfoutput>#GetLangVal('cm_wd_hours')#</cfoutput>
		&nbsp;&nbsp;&nbsp;
		<cfoutput>#GetLangVal('tsk_ph_input_current')#</cfoutput>: <input type="text" style="width:auto" name="frmactualwork" size="4" maxlength="4" value="<cfoutput>#htmleditformat( NewOrEditTask.query.actualwork )#</cfoutput>" /> <cfoutput>#GetLangVal('cm_wd_hours')#</cfoutput>
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_private')#</cfoutput>:
	</td>
	<td>
		<input type="checkbox" style="width:auto; " name="frmprivate" value="1" <cfoutput>#writecheckedelement(NewOrEditTask.query.private, 1)#</cfoutput> class="noborder"> <cfoutput>#GetLangVal('cm_wd_yes')#</cfoutput>
	</td>
</tr>
<tr>
	<td></td>
	<td>
		<input type="submit" class="btn btn-primary" name="frmSubmitAdd" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>" />
	</td>
</tr>
</table>

<script type="text/javascript">
	$('#frmdt_due').calendar();
</script>