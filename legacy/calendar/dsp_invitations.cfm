<!--- //

	// --->
<cfinvoke component="#application.components.cmp_calendar#" method="GetInvitations" returnvariable="q_select_invitations">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset a_cmp_users = application.components.cmp_user>
<cfset a_cmp_addressbook = application.components.cmp_addressbook>

<cfset SetHeaderTopInfoString(GetLangVal('cal_wd_invitations'))>

<cfset a_str_text = GetLangVal('cal_ph_invitations_open_number')>
<cfset a_str_text = ReplaceNoCase(a_str_text, '%recordcount', q_select_invitations.recordcount)>
<br>
<cfoutput>#a_str_text#</cfoutput> <br>

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td><cfoutput>#GetLangVal('cal_wd_item')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cal_wd_date')#</cfoutput> &amp; <cfoutput>#GetLangVal('cal_wd_time')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cal_ph_invitations_invited_person')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_invitations">
  
  <cfswitch expression="#q_select_invitations.type#">
    <cfcase value="0">
        <!--- user ... --->
	    <cfset a_str_param = a_cmp_users.GetUsernamebyentrykey(q_select_invitations.parameter)>
    </cfcase>
    <cfcase value="1">
        <!--- contact ... --->
        <cfset q_select_contact = a_cmp_addressbook.GetContact(
                            securitycontext=request.stSecurityContext, 
                            usersettings=request.stUserSettings, 
                            entrykey=q_select_invitations.parameter).q_select_contact >
		<cfset a_str_param = q_select_contact.surname & ', ' & q_select_contact.firstname>
    </cfcase>
	<cfcase value="2">
		<!--- E-mail ... --->
		<cfset a_str_param = q_select_invitations.parameter>
	</cfcase>
	</cfswitch>
  <tr>
    <td>
		<a href="index.cfm?action=ShowEvent&entrykey=#q_select_invitations.entrykey#">#htmleditformat(shortenstring(q_select_invitations.title, 25))#</a>
	</td>
    <td>
		<cfset a_str_dt_nav = DateFormat(q_select_invitations.date_start, 'mm/dd/yyyy')>
		<a href="index.cfm?Action=ViewDay&Date=#urlencodedformat(a_str_dt_nav)#">#LsDateFormat(q_select_invitations.date_start, 'dd.mm.yy')# #TimeFormat(q_select_invitations.date_start, 'HH:mm')#</a>
	</td>
    <td>
		#a_str_param#
	</td>
  </tr>
  </cfoutput>
</table>