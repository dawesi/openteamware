<!--- //

	Module:		Address Book
	Action:		CreateNewContact
	Description:Create a new contact/lead/account/ ... in address book
	
				Allow to create salesproject, followup and task as well in
				one step
				
				Also allow to create account if needed automatically ...
				
	

// --->

<!--- datatype ...
	0 = contact
	1 = account
	2 = lead
	3 = inactive --->
	
<cfparam name="url.datatype" type="numeric" default="0">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_create_new_contact'))>

<cfset EditOrCreateContact.action = 'create'>
<cfinclude template="dsp_inc_create_edit_contact_new.cfm">