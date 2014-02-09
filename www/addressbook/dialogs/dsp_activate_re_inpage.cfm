<!--- //

	Module:		Addressbook
	Action:		ActiveREInpage
	

// --->

<cfset a_struct_force_element_values = StructNew() />

<cfset a_str_msg = GetLangVal('adrb_ph_remote_edit_mail_text') />

<cfset a_struct_force_element_values.frmshortmsg = a_str_msg />

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '5DBA9EA2-06FA-08D2-D53612D253CFC017',
						action = 'create',
						force_element_values = a_struct_force_element_values) />

<cfoutput>#trim(a_str_form)#</cfoutput>

