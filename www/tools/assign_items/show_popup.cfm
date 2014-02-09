<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">
<cfparam name="url.title" type="string" default="">

<!--- security checks!!!!!!!!!!!!!!!!!!!!!!!!!! --->

<cfinvoke component="#request.a_str_component_assigned_items#" method="GetAssignments" returnvariable="q_select">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
	<cfinvokeargument name="objectkeys" value="#url.objectkey#">
</cfinvoke>


<html>
<head>
<cfinclude template="/style_sheet.cfm">
	<title><cfoutput>#GetLangVal('cm_ph_assign_objects')#</cfoutput></title>
	
</head>
<body>
<div class="mischeader bb" style="padding:4px;font-weight:bold;"><cfoutput>#htmleditformat(url.title)#</cfoutput>
	&nbsp;&nbsp;
	[ <a href="javascript:window.close();"><cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput></a> ]&nbsp;
</div>
<br>
<cfif q_select.recordcount GT 0>
	<cfset variables.a_cmp_show_username = CreateObject('component', request.a_str_component_users)>

	
	<table width="100%"  border="0" cellspacing="0" cellpadding="4">
	  <tr class="mischeader">
		<td class="bb"><cfoutput>#GetLangVal('cm_wd_username')#</cfoutput></td>
		<td class="bb"><cfoutput>#GetLangVal('adm_wd_comment')#</cfoutput></td>
		<td class="bb"><cfoutput>#GetLangVal('cm_wd_created')#</cfoutput></td>
		<td class="bb" align="center"><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
	  </tr>
	  <cfoutput query="q_select">
	  <tr>
		<td><img src="/images/img_person_small.gif" align="absmiddle" border="0"> #variables.a_cmp_show_username.GetUsernamebyentrykey(q_select.userkey)#</td>
		<td>#q_select.comment#</td>
		<td>
			#LsDateFormat(q_select.dt_created, request.stUserSettings.DEFAULT_DATEFORMAT)# #LsDateFormat(q_select.dt_created, request.stUserSettings.DEFAULT_TIMEFORMAT)#
		</td>
		<td align="center">
			<img src="/images/editicon_disabled.gif" align="absmiddle" border="0">&nbsp;
			<a onClick="return confirm('Sind Sie sicher?');" href="act_delete_assignment.cfm?#cgi.QUERY_STRING#&userkey=#q_select.userkey#"><img src="/images/del.gif" align="absmiddle" border="0"></a>
		</td>
	  </tr>
	  </cfoutput>
	</table>
	
<cfelse>
	<cfoutput>#GetLangVal('crm_ph_no_assignment_found')#</cfoutput>
</cfif>

<!--- load all users ... --->
<cfset variables.a_cmp_customers = CreateObject('component', '/components/management/customers/cmp_customer')>

<cfinvoke component="#variables.a_cmp_customers#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<br>
<form action="act_new_assignment.cfm?<cfoutput>#cgi.QUERY_STRING#</cfoutput>" method="post">
<b><cfoutput>#GetLangVal('crm_ph_create_new_assignment')#</cfoutput></b><br>
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:</td>
    <td>
	<select name="frmuserkey">
		<option value=""><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
		<cfoutput query="q_select_users">
			<option value="#q_select_users.entrykey#">#q_select_users.surname#, #q_select_users.firstname# (#q_select_users.username#) #q_select_users.aposition#</option>
		</cfoutput>
	</select>
	</td>
  </tr>
  <tr>
    <td><cfoutput>#GetLangVal('adm_wd_comment')#</cfoutput></td>
    <td>
		<input type="text" name="frmcomment" value="" size="25">
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
	</td>
  </tr>
</table>


</form>
</body>
</html>