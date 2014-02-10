<!--- //

	Module:	SERVICE
	Description: 
	

	
	
	TODO hp: write function to attach ICS (outlook invitation file)
	
// --->


<!--- get the recipient ... --->
<cfswitch expression="#arguments.type#">
	<!--- 0 = openTeamWare.com member ...--->
	<cfcase value="0">
		
		<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_invited_user">
			<cfinvokeargument name="userkey" value="#arguments.parameter#">
		</cfinvoke>
		
		<cfset a_str_recipient = q_select_invited_user.username />
	</cfcase>
	<!--- 1 = address book --->
	<cfcase value="1">
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn_contact">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="entrykey" value="#arguments.parameter#">
		</cfinvoke>
		
	    <cfset a_str_recipient = stReturn_contact.q_select_contact.email_prim />
	</cfcase>
	<!--- 2 = email address --->
	<cfcase value="2">
		<cfset a_str_recipient = ExtractEmailAdr(arguments.parameter) />
	</cfcase>
</cfswitch>

<cfinvoke component="#application.components.cmp_user#" method="Getuserdata" returnvariable="q_select_inviting_user">
	<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<cfif Len(a_str_recipient) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset iLangNo = q_select_inviting_user.defaultlanguage />
<cfset a_cmp_translation = application.components.cmp_lang />
<cfset a_cmp_users = application.components.cmp_user />
<cfset a_cmp_customize = application.components.cmp_customize />

<!--- TODO hp: I think the entryId should be something else if it is an update 
+ the 'update' translation should contain another 'key' that should be replaced with 'arguments.changesDescription' 
--->
<cfinvoke component="#application.components.cmp_lang#" method="GetLangValExt" returnvariable="a_str_text_part">
	<cfinvokeargument name="langno" value="#q_select_inviting_user.defaultlanguage#">
	<cfinvokeargument name="entryid" value="cal_ph_invitation_textpart">
</cfinvoke>
 
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%TITLE%', q_select_event.title, 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%DESCRIPTION%', q_select_event.description, 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%LOCATION%', q_select_event.location, 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%BEGIN%', q_select_event.date_start, 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%END%', q_select_event.date_end, 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%HREF_AGREE%', "https://#a_str_base_url#/rd/c/r/?e=#urlencodedformat(q_select_event.entrykey)#&p=#urlencodedformat(arguments.parameter)#&t=#arguments.type#&a=1", 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%HREF_DISAGREE%', "https://#a_str_base_url#/rd/c/r/?e=#urlencodedformat(q_select_event.entrykey)#&p=#urlencodedformat(arguments.parameter)#&t=#arguments.type#&a=-1", 'ALL')>
<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '%HREF_MAYBE%', "https://#a_str_base_url#/rd/c/r/?e=#urlencodedformat(q_select_event.entrykey)#&p=#urlencodedformat(arguments.parameter)#&t=#arguments.type#&a=2", 'ALL')>
<!--- TODO hp: update the translations - add %HREF_MAYBE% --->
<!---
#a_str_text_part#
--->
<cfinvoke component="#application.components.cmp_lang#" method="GetLangValExt" returnvariable="a_str_mail_subject">
	<cfinvokeargument name="langno" value="#q_select_inviting_user.defaultlanguage#">
	<cfinvokeargument name="entryid" value="cal_ph_invitation_subject">
</cfinvoke>

<cfset a_str_mail_subject = ReplaceNoCase(a_str_mail_subject, '%TITLE%', htmleditformat(q_select_event.title)) & ', ' & lsdateformat(q_select_event.date_start, request.a_str_default_long_dt_format) & ' ' & TimeFormat(q_select_event.date_start, 'HH:mm') />

<!--- load standard address --->
<cfinvoke component="/components/email/cmp_accounts" method="GetStandardAddressFromTag" returnvariable="a_str_from_adr">
	<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<cfset a_cmp_content = application.components.cmp_content />

<!--- modify subject in case of reminder ... --->
<cfif arguments.isreminder>
	<cfset a_str_mail_subject = application.components.cmp_lang.GetLangValExt(langno = q_select_inviting_user.defaultlanguage, entryid = 'cal_wd_reminder') & ': ' & a_str_mail_subject />
</cfif>

<cfif a_bol_isUpdate>
	<cfset a_str_mail_subject = application.components.cmp_lang.GetLangValExt(langno = q_select_inviting_user.defaultlanguage, entryid = 'cm_wd_updated') & ': ' & a_str_mail_subject />
</cfif>

<cfmail to="#a_str_recipient#" subject="#a_str_mail_subject#" from="#a_str_from_adr#">
<cfmailpart type="text">
#a_str_text_part#
</cfmailpart>
<cfmailpart type="html">
<html>
	<head>
		<style>
			td,body,p,a{font-family:"Lucida Grande", Tahoma, Arial, Verdana;font-size:11px;}
			a{color:blue;text-decoration:none;}
			a:hover{text-decoration:underline;}
			img.si_img {width:16px;height:16px;padding:2px;border:0px;vertical-align:middle;margin:2px;}
		</style>
		
	<base href="https://#a_str_base_url#/">
	</head>
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" style="padding:0px;">

<cfif Len(a_str_header) GT 0>
	<div style="padding:6px;border-bottom:silver solid 1px;">
	#a_str_header#
	</div>
</cfif>

<div style="padding:6px;border-bottom:silver solid 1px;background-color:##EEEEEE;font-weight:bold;font-size:15px;">
<img src="/images/si/star.png" class="si_img" width="16" height="16" vspace="4" hspace="4" align="absmiddle" border="0" alt="" /> #ReplaceNoCase(a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_ph_invitation_subject_html'), '%TITLE%', htmleditformat(q_select_event.title))#

<cfif a_bol_isUpdate>
	<br /> 
	#application.components.cmp_lang.GetLangValExt(langno = q_select_inviting_user.defaultlanguage, entryid = 'cal_ph_is_updated_information')#
</cfif>
<cfif arguments.isreminder>
	<br /> 
	#application.components.cmp_lang.GetLangValExt(langno = q_select_inviting_user.defaultlanguage, entryid = 'cal_ph_is_reminder_information')#
</cfif>
</div>

<div style="padding:8px;">

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>
		<img align="absmiddle" src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(arguments.securitycontext.myuserkey)#&source=invitation" />
	</td>
    <td style="line-height:19px;">
		<b>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_ph_invitation_hello')#</b>
		<br />
		<cfset a_str_text = htmleditformat(a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_ph_invitation_invite'))>
		<cfset a_str_text = ReplaceNoCase(a_str_text, '%NAME%', '<b>'&q_select_inviting_user.firstname&' '&q_select_inviting_user.surname&' ('&q_select_inviting_user.username&')</b>')>
		
		#a_str_text#
	</td>
  </tr>
</table>


 
<table border="0" cellspacing="0" cellpadding="12" style="border-top:silver solid 1px;border-bottom:silver solid 1px;width:100%;">
  <tr>
    <td valign="top" style="border-right:silver solid 1px;" width="50%">


<table border="0" cellspacing="0" cellpadding="4" width="100%">
  <tr>
    <td align="right" style="font-weight:bold; ">
		#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_subject')#:
	</td>
    <td style="font-weight:bold;">
		#htmleditformat(q_select_event.title)#
	</td>
  </tr>
  <cfif Len(Trim(q_select_event.description)) GT 0>
	  <tr>
		<td align="right" valign="top">
			#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_description')#:
		</td>
		<td valign="top">
			#htmleditformat(q_select_event.description)#
		</td>
	  </tr>
  </cfif>
  <cfif Len(q_select_event.location) GT 0>
	  <tr>
		<td align="right" valign="top">
			#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_location')#:
		</td>
		<td valign="top">
			#htmleditformat(q_select_event.location)# <!--- <img src="https://#a_str_base_url#//images/si/map_add.png" class="si_img" /> --->
		</td>
	  </tr>
  </cfif>
  <tr>
    <td align="right">
		#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_start')#:
	</td>
    <td>
		#lsdateformat(q_select_event.date_start, request.a_str_default_long_dt_format)# #TimeFormat(q_select_event.date_start, 'HH:mm')#
	</td>
  </tr>
  <tr>
    <td align="right">
		#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_end')#:
	</td>
    <td>
		#lsdateformat(q_select_event.date_end, request.a_str_default_long_dt_format)# #TimeFormat(q_select_event.date_end, 'HH:mm')#
	</td>
  </tr>
  <tr>
  	<td align="right">
		#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cm_wd_timezone')#:
	</td>
	<td>
		UTC +#(0-arguments.usersettings.utcdiff)#
	</td>
  </tr>
  <cfif arguments.type is 0>
	  <tr>
		<td align="right">#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_ph_online_item')#:</td>
		<td>
		<a href="https://#a_str_base_url#/rd/c/e/?#urlencodedformat(q_select_event.entrykey)#" target="_blank">#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_ph_please_click_here')#</a>
		</td>
	  </tr>
  </cfif>

<cfif arguments.type is 0>
  <!--- workgroup member ... display meeting members ... --->
  <!--- load meeting members .... --->

<cfinvoke component="#application.components.cmp_calendar#" method="GetMeetingMembers" returnvariable="q_select_meeting_members">
	<cfinvokeargument name="entrykey" value="#q_select_event.entrykey#">
</cfinvoke>

  <cfif q_select_meeting_members.recordcount GT 0>
  <tr>
  	<td align="right" valign="top">#q_select_meeting_members.recordcount# #a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_participants')#:</td>
	<td valign="top">
	
	<table border="0" cellspacing="0" cellpadding="2">
	  <cfloop query="q_select_meeting_members">
	  <tr>
			<cfswitch expression="#q_select_meeting_members.type#">
					<cfcase value="0">
					<!--- workgroup members ... --->
					
						<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_mm_userdata">
							<cfinvokeargument name="entrykey" value="#q_select_meeting_members.parameter#">
						</cfinvoke>
					
					<cfset a_str_name = a_struct_load_mm_userdata.query.surname&', '&a_struct_load_mm_userdata.query.firstname>

					</cfcase>
					<cfcase value="1">
					<!--- address book --->
						<cfset a_str_name = q_select_meeting_members.parameter>
					</cfcase>			
					<cfdefaultcase>
						<cfset a_str_name = q_select_meeting_members.parameter>
					</cfdefaultcase>
					
			</cfswitch>
		<td>
		<ul>
		<li><a target="_blank" href="https://#a_str_base_url#/rd/wg/u/s/?#urlencodedformat(q_select_meeting_members.parameter)#">#htmleditformat(a_str_name)#</a></li>
		</ul>
		</td>
	  </tr>
	  </cfloop>
	</table>
	
	
	</td>
  </tr>
  </cfif>
</cfif>
  
  
  
</table>
  
  
  	</td>
	<cfif NOT arguments.isreminder>
    <td valign="top" width="50%" style="background-color:##bbd3f2;">
	
	<cfset a_str_text = a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_ph_invitation_your_feedback')>
	<cfset a_str_text = ReplaceNoCase(a_str_text, '%NAME%', q_select_inviting_user.firstname&' '&q_select_inviting_user.surname)>
	
	<div style="padding:4px;font-weight:bold;padding-left:0px;"><img src="/images/si/comment.png" vspace="4" hspace="4" class="si_img" style="border:0px;width:16px;height:16px;" align="absmiddle" /> #htmleditformat(a_str_text)#</div>
	<br /> 
	<b>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_agree')#</b><br />
	<a target="_blank" style="color:darkgreen;" href="https://#a_str_base_url#/rd/c/r/?e=#urlencodedformat(q_select_event.entrykey)#&p=#urlencodedformat(arguments.parameter)#&t=#arguments.type#&a=1"><img src="/images/si/accept.png" class="si_img" style="border:0px;width:16px;height:16px;" vspace="4" hspace="4" align="absmiddle" /> #a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_agree_long')#</a>
	<br /> <br /> 
	<b>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_disagree')#</b><br />
	<a target="_blank" style="color:darkred;" href="https://#a_str_base_url#/rd/c/r/?e=#urlencodedformat(q_select_event.entrykey)#&p=#urlencodedformat(arguments.parameter)#&t=#arguments.type#&a=-1"><img src="/images/si/cancel.png" class="si_img" style="border:0px;width:16px;height:16px;" vspace="4" hspace="4" align="absmiddle" /> #a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_disagree_long')#</a>	
	<br /> <br /> 
	<b>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_maybe')#</b><br />
	<a target="_blank" href="https://#a_str_base_url#/rd/c/r/?e=#urlencodedformat(q_select_event.entrykey)#&p=#urlencodedformat(arguments.parameter)#&t=#arguments.type#&a=2"><img src="/images/si/arrow_out.png" class="si_img" style="border:0px;width:16px;height:16px;" vspace="4" hspace="4" align="absmiddle" /> #a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_maybe_long')#</a>	
	
	<br /><br /><br />     
	<cfif arguments.type is 2>
	#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_in_case_of_questions')# <a href="mailto:#q_select_inviting_user.username#">#q_select_inviting_user.username#</a>
	<br />
	(#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='cal_wd_invitation_in_case_of_questions_reply')#).
	</cfif>
	<!---<br /><br /><br />
	<b>Outlook-Extra</b>
	
	cal_ph_invitation_add_to_outlook
	
	<br /><br />
	<a target="_blank" href="https://www.openTeamWare.com/">Termin jetzt im Outlook hinzufuegen ...</a>--->
	</td>
	</cfif>
  </tr>
</table>

<br /><br />  

<table border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td valign="top" align="center">
		powered by
		<br /><a target="_blank" href="https://#a_str_base_url#/"><img src="#a_struct_medium_logo.path#" width="#a_struct_medium_logo.width#" height="#a_struct_medium_logo.height#" border="0" align="absmiddle"></a></td>
	  </tr>
	</table>
</div>

		<cfif Len(a_str_footer) GT 0>
			<div style="padding:6px;border-top:silver solid 1px; ">
				#a_str_footer#
			</div>
		</cfif>
</body>
</html>
</cfmailpart>
</cfmail>

