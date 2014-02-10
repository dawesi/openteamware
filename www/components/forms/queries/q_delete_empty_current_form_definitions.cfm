<!--- //

	Component:	Forms
	Function:	UpdateFormDefinitionsFromXML
	Description:Empty current form / form field definitions
	

// --->

<cfquery name="q_delete_forms" datasource="#request.a_str_db_tools#">
DELETE FROM
	forms
;
</cfquery>

<cfquery name="q_delete_form_fields" datasource="#request.a_str_db_tools#">
DELETE FROM
	form_fields
;
</cfquery>


