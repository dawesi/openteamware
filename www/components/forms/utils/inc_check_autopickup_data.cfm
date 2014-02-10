<!--- //

	Component:     Forms
	Function:	   DoAutoPickupData
	Description:   Scan the form scope for variables coming from
				   the page ...
	
	Parameters

// --->

<cfif Len(arguments.requestkey) IS 0>
	<cfset stReturn.errormessage = '1: invalid request key. aborted.' />
	<cfexit method="exittemplate">
</cfif>

<!--- Load request data
	  first of all, check if the request has already been executed once
	  and therefore isn't valid any more --->

<cfset q_select_request_properties = GetFormRequestPropertiesbyRequestKey(requestkey = arguments.requestkey) />

<cfif (q_select_request_properties.recordcount IS 0)>
	<cfset stReturn.errormessage = '2: invalid request. aborted.' />
	<cfexit method="exittemplate">
</cfif>

<cfif (q_select_request_properties.data_used IS 1)>
	<cfset stReturn.errormessage = '3: Cannot re-post same content again. Aborted.' />
	<cfexit method="exittemplate">
</cfif>

<!--- collect now the form values using the default collector ... --->
<cfset a_struct_collect_form_data = CollectFormValues(requestkey = arguments.requestkey,
										form_scope = arguments.form_scope,
										securitycontext = arguments.securitycontext,
										usersettings = arguments.usersettings) />

<!--- return various data ... --->
<cfset stReturn.q_select_request_properties = q_select_request_properties />
<cfset stReturn.a_str_requestkey = q_select_request_properties.requestkey />
<cfset stReturn.q_select_form_properties = GetSavedFormProperties(entrykey = q_select_request_properties.formkey) />

<!--- database values ... --->
<cfset stReturn.a_struct_database_fields = a_struct_collect_form_data.a_struct_database_fields />

<!--- all fields ... --->
<cfset stReturn.a_struct_all_form_fields = a_struct_collect_form_data.a_struct_all_form_fields />

<!--- displayed fields ... --->
<cfset stReturn.a_str_displayed_fields = a_struct_collect_form_data.a_str_displayed_fields />

<cfif Len(a_struct_collect_form_data.missing_fields) GT 0>
	<cfset stReturn.missing_fields = a_struct_collect_form_data.missing_fields />
	<cfset tmp = SetReturnStructErrorCode(stReturn, 5202) />
	<cfexit method="exittemplate">
</cfif>

