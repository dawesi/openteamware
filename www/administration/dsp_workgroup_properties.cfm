<!--- //

	Module:		Admintool
	Action:		workgroupproperties
	Description:display the workgroup properties 
	
// --->

<cfinclude template="dsp_inc_select_company.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="queries/q_select_workgroups.cfm">

<cfquery name="q_select_workgroup" dbtype="query">
SELECT
	*
FROM
	q_select_workgroups
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfquery name="q_select_sub_workgroups" dbtype="query">
SELECT
	*
FROM
	q_select_workgroups
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfif q_select_workgroup.recordcount is 0>
	not found
	<cfabort>
</cfif>

<!--- load roles for this workgroup ... --->
<cfset SelectWorkgroupRoles.workgroupkey = url.entrykey>
<cfinclude template="queries/q_select_roles.cfm">

<!--- load workgroup members ... --->
<cfset SelectWorkgroupMembersRequest.entrykey = url.entrykey>
<cfinclude template="queries/q_select_workgroup_members.cfm">

<h4 style="margin-bottom:5px;"><cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput> <cfoutput>#htmleditformat(q_select_workgroup.groupname)#</cfoutput></h4>

<cfsavecontent variable="a_str_content">

<table class="table table_details">
<cfoutput query="q_select_workgroup">
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:</td>
    <td>#htmleditformat(q_select_workgroup.groupname)#</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:</td>
    <td>#htmleditformat(q_select_workgroup.description)#</td>
  </tr>
  <!---<tr>
  	<td align="right">Unternehmen:</td>
	<td>
	#q_select_workgroup.companykey#
	</td>
  </tr>--->
  
  <!--- is this a sub workgroup? --->
  <cfif len(q_select_workgroup.parentkey) gt 0>
  
  <cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupnamebyEntryKey" returnvariable="sReturn">
  	<cfinvokeargument name="entrykey" value="#q_select_workgroup.parentkey#">
  </cfinvoke>
  
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('adm_ph_workgroups_subgroup_of')#</cfoutput>:</td>
    <td>
	<a href="index.cfm?action=workgroupproperties&entrykey=#urlencodedformat(q_select_workgroup.parentkey)##writeurltags()#">#sReturn#</a>
	</td>
  </tr>
  </cfif>
  
  <cfif q_select_sub_workgroups.recordcount gt 0>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('adm_ph_workgroups_subgroups')#</cfoutput>: <cfoutput>#q_select_sub_workgroups.recordcount#</cfoutput></td>
    <td valign="top">
	<cfloop query="q_select_sub_workgroups">
	<li><a href="index.cfm?action=workgroupproperties&entrykey=#urlencodedformat(q_select_sub_workgroups.entrykey)##writeurltags()#">#q_select_sub_workgroups.groupname#</a></li>
	</cfloop>
	</td>
  </tr>
  </cfif>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('cm_wd_color')#</cfoutput>:</td>
	<td>
		<div style="width:40px;background-color:#q_select_workgroup.colour#;border:silver solid 1px;">&nbsp;</div>
	</td>
  </tr>
</cfoutput>
</table>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	
	<cfset a_str_edit_location = 'index.cfm?action=workgroup.edit&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#' />
	<cfoutput>
	<input type="button" class="btn" value="#GetLangVal('cm_wd_edit')#" onclick="GotoLocHref('#a_str_edit_location#');" />
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_properties'), a_str_buttons, a_str_content)#</cfoutput>

<br />
 


<!--- load inherited members too?? --->

<cfsavecontent variable="a_str_content">
<table class="table table-hover">
  <tr class="tbl_overview_header">
    <td colspan="2"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('adm_wd_roles')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_created')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_workgroup_members">
	<!--- load username ... --->
	<cfset a_str_username = application.components.cmp_user.GetUsernamebyentrykey(q_select_workgroup_members.userkey) />
	
	<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#q_select_workgroup_members.userkey#">
	</cfinvoke>
	 
  <cfif StructkeyExists(stReturn, 'query')>
  <tr>
    <td>
	<img src="/images/si/user.png" class="si_img" /> #stReturn.query.surname#, #stReturn.query.firstname#
	</td>
	<td>
	<a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_workgroup_members.userkey)##writeurltags()#">&nbsp;#htmleditformat(a_str_username)#</a>
	</td>
    <td>
	<cfloop index="a_str_role" list="#q_select_workgroup_members.roles#" delimiters=",">
	
	<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="getrolenamebyentrykey" returnvariable="a_str_rolename">
		<cfinvokeargument name="entrykey" value="#a_str_role#">
	</cfinvoke>
	
	#a_str_rolename#
	
	</cfloop>	
	</td>
    <td>#lsdateformat(q_select_workgroup_members.dt_created, "dd.mm.yy")#</td>
    <td>
	<a href="index.cfm?action=user.edit.workgroupmembership&workgroupkey=#urlencodedformat(url.entrykey)#&userkey=#urlencodedformat(q_select_workgroup_members.userkey)##writeurltags()#"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_Wd_edit')#</a>
	
	&nbsp;&nbsp;
	<a href="index.cfm?action=workgroups.removeuser&workgroupkey=#urlencodedformat(url.entrykey)#&entrykey=#urlencodedformat(q_select_workgroup_members.userkey)##writeurltags()#"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('cm_wd_delete')#</a>
	</td>
  </tr>
  </cfif>
  </cfoutput>
</table>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<cfoutput>
	<cfset a_Str_loc = 'index.cfm?action=Addusertoworkgroup&workgroupkey=#urlencodedformat(url.entrykey)##writeurltags()#' />
	
	<input type="button" onclick="GotoLocHref('#a_Str_loc#');" value="#GetLangVal('adm_ph_workgroups_add_new_member')#" class="btn btn-primary" />
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_members'), a_str_buttons, a_str_content)#</cfoutput>
	

<cfsavecontent variable="a_str_content">
<ul>
	<cfoutput query="q_select_roles">
	<li>#q_select_roles.rolename#</li>
	</cfoutput>
</ul>
	<!--- <br><br><a href="index.cfm?action=roles&workgroupkey=<cfoutput>#htmleditformat(url.entrykey)##writeurltags()#</cfoutput>"><img src="/images/editicon.gif" align="absmiddle" border="0"> <cfoutput>#GetLangVal('adm_ph_edit_roles')#</cfoutput></a>
	 --->
</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('adm_ph_definied_roles'), a_str_buttons, a_str_content)#</cfoutput>

