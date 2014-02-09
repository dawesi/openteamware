<!--- //

	Module:		Forum
	Action:		NewPosting
	Description: 
	

// --->

<cfparam name="url.forumkey" type="string" default="">
<cfparam name="url.replytopostingkey" type="string" default="">

<!--- editing a posting? ... if yes, postingkey is not empty --->
<cfparam name="url.postingkey" type="string" default="">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('forum_ph_compose_new_article')) />

<cfset a_struct_force_element_values = StructNew() />
<cfset a_struct_force_element_values.virt_forumname = application.components.cmp_forum.GetForumNamebyEntrykey(url.forumkey) />

<cfset a_str_db_fields_to_ignore = '' />

<cfif Len(url.replytopostingkey) GT 0>
	<cfset a_str_db_fields_to_ignore = 'subject' />
</cfif>

<cfset a_str_operation = 'create' />

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(force_element_values = a_struct_force_element_values,
						action = a_str_operation,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '895AC2ED-B0C8-81A6-87DD7B09EE105677',
						dbfieldnames_to_ignore = a_str_db_fields_to_ignore)>

<cfoutput>#a_str_form#</cfoutput>

