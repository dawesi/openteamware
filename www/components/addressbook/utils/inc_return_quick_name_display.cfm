<!--- //

	Module:		Address Book / CRM
	Function:	GetContactDisplayNameData
	Description: 
	

// --->

<cfset sReturn = htmleditformat(q_select_contact_quick_display_data.surname) & ', ' & htmleditformat(q_select_contact_quick_display_data.firstname) />

<cfif Len(q_select_contact_quick_display_data.company) GT 0>
	<cfset sReturn = sReturn & ' (' & htmleditformat(q_select_contact_quick_display_data.company) & ')' />
</cfif>

<cfif Trim(sReturn) IS ','>
	<cfset sReturn = CheckZeroString('') />
</cfif>

