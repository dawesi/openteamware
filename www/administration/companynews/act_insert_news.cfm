<cfparam name="form.frmcbtopnews" type="numeric" default="0">
<cfparam name="form.frmcb_for_customers_too" type="numeric" default="0">

<cfdump var="#form#">

<cfquery name="q_insert" datasource="#request.a_str_db_tools#">
INSERT INTO
	companynews
	(
	entrykey,
	companykey,
	dt_created,
	createdbyuserkey,
	title,
	href,
	furthertext,
	<cfif Len(form.date1) GT 0>
	dt_valid_until,
	</cfif>
	topnews,
	deliver_to_customers_too
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtitle#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmhref#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtext#">,
	
	<cfif Len(form.date1) GT 0>
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(form.date1)#">,
	</cfif>
	
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbtopnews#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcb_for_customers_too#">
	)
;
</cfquery>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">