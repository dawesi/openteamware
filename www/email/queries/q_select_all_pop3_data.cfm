<!--- //

	Module:		E-Mail
	Description:select all confirmed pop3 data
// --->

<cfparam name="SelectExternalAccounts.Confirmedonly" type="boolean" default="true">

<cfquery name="q_select_all_pop3_data" dbtype="query">
SELECT
	*
FROM
	request.stSecurityContext.q_select_all_email_addresses
	
<cfif SelectExternalAccounts.Confirmedonly>
	WHERE
		(confirmed = 1)
</cfif>

;
</cfquery>