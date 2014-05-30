<!--- //

	Module:		Select responsible people
	Action:		
	Description:	
	

// --->
<cfif NOT CheckSimpleLoggedIn()>
	<cfabort>
</cfif>

<!--- entrykey of the object ... --->
<cfparam name="url.entrykey" type="string" default="">

<!--- objectname to display ... --->
<cfparam name="url.objectname" type="string" default="">

<!--- servicekey ... --->
<cfparam name="url.servicekey" type="string" default="">

<!--- already defined users ... --->
<cfparam name="url.userkeys" type="string" default="">


<!--- load the workgroup shares ... --->
<!---<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
</cfinvoke>--->

<!--- load already assigned members ... --->

<cfset a_cmp_users = application.components.cmp_user>


<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<title><cfoutput>#GetLangVal('tsk_ph_select_assigned_people')#</cfoutput></title>
</head>

<body>

<form action="save_assignedto.cfm" method="post" name="formsaveassignedto" style="margin:0px;">
<input type="hidden" name="entrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">

<table class="table table-hover">
  <tr class="mischeader">
    <td colspan="3">
	<b><cfoutput>#si_img('group')# #GetLangVal('tsk_ph_select_assigned_people')#</cfoutput></b>
	</td>
  </tr>
  <tr>
  	<td colspan="2" class="bb">
		<cfoutput>#GetLangVal('cm_wd_objects')#</cfoutput>: <cfoutput>#htmleditformat(checkzerostring(url.objectname))#</cfoutput>
	</td>
	<td align="right" class="bb">
		<input type="submit" name="frmsubmitsave" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>" class="btn" />
		&nbsp;
	</td>
  </tr>
  <cfif Len(url.userkeys) GT 0>
  <tr>
  	<td colspan="3">
		<cfloop list="#url.userkeys#" index="a_str_userkey">
			<cfoutput>
			#a_cmp_users.getusernamebyentrykey(a_str_userkey)#<br />
			</cfoutput>
		</cfloop>
	</td>
  </tr>
  </cfif>

<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">

	<!--- load all members ... --->
	<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupMembers" returnvariable=q_select_user>
		<cfinvokeargument name="workgroupkey" value="#request.stSecurityContext.q_select_workgroup_permissions.workgroup_key#">
	</cfinvoke>
	
	<cfif q_select_user.recordcount GT 0>
		<tr>
			<td colspan="2" class="mischeader bb">
			#si_img('group')# #htmleditformat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_name)# (#q_select_user.recordcount#)
			</td>
			<td class="mischeader bb" align="right">
			</td>
		</tr>
		<cfloop query="q_select_user">
		<tr>
			<td>
			<input type="checkbox" name="frmcbassignedto" <cfif ListFindNoCase(url.userkeys, q_select_user.userkey) GT 0>checked</cfif> value="#htmleditformat(q_select_user.userkey)#" class="noborder">
			</td>
			<td>
				<b>#si_img('user')# #htmleditformat(q_Select_user.fullname)#</b>
			</td>
			<td>
				#htmleditformat(q_Select_user.username)#
			</td>
		</tr>
		</cfloop>
	</cfif>
	
</cfoutput>
</table>
</form>
</body>
</html>


