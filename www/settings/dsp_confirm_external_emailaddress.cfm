<cfparam name="url.email" type="string" default="">
<cfparam name="url.code" type="string" default="">

<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	confirmcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.code#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.email#">
;
</cfquery>

<cf_disp_navigation mytextleft="#GetLangVal('prf_ph_integrate_external_address')#">

<cfif q_select.count_id is 0>

	<br><br><br>
	<b><cfoutput>#GetLangVal('prf_ph_integrate_external_address_invalid_code_title')#</cfoutput></b>
	<br>
	<br>
	<cfoutput>#GetLangVal('prf_ph_integrate_external_address_invalid_code_re_request')#</cfoutput>: <a href="default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a>
	<cfexit method="EXITTEMPLATE">

</cfif>

<!--- passt so ... --->
<cfquery name="q_update" datasource="#request.a_str_db_users#">
UPDATE
	pop3_data
SET
	confirmed = 1
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	confirmcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.code#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.email#">
;
</cfquery>

<br>
<br>

<cfset a_str_text = GetLangVal('prf_ph_integrate_external_address_success')>
<cfset a_str_text = ReplaceNoCase(a_str_text, '%ADDRESS%', url.email, 'ALL')>

<cfoutput>#a_str_text#</cfoutput>

<br>
<br>

<a href="default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a>