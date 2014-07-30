<!--- //

	Component:	Lang
	Function:	ReadTranslationsFromCSV
	Description:Empty old, stored translations ...
	

// --->

<cfquery name="q_delete_old_translations">
DELETE FROM
	langdata
;
</cfquery>


