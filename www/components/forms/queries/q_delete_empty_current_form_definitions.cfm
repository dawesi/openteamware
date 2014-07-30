<!--- //

	Component:	Forms
	Function:	UpdateFormDefinitionsFromXML
	Description:Empty current form / form field definitions
	

// --->

<cfquery name="q_delete_forms">
DELETE FROM
	forms
;
</cfquery>

<cfquery name="q_delete_form_fields">
DELETE FROM
	form_fields
;
</cfquery>


