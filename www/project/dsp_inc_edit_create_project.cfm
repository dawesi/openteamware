<!--- //

	Service:	Project
	Function:	Create / Edit a project
	Description:
	
	Header:		

// --->

<cfparam name="CreateEditItem.action" type="string" default="create">
<cfparam name="CreateEditItem.type" type="numeric" default="0">
<cfparam name="CreateEditItem.Query" type="query" default="#QueryNew('project_type,projecttypetitle,display_contact_name,contactkey,contactkey_displayvalue')#">
<cfparam name="CreateEditItem.contactkey" type="string" default="">

<cfif CreateEditItem.action IS 'create' AND CreateEditItem.query.recordcount IS 0>
	<cfset QueryAddRow(CreateEditItem.query, 1) />
	<cfset QuerySetCell(CreateEditItem.query, 'contactkey', CreateEditItem.contactkey, 1) />
	<cfset QuerySetCell(CreateEditItem.query, 'project_type', CreateEditItem.type, 1) />
</cfif>

<cfif ListFindNoCase(CreateEditItem.Query.Columnlist, 'projecttypetitle') IS 0>
	<cfset QueryAddColumn(CreateEditItem.Query, 'projecttypetitle', ArrayNew(1)) />
</cfif>

<cfset sEntrykeys_fields_to_ignore = '' />
<cfset a_str_db_fields_to_ignore = '' />
<cfset sEntrykeys_fields_show_force = '' />

<cfswitch expression="#CreateEditItem.query.project_type#">
	<cfcase value="0">
		<!--- common project ... --->
		<cfset a_str_db_fields_to_ignore = 'sales,currency,stage,probability,lead_source,dt_closing,business_type' />
	</cfcase>
	<cfcase value="1">
		<!--- sales project ... --->
		<cfset a_str_db_fields_to_ignore = 'percentdone' />
	</cfcase>
	<cfcase value="2">
		<!--- technical project ... --->
	</cfcase>
	<cfcase value="3">
		<!--- marketing ... --->
	</cfcase>
</cfswitch>

<cfset QuerySetCell(CreateEditItem.query, 'projecttypetitle', GetLangVal('prj_ph_project_type_' & CreateEditItem.Query.project_type), 1) />

<cfset SetHeaderTopInfoString(CreateEditItem.query.projecttypetitle) />

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(action = CreateEditItem.action,
						query = CreateEditItem.query,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '3177C2F6-E0F2-06FE-A904CB04E3D19D52',
						dbfieldnames_to_ignore = a_str_db_fields_to_ignore,
						entrykeys_fields_force_to_show = sEntrykeys_fields_show_force,
						entrykeys_fields_to_ignore = sEntrykeys_fields_to_ignore) />
						
<cfoutput>#a_str_form#</cfoutput>

