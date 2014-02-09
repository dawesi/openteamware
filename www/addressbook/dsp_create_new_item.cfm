<!--- //

	Module:		Address Book
	Action:		CreateNewItem
	Description:Create a new contact/lead/account/ ... in address book
	
				Allow to create salesproject, followup and task as well in
				one step
				
				Also allow to create account if needed automatically ...
				
				Always call the right form ...
				
	

// --->

<!--- datatype ...
	0 = contact
	1 = account
	2 = lead
	3 = inactive --->
	
<cfparam name="url.datatype" type="numeric" default="0">
<cfparam name="url.clonefromcontactkey" type="string" default="">
<cfparam name="url.parentcontactkey" type="string" default="">

<cfswitch expression="#url.datatype#">
	<cfcase value="1">
		<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_create_new_account')) />
	</cfcase>
	<cfcase value="2">
		<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_create_new_lead')) />
	</cfcase>
	<cfdefaultcase>
		<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_create_new_contact')) />
	</cfdefaultcase>>
</cfswitch>

<cfset CreateEditItem = StructNew() />

<cfif Len(url.parentcontactkey) GT 0>
	
	<cfinclude template="utils/inc_load_parent_contact_data.cfm">
	<cfset CreateEditItem.Query = q_parent_contact />
	
</cfif>

<cfif Len(url.clonefromcontactkey) GT 0>

	<cfinclude template="utils/inc_load_clone_contact.cfm">
	<cfset CreateEditItem.Query = q_parent_contact />
	
</cfif>

<cfset CreateEditItem.Datatype = url.datatype>

<cfinclude template="dsp_inc_create_edit_item.cfm">
	

