<cfparam name="form.frmcb_for_customers_too" type="numeric" default="0">
<cfparam name="form.frmcbtopnews" type="numeric" default="0">

<cfdump var="#form#">

<cfif IsDate(form.date1)>
	<cfdump var="#parsedatetime(form.date1)#">
</cfif>

<cfquery name="q_update_news" datasource="#request.a_str_db_tools#">
UPDATE
	companynews
SET
	title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtitle#">,
	href = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmhref#">,
	furthertext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtext#">,
	deliver_to_customers_too = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcb_for_customers_too#">,
	topnews = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbtopnews#">
	
	<cfif IsDate(form.date1)>
		,dt_valid_until = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parsedatetime(form.date1)#">
	</cfif>
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
;
</cfquery>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">