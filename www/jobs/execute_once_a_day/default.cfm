<!--- //

	Module:		Execute once a day at 00:10 in the morning
	Description: 
	

// --->
<cfsetting requesttimeout="2000">

<cfinclude template="queries/q_update_old_newsletter_recipients.cfm">
