<!--- //

	Module:		Storage
	Action:		CreateExclusiveLock
	Description: 
	

// --->

<cfparam name="url.filekey" type="string">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.filekey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>	 

<cfif NOT a_struct_file_info.result>
	Not allowed.
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_force_element_values = StructNew() />
<cfset a_struct_force_element_values.virt_filename = a_struct_file_info.q_select_file_info.filename />

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '437E3BF8-9E9E-9E94-936C5CFB456D10CF',
						action = 'create',
						force_element_values = a_struct_force_element_values) />

<cfoutput>#a_str_form#</cfoutput>

