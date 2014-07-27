<!--- //

	Module:        CRM
	Action:        CreateEditHistoryItem
	Description:   Add a history element to an object, e.g. a contact
	
	Params:        url.entrykey (entrykey of history element (if update)
				   url.objectkey ... entrykey of object
				   url.servicekey ... entrykey of service
				   
				   plus other parameters given maybe in the url scope (see form definition)

// --->

<cfparam name="url.servicekey" type="string">
<cfparam name="url.objectkey" type="string">
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.type" type="string" default="0">

<cfset a_str_operation = 'create' />
<cfset q_select_history = QueryNew('abc') />

<cfset a_struct_callback_functions_arguments = StructNew() />
<cfset a_struct_force_element_values = StructNew() />

<!--- if address book, load sales projects of user ... --->
<cfif url.servicekey IS '52227624-9DAA-05E9-0892A27198268072'>
	<cfset a_struct_callback_functions_arguments.contactkey = url.objectkey />
</cfif>

<!--- force integer value ... --->
<cfset url.type = val(url.type) />

<cfset a_struct_force_element_values.object_title_display = 'sdfsdfdsf' />

<cfset SetHeaderTopInfoString('123') />

<cfset sEntrykeys_fields_to_ignore = '3D42AD67-C5AA-7AF2-1276E7948DA1BEC8' />

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(action = a_str_operation,
						query = q_select_history,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '3D3AB522-0B36-420D-0CC42CD6A02397ED',
						callback_functions_parameters = a_struct_callback_functions_arguments,
						entrykeys_fields_to_ignore = sEntrykeys_fields_to_ignore,
						force_options_replace = a_struct_force_element_values) />

<cfoutput>#a_str_form#</cfoutput>

