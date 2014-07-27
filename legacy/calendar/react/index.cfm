<!--- //

	Module:		Calendar
	Description:React to an invitation
	

// --->
<cfparam name="url.e" type="string" default="">
<cfparam name="url.p" type="string" default="">
<cfparam name="url.t" type="string" default="">
<cfparam name="url.a" type="string" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<cfinclude template="../../style_sheet.cfm">
<title><cfoutput>#request.appsettings.properties.defaultdomain#</cfoutput></title>
</head>

<body style="padding:20px;">
<cfinclude template="../../menu/dsp_inc_top_header.cfm">

<cfif (Len(url.e) IS 0) OR
	  (Len(url.p) IS 0) OR
	  (Len(url.t) IS 0) OR
	  (Len(url.a) IS 0)>
	<cfabort>	  
</cfif>

<br /><br />

<cfset a_str_owner_userkey = application.components.cmp_calendar.GetOwnerUserkey(url.e) />

<cfif Len(a_str_owner_userkey) IS 0>
	Sorry, this item does not exist any more.
	<cfabort>
</cfif>

<!--- get security context + usersettings ... --->
<cfset variables.stSecurityContext_user = application.components.cmp_security.GetSecurityContextStructure(a_str_owner_userkey) />
<cfset variables.stUserSettings_user = application.components.cmp_user.GetUsersettings(a_str_owner_userkey) />

<cfinvoke component="#application.components.cmp_calendar#" method="SetAttendeeStatus" returnvariable="a_bol_return">
	<cfinvokeargument name="eventkey" value="#url.e#">
	<cfinvokeargument name="parameter" value="#url.p#">
	<cfinvokeargument name="type" value="#url.t#">
	<cfinvokeargument name="status" value="#url.a#">
	
	<cfif cgi.REQUEST_METHOD IS 'POST'>
		<cfinvokeargument name="comment" value="#form.frmbody#">
	</cfif>
</cfinvoke>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEvent" returnvariable="a_struct_event">
	<cfinvokeargument name="securitycontext" value="#stSecurityContext_user#">
	<cfinvokeargument name="usersettings" value="#stUserSettings_user#">
	<cfinvokeargument name="entrykey" value="#url.e#">
</cfinvoke>

<cfif NOT a_struct_event.result>
	Sorry, this item does not exist any more.
	<cfabort>
</cfif>

<cfset q_select_event = a_struct_event.q_select_event />
<cfset q_select_meeting_members = a_struct_event.q_select_meeting_members />

<!--- select distinct meeting member ... --->
<cfquery name="q_select_meeting_member" dbtype="query">
SELECT
	*
FROM
	q_select_meeting_members
WHERE
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
	AND
	type = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.t)#">
;
</cfquery>

<!--- customize --->
<cfset a_str_user_style = application.components.cmp_user.GetUserCustomStyle(userkey = a_str_owner_userkey)>

<cfset a_str_mail_base_href = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_user_style, entryname = 'main').BaseURL>
<cfset a_str_sender_address = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_user_style, entryname = 'mail').FeedbackMailSender>
<cfset a_str_product_name = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_user_style, entryname = 'main').Productname>


<h2 align="center">Feedback zum Termin "<cfoutput>#htmleditformat(q_select_event.title)#</cfoutput>"</h2>


<cfif cgi.REQUEST_METHOD IS 'POST'>

<div align="center">
<b>Vielen Dank fuer Ihr Feedback.</b>

<br><br>
<a href="javascript:window.close();">Fenster jetzt schliessen</a>
</div>
<cfelse>

<cftry>
<cfmail to="#stSecurityContext_user.myusername#" subject="Feedback zum Termin #htmleditformat(q_select_event.title)# eingetroffen" from="#a_str_sender_address#">
Soeben ist ein Feedback zum Termin #q_select_event.title# eingegangen:

<cfswitch expression="#q_select_meeting_member.type#">
<cfcase value="0">
<!--- workgroup members ... --->
<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
	<cfinvokeargument name="entrykey" value="#q_select_meeting_member.parameter#">
</cfinvoke>
#htmleditformat(q_select_user_data.surname)#, #htmleditformat(q_select_user_data.firstname)# (#htmleditformat(q_select_user_data.username)#)
</cfcase>
<cfcase value="1,3">
<!--- address book --->
#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_meeting_member.parameter)#
</cfcase>
<cfcase value="2">
<!--- just email address --->
#htmleditformat(q_select_meeting_members.parameter)#
</cfcase>
</cfswitch>:

<cfswitch expression="#url.a#">
<cfcase value="0">
#GetLangVal('cal_wd_status_open')#
</cfcase>
<cfcase value="-1">
#GetLangVal('cal_wd_status_declined')#
</cfcase>
<cfcase value="1">
#GetLangVal('cal_wd_status_ok')#
</cfcase>
<cfcase value="2">
#GetLangVal('cal_wd_status_maybe')#
</cfcase>
</cfswitch>

Klicken Sie bitte hier:

https://#a_str_mail_base_href#/rd/c/e/?#urlencodedformat(q_select_event.entrykey)#
</cfmail>

<cfcatch type="any">

</cfcatch>
</cftry>
<div align="center">
<img src="/images/si/accept.png" class="si_img" /> Ihre Antwort wurde dem Organisator mitgeteilt.<br /><br />

<cfif url.a IS 1 or url.a IS 2> <!--- if he agreed or selects maybe --->
	<cfif StructKeyExists(request, 'stSecurityContext') AND request.stSecurityContext.myuserkey NEQ a_str_owner_userkey>
		<!--- add event to calendar of user --->
		
		<cfinvoke component="#application.components.cmp_calendar#" method="CreateEvent" returnvariable="a_bol_return">
			<cfinvokeargument name="entrykey" value="#CreateUUID()#">
			<cfinvokeargument name="title" value="#q_select_event.title#">
			<cfinvokeargument name="location" value="#q_select_event.location#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="date_start" value="#DateAdd('h', request.stUserSettings.utcdiff, q_select_event.date_start )#">
			<cfinvokeargument name="date_end" value="#DateAdd('h', request.stUserSettings.utcdiff, q_select_event.date_end )#">
		</cfinvoke>
		<a href="/calendar/"><cfoutput>#si_img( 'information' )#</cfoutput> Der Termin wurde in Ihrem Kalender eingetragen.</a>
		<br /><br />
		
	<cfelse>
		<!---Sie haben ein <cfoutput>#a_str_product_name#</cfoutput> Konto? 
		<br><br>--->
	</cfif>
</cfif>


<b>Moechten Sie dem Organisator noch eine Nachricht zukommen lassen?</b><br />
Nutzen Sie bitte das folgende Formular:
<form action="index.cfm?<cfoutput>#cgi.QUERY_STRING#</cfoutput>" method="post">
	<textarea name="frmbody" cols="40" rows="5"></textarea>
	<br><br>
	<input type="submit" name="frmsubmit" value="Absenden ..." class="btn btn-primary" />
</form>
</div>

</cfif>

<cfset a_cmp_content = application.components.cmp_content />
<cfset a_str_content = a_cmp_content.GetCompanyCustomElement(companykey = stSecurityContext_user.mycompanykey, elementname = 'calendar_confirmation_page')>

<cfif Len(a_str_content) GT 0>
	<br><br>
	<center>
	<cfoutput>#a_str_content#</cfoutput>
	</center>
</cfif>

<br><br>
<center>
<b>powered by <cfoutput>#a_str_product_name#</cfoutput></b><br><br>
<a href="/rd/signup/?source=calinvite">Jetzt kostenlos testen</a> | <a href="/?source=calinvite">zur Homepage ...</a>
</center>
</body>
</html>


