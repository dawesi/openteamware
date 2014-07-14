<!--- //

	Module:		Email
	Action:		NewFolder
	Description:form for creating a new folder
	

	
	
	TODO:	 - Implement error handling
	
// --->


<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_newFolder'))>


<div>
<cfoutput>#GetLangVal('mail_ph_newfolder_description')#</cfoutput>
</div>

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(action = 'create',
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '015E0954-9378-26B4-70B934FC599EA701')>

<cfoutput>#a_str_form#</cfoutput>

