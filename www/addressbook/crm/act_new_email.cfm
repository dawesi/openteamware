<cfinclude template="../../login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_crmsales#" method="GetVariousCRMSetting" returnvariable="a_str_setting_value">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="key" value="salutation_field">
</cfinvoke>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	
	<cfif Len(a_str_setting_value) GT 0>
		<cfinvokeargument name="loadcrmdata" value="true">
	</cfif>
</cfinvoke>

<cfif NOT StructKeyExists(stReturn, 'q_select_contact')>
	<cfabort>
</cfif>

<cfset q_select_contact = stReturn.q_select_contact>

<cfset a_str_body = ''>

<cfif Len(a_str_setting_value) GT 0>

	<cfif ListFindNoCase(q_select_contact.columnlist, 'db_' & a_str_setting_value)>
		<cfset a_str_body = q_select_contact['db_' & a_str_setting_value][1]>
	</cfif>

</cfif>

<cfif Len(a_str_body) IS 0>
	<cfswitch expression="#q_select_contact.sex#">
		<cfcase value="0">
			<cfset a_str_body = GetLangVal('adrb_crm_ph_dear_sir')&' '&q_select_contact.surname&'!'>
		</cfcase>
		<cfcase value="1">
			<cfset a_str_body = GetLangVal('adrb_crm_ph_dear_madame')&' '&q_select_contact.surname&'!'>
		</cfcase>
	</cfswitch>
</cfif>

<cflocation addtoken="no" url="/email/default.cfm?action=composemail&to=#urlencodedformat(q_select_contact.email_prim)#&body=#urlencodedformat(a_str_body)#&forcesig=1">