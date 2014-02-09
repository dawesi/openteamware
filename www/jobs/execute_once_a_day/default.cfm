<!--- //

	Module:		Execute once a day at 00:10 in the morning
	Description: 
	

// --->
<cfsetting requesttimeout="2000">

<cfinclude template="queries/q_delete_sessions.cfm">

<cfinclude template="queries/q_update_old_newsletter_recipients.cfm">

<cfinclude template="queries/q_update_traffic_limits.cfm">

<cfinclude template="queries/q_delete_old_fetchmailexitcodes.cfm">

<cfinclude template="queries/q_delete_autoresponder_count.cfm">

