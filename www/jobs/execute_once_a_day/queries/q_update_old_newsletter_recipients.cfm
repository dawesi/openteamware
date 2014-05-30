<!--- //

	Description:Remove full text for newsletter recipients older than 30 days
	

// --->

<cfset a_dt_check = DateAdd('d', -30, Now())>

<cfquery name="q_update_newsletter_recipients">
UPDATE
	newsletter_recipients
SET
	body_text = '',
	body_html = ''
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check)#">
;
</cfquery>

