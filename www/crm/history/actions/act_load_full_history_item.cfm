<!--- //

	Module:		CRM
	Action:		LoadFullHistoryItem
	Description: 
	

// --->

<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">
<cfparam name="url.servicekey" type="string" default="">

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.not_item_type = '5' />
<cfset a_struct_filter.entrykeys = url.entrykey />

<cfset q_select_history_items = application.components.cmp_crmsales.GetHistoryItemsOfContact(securitycontext = request.stSecurityContext,
									usersettings = request.stUserSettings,
									servicekey = url.servicekey,
									objectkeys = url.objectkey,
									filter = a_struct_filter).q_select_history_items />
									
<cfoutput>#FormatTextToHTML(q_select_history_items.comment)#</cfoutput>

