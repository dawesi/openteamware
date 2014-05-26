
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

<cfinclude template="/common/scripts/script_utils.cfm">


<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_user">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>
<!---<cfdump var="#q_select_users#">--->
<!--- load the workgroup shares ... --->
<!---<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
</cfinvoke>--->

<!--- load already assigned members ... --->


<html>
<head>
	<cfinclude template="../../../../style_sheet.cfm">
<title>Teilnehmende Personen auswaehlen ...</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
<form action="save_takepart.cfm" method="post">
<input type="hidden" name="entrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
  <tr class="mischeader">
    <td colspan="3" style="padding:8px;">
	<b>Teilnehmende Mitglieder auswaehlen</b>
	</td>
  </tr>
<tr>
  	<td class="bb" colspan="2">
	Eintrag: <cfoutput>#htmleditformat(checkzerostring(url.objectname))#</cfoutput>
	</td>
	<td align="right" class="bb">
	<input type="submit" name="frmsubmitsave" value="Speichern" style="font-weight:bold;">
	&nbsp;
	</td>
  </tr>
<!---
<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">

	<!--- load all members ... --->
	<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupMembers" returnvariable=q_select_user>
		<cfinvokeargument name="workgroupkey" value=#request.stSecurityContext.q_select_workgroup_permissions.workgroup_key#>
	</cfinvoke>
	
	<cfif q_select_user.recordcount GT 0>
		<tr>
			<td colspan="2" class="mischeader bb">
			<img src="/images/calendar/16kalender_gruppen.gif" width="12" height="12" vspace="4" hspace="4" border="0" align="absmiddle"> #htmleditformat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_name)# (#q_select_user.recordcount#)
			</td>
			<td class="mischeader bb" align="right">
				<!---<input type="checkbox" name="frmcb" class="noborder"  disabled> freigeben--->
				&nbsp;
			</td>
		</tr>--->
		
		<!---<tr>
			<td>
			<input type="checkbox" name="frmcball" onClick="" class="noborder">
			</td>
			<td colspan="2">
			Alle auswaehlen
			</td>
		</tr>--->
		<cfoutput query="q_select_user">
		
		<!--- load userdata ... --->
		<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#q_select_user.entrykey#">
		</cfinvoke>
		
		<cfif StructKeyExists(stReturn, 'query')>
			<cfset q_select_user_photo = stReturn.query>
			<tr>
				<td>
				<input type="checkbox" name="frmcbtakepart" <cfif ListFindNoCase(url.userkeys, q_select_user.entrykey) GT 0>checked</cfif> value="#htmleditformat(q_select_user.entrykey)#" class="noborder">
				</td>
				<td>
				<cfif q_select_user_photo.smallphotoavaliable IS 1>
					<img src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_user.entrykey)#" align="absmiddle">
				</cfif>
				<b>#htmleditformat(q_Select_user.surname)#, #htmleditformat(q_Select_user.firstname)#</b>
				
				<cfif q_select_user.department NEQ ''>
					<br>
					#q_select_user.department# #q_select_user.aposition#
				</cfif>
				</td>
				<td>
				#htmleditformat(q_select_user.username)#
				</td>
			</tr>
		</cfif>
		</cfoutput>
<!---	</cfif>
	
</cfoutput>--->
<tr>
	<td colspan="3" align="right" class="bb">
	<input type="submit" name="frmsubmitsave" value="Speichern" style="font-weight:bold;">
	&nbsp;
	</td>
  </tr>
</form>
</table>

</body>
</html>
