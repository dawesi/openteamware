<!--- //

	Module:		
	Action:		ShowEditHistoryItem
	Description:	
	

// --->

<cfparam name="url.entrykey" type="string">

<cfset tmp = SetHeaderTopInfoString( GetLangVal('cm_wd_edit') ) />

<cfset sEntrykeys_fields_to_ignore = '3D42AD67-C5AA-7AF2-1276E7948DA1BEC8' />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetHistoryItem" returnvariable="a_struct_history_item">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_struct_history_item.result>
	Object not found.
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(action = 'UPDATE',
						query = a_struct_history_item.q_select_history_item,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '3D3AB522-0B36-420D-0CC42CD6A02397ED',
						entrykeys_fields_to_ignore = sEntrykeys_fields_to_ignore) />

<cfoutput>#a_str_form#</cfoutput>
