<!--- //

	Component:	Lang
	Function:	ReadTranslationsFromCSV
	Description:Empty old, stored translations ...
	

// --->

<cfquery name="q_delete_old_translations" datasource="#request.a_str_db_tools#">
DELETE FROM
	langdata
;
</cfquery>


