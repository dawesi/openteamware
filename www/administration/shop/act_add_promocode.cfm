<cfparam name="form.frmpromocode" type="string" default="">

<cfif NOT IsNumeric(form.frmpromocode)>
	Invalid code.
	<cfabort>
</cfif>

<cfquery name="q_select_promo_code" datasource="#request.a_str_db_users#">
SELECT
	resellerkey,used,codevalue
FROM
	promocodes
WHERE
	code = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmpromocode)#">
;
</cfquery>

<cfif q_select_promo_code.recordcount GT 0>

	<!--- insert --->
	<cfquery name="q_insert_assign_promocode" datasource="#request.a_str_db_users#">
	INSERT INTO
		assigned_promocodes
		(
		companykey,
		promocode,
		codevalue,
		dt_created
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpromocode#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#q_select_promo_code.codevalue#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
		)
	;
	</cfquery>
	
</cfif>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">