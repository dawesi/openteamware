<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_calendar#" method="GetEvent" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<!---<cfdump var="#stReturn#">--->

<cfset q_select_event = stReturn.q_select_event>


<cfset a_str_body = chr(13)&chr(10)&

	"#GetLangVal('cal_ph_mail_eventinfo_intro')#"&chr(13)&chr(10)&chr(13)&chr(10)&" - "&htmleditformat(q_select_event.title)&" -"&chr(13)&chr(10)&chr(13)&chr(10)&

	"#GetLangVal('cal_wd_start')#: "&DateFormat(q_select_event.date_start, "dd.mm.yyyy")&" "&TimeFormat(q_select_event.date_start, "HH:mm")&chr(13)&chr(10)&

	"#GetLangVal('cal_wd_end')#: "&DateFormat(q_select_event.date_end, "dd.mm.yyyy")&" "&TimeFormat(q_select_event.date_end, "HH:mm")&chr(13)&chr(10)&

	"#GetLangVal('cal_wd_location')#: "&q_select_event.location&chr(13)&chr(10)>
	
<cfif Len(q_select_event.description) GT 0>
	<cfset a_str_body = a_str_body & GetLangVal('cal_wd_description')&': '&htmleditformat(q_select_event.description)>
</cfif>
		
<cfset a_str_subject = GetLangVal('cal_ph_mail_eventinfo_subject')&' >'&htmleditformat(q_select_event.title)&'<'>

<cflocation addtoken="No" url="../email/default.cfm?action=ComposeMail&subject=#urlencodedformat(a_str_subject)#&to=&body=#urlencodedformat(a_str_body)#">