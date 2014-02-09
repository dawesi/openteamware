<!--- //

	Module:		Exec once a day
	Description: 
	

// --->

<cfquery name="q_delete_autoresponder_count" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	autoresponderscount
;
</cfquery>

