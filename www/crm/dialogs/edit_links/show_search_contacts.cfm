<cfparam name="url.search" type="string" default="">



<cfset variables.a_cmp_addressbook = application.components.cmp_addressbook>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.search = url.search>

<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_loadoptions.maxrows = 25>

<cfinvoke component="#variables.a_cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts>

<!---
Your query for <cfoutput>#url.search#</cfoutput> returned <cfoutput>#q_select_contacts.recordcount#</cfoutput> results.
--->
<table border="0" cellspacing="0" cellpadding="4" width="95%">
  <tr>
  	<td>
		<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput>
	</td>
    <td>&nbsp;</td>
  </tr>
  <cfoutput query="q_select_contacts">
  
  <cfset a_str_displayname = trim(q_select_contacts.surname & ', ' & q_select_contacts.firstname)>
  
  <cfif Len(q_select_contacts.company) GT 0>
  	<cfset a_str_displayname = a_str_displayname & ' (' & q_select_contacts.company & ')'>
  </cfif>
  
  <tr>
  	<td>
		<a href="javascript:ConnectContact('#jsStringFormat(q_select_contacts.entrykey)#', '#jsstringformat(a_str_displayname)#');" style="text-decoration:underline; ">#GetLangVal('crm_ph_link_with_this_element')#</a>
	</td>
    <td>
		#htmleditformat(q_select_contacts.surname)#, #htmleditformat(q_select_contacts.firstname)#
	</td>
    <td>
		#htmleditformat(q_select_contacts.company)#
	</td>
    <td>
		#htmleditformat(q_select_contacts.categories)#
	</td>
    <td>&nbsp;</td>
  </tr>
  </cfoutput>
</table>