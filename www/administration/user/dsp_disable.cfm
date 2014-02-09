<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>
<cfinclude template="../dsp_inc_select_company.cfm">
<br><br>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif IsDefined("url.confirmed")>


<cfinvoke component="#application.components.cmp_user#" method="UpdateAllowLoginStatus" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="allowlogin" value="0">
</cfinvoke>

<cfoutput>#GetLangVal('adm_ph_user_has_been_deactivated')#</cfoutput>

<br><br><br>

<b><cfoutput>#GetLangVal('adm_wd_tipp')#</cfoutput>:</b> <cfoutput>#GetLangVal('adm_ph_user_deactivated_hint_redirect')#</cfoutput>
<br><br><br>
<a href="default.cfm?action=userproperties&entrykey=<cfoutput>#url.entrykey##writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>

<cfelse>

<cfset a_str_quest = GetLangVal('adm_ph_disable_user_sure')>
<cfset a_str_quest = ReplaceNoCase(a_str_quest, '%USER%', "#stReturn.query.username# (#stReturn.query.surname#, #stReturn.query.firstname#)")>

<cfoutput>#a_str_quest#</cfoutput>

<br><br>
<a href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&confirmed=true"><cfoutput>#GetLangVal('adm_ph_disable_user_sure_yes')#</cfoutput></a>
<br><br><br>
<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('adm_ph_disable_user_sure_no')#</cfoutput></a>


<br><br><br>
</cfif>