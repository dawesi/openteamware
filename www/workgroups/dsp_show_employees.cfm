<cfexit method="exittemplate">

<cf_disp_navigation mytextleft="#GetLangVal('cm_wd_employees')#">
<br>

<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount IS 0>
	<!--- not member within a single workgroup --->
	<h4><cfoutput>#GetLangVal('wrkpg_ph_not_member_in_a_single_workgroup')#</cfoutput></h4>
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_company_users">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<!--- get the company name ... --->
<cfset a_str_company_name = application.components.cmp_customer.GetCustomerNameByEntrykey(request.stSecurityContext.mycompanykey)>

<div class="bb">
<h4 style="margin-bottom:0px;"><img src="/images/admin/img_people.png" align="absmiddle"> Mitarbeiter <cfoutput>#a_str_company_name#</cfoutput></h4>
</div>
<table  border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
  	<td class="bb">&nbsp;</td>
	<td class="bb">
		<b>Name</b>
	</td>
	<td align="right" class="bb">
	sortieren nach 
	<select name="frmorderby">
		<option value="name">Namen</option>
		<option value="department">Department</option>
	</select>
	</td>
  </tr>
  <cfoutput query="q_select_company_users">
  <tr id="idtremployee#q_select_company_users.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">  	
	<td class="bb" align="right">
	<cfif q_select_company_users.smallphotoavaliable IS 1>
	<img src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_company_users.entrykey)#">
	<cfelse>
	&nbsp;
	</cfif>
	</td>
    <td class="bb">
	<a href="../workgroups/default.cfm?action=ShowUser&entrykey=#urlencodedformat(q_select_company_users.entrykey)#"><b>#ucase(q_select_company_users.surname)#, #q_select_company_users.firstname#</b></a>
	
	<br>
	
	#q_select_company_users.aposition#
	
	<cfif Len(q_select_company_users.department)>
		<font class="addinfotext">Abteilung</font> #q_select_company_users.department#
	</cfif>
	&nbsp;	
	</td>
    <td class="bb">
	E-Mail: <a href="../email/default.cfm?action=composemail&to=#urlencodedformat(q_select_company_users.username)#">#q_select_company_users.username#</a>
	<br>
	<cfif Len(q_select_company_users.telephone) GT 0>Fon: #q_select_company_users.telephone#&nbsp;</cfif>
	
	<cfif Len(q_select_company_users.mobilenr) GT 0>Mobil: #q_select_company_users.mobilenr#</cfif>	
	</td>
  </tr>
  </cfoutput>
</table>
