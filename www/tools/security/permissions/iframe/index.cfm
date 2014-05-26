
<!--- 

	show permissions in an iframe
	
	--->
	
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount IS 0>
	<cfoutput>#GetLangVal('cm_ph_alert_no_workgroup_member_at_all')#</cfoutput>
	<cfabort>
</cfif>
	
<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.sectionkey" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">

<cfif url.servicekey IS ''>
	<h4>no servicekey provided</h4>
	<cfabort>
</cfif>

<!--- load the permissions ... --->
<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
</cfinvoke>

<cfset a_cmp_wg = CreateObject('component', request.a_str_component_workgroups)>

<html>
	<head>
		<cfinclude template="/style_sheet.cfm">
		<title></title>
	</head>
<body style="padding:4px;">

<!--- load permissions now ... --->


<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td class="bb">
	<cfif q_select_shares.recordcount is 0>
		<b><cfoutput>#GetLangVal('cm_ph_no_shares_found')#</cfoutput></b>
	<cfelse>
		<b><cfoutput>#q_select_shares.recordcount#</cfoutput> <cfoutput>#GetLangVal('cm_ph_number_of_shares_found')#</cfoutput>.</b>
	</cfif>
	</td>
    <td class="bb" align="right">
	
	<a href="javascript:parent.OpenWorkgroupShareDialog('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>');"><b><cfoutput>#si_img('pencil')# #GetLangVal('cm_ph_edit_shares')#</cfoutput></b></a>
	
	</td>
  </tr>
  <cfoutput query="q_select_shares">
  <tr>
  	<td colspan="2">
	
	<!--- load workgroup name ... --->	
	<cfset a_str_workgroup_name = a_cmp_wg.GetWorkgroupNameByEntryKey(entrykey = q_select_shares.workgroupkey)>
		
	&nbsp;&nbsp;<a target="_blank" href="/workgroups/?action=ShowWorkgroup&entrykey=#urlencodedformat(q_select_shares.workgroupkey)#"><img src="/images/calendar/16kalender_gruppen.gif" width="11" height="12" align="absmiddle" border="0" hspace="4" vspace="4">#htmleditformat(a_str_workgroup_name)#</a><br>
	</td>  
  </tr>  
  </cfoutput>  
</table>




<!---
<cfinvoke component="#application.components.cmp_security#" method="LoadPossibleWorkgroupsForAction" returnvariable="q_select_workgroups">
	<cfinvokeargument name="desiredactions" value="write">
	<cfinvokeargument name="q_workgroup_permissions" value="#request.stSecurityContext.q_select_workgroup_permissions#">
</cfinvoke>

<cfoutput query="q_select_workgroups">

<cfloop from="1" to="#q_select_workgroups.workgrouplevel#" index="1">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>

<!---<a href="?action=addworkgroup&workgroupkey=#urlencodedformat(q_select_workgroups.workgroup_key)#">Gruppe --->

<cfif ListFindNoCase(q_select_workgroups.permissions, 'write') GT 0>
	<input type="checkbox" name="frmcbworkgroups" value="#urlencodedformat(q_select_workgroups.workgroup_key)#" class="noborder"><b>#htmleditformat(q_select_workgroups.workgroup_name)#</b><!---hinzuf&uuml;gen ...</a>---><br>
</cfif>

</cfoutput>--->



</body>
</html>