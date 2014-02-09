<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>
<cfinclude template="../dsp_inc_select_company.cfm">
<br><br>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="UpdateAllowLoginStatus" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="allowlogin" value="1">
</cfinvoke>

<cfoutput>#GetLangVal('adm_ph_user_enabled')#</cfoutput>
