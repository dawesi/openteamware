<!--- check permissions --->
<cfparam name="url.entrykey" type="string">

<cfquery name="q_select_workgroup" dbtype="query">
SELECT
	*
FROM
	request.stSecurityContext.q_select_workgroup_permissions
WHERE
	workgroup_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfif q_select_workgroup.recordcount IS 0>
	Workgroup not found
	<cfexit method="exittemplate">
</cfif>

<cfset variables.a_cmp_workgroup = CreateObject('component', request.a_str_component_workgroups)>
<cfset variables.a_cmp_load_user_data = CreateObject('component', '/components/management/users/cmp_load_userdata')>

<cfoutput>#WriteMainContentTopHeaderLine(GetLangVal('cm_wd_workgroup') & ': ' & q_select_workgroup.workgroup_name)#</cfoutput>

<br/><br/>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td colspan="2" class="bb" style="font-size:16px;font-weight:bold;<cfif q_select_workgroup.colour NEQ ''>background-color:#q_select_workgroup.colour#</cfif> ">
		#q_select_workgroup.workgroup_name#
	</td>
  </tr>
  <tr>
    <td align="right">
		#GetLangVal('cm_wd_description')#:
	</td>
    <td>
		#htmleditformat(CheckZerostring(q_select_workgroup.description))#
	</td>
  </tr>
  <tr>
    <td align="right" valign="top">
		#GetLangVal('wrkgr_ph_your_rights')#:
	</td>
    <td valign="top">
		<ul style="margin-bottom:0px;margin-top:0px; ">
		<cfloop list="#q_select_workgroup.permissions#" delimiters="," index="a_str_permission">
			<li>#GetLangVal('cm_wd_right_' & a_str_permission)#</li>
		</cfloop>
		</ul>	
	</td>
  </tr>
<cfif ListFind(q_select_workgroup.permissions, 'managepermissions') GT 0>  

			<cfinvoke component="#variables.a_cmp_workgroup#" method="GetWorkgroupMembers" returnvariable=q_select_users>
				<cfinvokeargument name="workgroupkey" value=#q_select_workgroup.workgroup_key#>
			</cfinvoke>		
  <tr>
    <td align="right" valign="top">
		#GetLangVal('cm_wd_members')# (#q_select_users.recordcount#):
	</td>
    <td>
	
			
			<cfif q_select_users.recordcount GT 0>
			
			<cfloop query="q_select_users">
				<cfinvoke component="#variables.a_cmp_load_user_data#" method="LoadUserData" returnvariable="a_struct_userdata">
					<cfinvokeargument name="entrykey" value="#q_select_users.userkey#">
				</cfinvoke>
								
				<cfif (a_struct_userdata.result IS 'OK') AND (a_struct_userdata.query.allow_login IS 1)>
				
					<!--- ok, here we go --->
					<cfset q_select_user = a_struct_userdata.query>
					
					<table border="0" cellspacing="0" cellpadding="4" class="bb bt" width="100%" style="margin:20px; ">
					  <tr>
					  	<td rowspan="4" valign="top">
					  	<cfif q_select_user.smallphotoavaliable IS 1>
							
							<img src="/tools/img/show_small_userphoto.cfm?entrykey=#q_select_user.entrykey#">
							
						</cfif>
						</td>
						<td colspan="2" style="font-weight:bold; ">
							#q_select_user.surname#, #q_select_user.firstname# <cfif Len(q_select_user.identificationcode) GT 0>(#q_select_user.identificationcode#)</cfif>
						</td>
					  </tr>
					  <tr>
						<td align="right">
							#GetLangVal('cm_wd_username')#:
						</td>
						<td>
							<a href="javascript:OpenComposePopupTo('#jsstringformat(q_select_user.username)#');"><img src="/images/icon/letter_yellow.gif" align="absmiddle" border="0"> #q_select_user.username#</a>
						</td>
					  </tr>
					  <tr>
					  	<td align="right">
							#GetLangVal('adrb_wd_department')#:
						</td>
						<td>
							#htmleditformat(q_select_user.department)#
						</td>
					  </tr>
					  <tr>
					  	<td align="right">
							#GetLangVal('adrb_wd_position')#:
						</td>
						<td>
							#htmleditformat(q_select_user.aposition)#
						</td>
					  </tr>
					</table>
					
				</cfif>
			</cfloop>
			
			</cfif>
	</td>
  </tr>
</cfif>
</table>
</cfoutput>
