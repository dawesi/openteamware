
<!---

	edit the security role
	
	--->
	
<cfinvoke component="#application.components.cmp_security#" method="GetSecurityRoleOfUser" returnvariable="a_struct_role">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>
	
<b>Security</b>
<br><br><br>
<cfif a_struct_role.a_str_rolekey IS ''>
	Keine Einstellung getroffen.<br><br><br>
	<a href="default.cfm?action=security<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_edit')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>


#GetLangVal('adm_wd_role')#:


<cfinvoke component="#application.components.cmp_security#" method="GetSecurityRole" returnvariable="a_struct_securityrole">
	<cfinvokeargument name="entrykey" value="#a_struct_role.a_str_rolekey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfdump var="#a_struct_role#">

<cfoutput><b>#a_struct_securityrole.q_select_security_role.rolename#</b></cfoutput>
<br><br><br>
<!---<cfdump var="#a_struct_securityrole#">--->

<a href="default.cfm?action=securityrole.display&entrykey=<cfoutput>#a_struct_role.a_str_rolekey##WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_role_show_rights')#</cfoutput></a>
<br><br><br>
<a href="default.cfm?action=security<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_edit')#</cfoutput></a>