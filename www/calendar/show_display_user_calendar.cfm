
<cfinclude template="../login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.selectworkgroupkey" type="string" default="">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.includeusercalendars"
	defaultvalue1 = "">
	
<cfinvoke component="/components/management/workgroups/cmp_secretary" method="GetAllAttendedUsers" returnvariable="q_select_attended_users">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinvoke component="/components/tools/cmp_resources" method="GetResources" returnvariable="q_select_resources">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfset a_cmp_user = application.components.cmp_user>

<html>
<head>
	<cfinclude template="../style_sheet.cfm">
	<title><cfoutput>#GetLangVal('cal_ph_select_user_calendars')#</cfoutput></title>
	
</head>

<body>

<div class="mischeader" style="padding:8px;"><b><cfoutput>#GetLangVal('cal_ph_select_user_calendars_title')#</cfoutput></b></div>

<cfif ListLen(a_str_person_entryvalue1) GT 0>
	
	<div style="padding:8px;">
		<cfset a_Str_text = GetLangval('cal_ph_select_user_calendars_current_count')>
		<cfset a_Str_text = ReplaceNoCase(a_Str_text , '%RECORDCOUNT%', ListLen(a_str_person_entryvalue1))>

		<b><cfoutput>#a_Str_text#</cfoutput></b>
	
	<br>
	
	<cfloop list="#a_str_person_entryvalue1#" delimiters="," index="a_str_userkey">
	
		<cfif Len(a_cmp_user.GetUsernamebyentrykey(a_str_userkey)) GT 0>
			<cfoutput>
			#si_img('user')# #a_cmp_user.GetUsernamebyentrykey(a_str_userkey)#<br>
			</cfoutput>
		</cfif>
		
	</cfloop>
	
	</div>
</cfif>

<table width="100%" cellpadding="4" cellspacing="0" border="0" class="bb bt">
	<tr>	
		<td style="line-height:18px;" class="mischeader">

		<b><img src="/images/calendar/16kalender_gruppen.gif" width="12" height="12" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput></b>
		<br>
		<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">
						
			<cfloop from="1" to="#request.stSecurityContext.q_select_workgroup_permissions.workgrouplevel#" index="ii">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>
			
			<cfif ListFind(request.stSecurityContext.q_select_workgroup_permissions.permissions, 'managepermissions') GT 0>
			
				<!--- check if managepermissions is true ... --->
				
							
				<a href="#cgi.SCRIPT_NAME#?selectworkgroupkey=#urlencodedformat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key)#">#htmleditformat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_name)#</a><br>
			</cfif>
			
		</cfoutput>

		<!--- is this user a secretary of someone? --->
		<cfif q_select_attended_users.recordcount GT 0>
			<br />
			<b><cfoutput>#si_img('user')#</cfoutput> Secretary users</b><br>
			<a href="<cfoutput>#cgi.SCRIPT_NAME#?secretary</cfoutput>"><cfoutput>#q_select_attended_users.recordcount#</cfoutput> display secretary users ...</a>
		</cfif>
		
		<cfif q_select_resources.recordcount GT 0>
			<br>
			<br>
			<b>Resources</b>
			<br>
			
			<a href="<cfoutput>#cgi.SCRIPT_NAME#?resources</cfoutput>">Resources</a>
			
		</cfif>
		
		</td>
		<td class="bl" valign="top">
		<!--- display workgroup members ... --->
		<cfif Len(url.selectworkgroupkey) GT 0>
		
			<cfquery name="q_select_workgroup_name" dbtype="query">
			SELECT
				workgroup_name
			FROM
				request.stSecurityContext.q_select_workgroup_permissions
			WHERE
				workgroup_key = '#url.selectworkgroupkey#'
			;
			</cfquery>
			
			<cfoutput>
			<b>#htmleditformat(q_select_workgroup_name.workgroup_name)#</b><br><br>
			</cfoutput>
		
			<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupMembers" returnvariable=q_select_users>
				<cfinvokeargument name="workgroupkey" value=#url.selectworkgroupkey#>
			</cfinvoke>				
			
			<cfif q_select_users.recordcount GT 0>
				<a href="act_add_user_calendar.cfm?userkeys=<cfoutput>#urlencodedformat(ValueList(q_select_users.userkey))#</cfoutput>"><img src="/images/new_event.gif" width="12" height="12" vspace="3" hspace="3" border="0" align="absmiddle"> alle</a><br>
			<cfelse>
				No users found/Keine Benutzer gefunden
			</cfif>
			
			<!--- load members ... --->				
			<cfloop query="q_select_users">
			
			
			<cfif CompareNoCase(q_select_users.userkey, request.stSecurityContext.myuserkey) NEQ 0>
			</cfif>
			
			<cfoutput>
			<a href="act_add_user_calendar.cfm?userkeys=#urlencodedformat(q_select_users.userkey)#"><img src="/images/new_event.gif" width="12" height="12" vspace="3" hspace="3" border="0" align="absmiddle"> #htmleditformat(q_select_users.fullname)#</a><br>
			</cfoutput>
			
			</cfloop>

		
		<!--- display secretary users ... --->
		<cfelseif StructKeyExists(url, 'secretary')>
			
			<cfoutput query="q_select_attended_users">
				<a href="act_add_user_calendar.cfm?userkeys=#urlencodedformat(q_select_attended_users.userkey)#"><img src="/images/authors.gif" width="16" height="15" align="absmiddle" vspace="3" hspace="3" border="0"> #a_cmp_user.GetUsernamebyentrykey(q_select_attended_users.userkey)#</a><br>
			</cfoutput>
			
		<cfelseif StructKeyExists(url, 'resources')>
			
			<cfoutput query="q_select_resources">
				<a style="font-weight:bold; " href="act_add_user_calendar.cfm?userkeys=&resourcekey=#q_select_resources.entrykey#">#q_select_resources.title#</a>
				<br>
				#q_select_resources.description#
				<br><br>
			</cfoutput>
		
		<cfelse>
			<div class="addinfotext">
			<br><br>
			<cfoutput>#GetLangVal('cal_ph_select_user_calendars_select_category')#</cfoutput>
			</div>
		</cfif>
		</td>

	</tr>
</table>
</body>
</html>