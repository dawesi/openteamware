<!--- //

	add to newsletter 
	
	// --->

<cfparam name="session.a_struct_temp_data.addressbook_selected_entrykeys" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>
<cfset q_select_profiles = a_cmp_nl.GetNewsletterProfiles(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings)>

<!--- do not allow to add to CRM filter based lists --->
<cfquery name="q_select_profiles" dbtype="query">
SELECT
	*
FROM
	q_select_profiles
WHERE
	listtype IN (1,2)
;
</cfquery>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('nl_ph_add_subscribers')) />

<cfif q_select_profiles.recordcount IS 0>
	<a href="/mailing/"><cfoutput>#GetLangVal('nl_ph_no_profiles_created_please_do_that')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfoutput>#GetLangVal('nl_ph_please_select_desired_list')#</cfoutput>

<br>

<form action="act_add_contacts_to_newsletter.cfm" method="post" style="margin:0px; ">
<input type="hidden" name="frmcontactkeys" value="<cfoutput>#session.a_struct_temp_data.addressbook_selected_entrykeys#</cfoutput>">

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <cfoutput query="q_select_profiles">
  <tr>
    <td class="bb">
		<input type="radio" name="frmlistkey" class="noborder" value="#q_select_profiles.entrykey#">
	</td>
    <td class="bb">
		<b>#q_select_profiles.profile_name#</b>
		<br>
		#q_select_profiles.description#
	</td>
  </tr>
  </cfoutput>
  <tr>
  	<td></td>
	<td>
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput>">
	</td>
  </tr>
</table>


</form>