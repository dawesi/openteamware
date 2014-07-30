<!--- //

	Module:		Admintool
	Description:Check Security before admin tool access
	
// --->
	
<cfset a_str_actions = request.a_str_admin_actions />

<!--- default default values ... --->
<cfset request.a_bol_is_reseller = false />
<!--- <cfset url.resellerkey = '' />
<cfset form.frmresellerkey = '' />  
 --->
<!--- check if the user is a reseller ... --->
<cfquery name="q_select_resellerkey">
SELECT
	resellerkey
FROM
	resellerusers
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
; 
</cfquery>

<cfquery name="q_select_reseller">
SELECT
	companyname,country,dt_created,entrykey,id,parentid,domains,emailadr,
	isprojectpartner,issystempartner,isdistributor,contractingparty,
	default_settlement_type,allow_modify_settlement_type
FROM
	reseller 
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_resellerkey.resellerkey#">
; 
</cfquery>

<!--- is it a reseller (partner) or not? ... --->
<cfif q_select_resellerkey.recordcount GT 0 AND q_select_reseller.recordcount GT 0>

  <cfset request.a_bol_is_reseller = true />
  <cfset request.a_str_reseller_entry_key = q_select_reseller.entrykey />

  <!--- select all sub-resellers ... --->
  <cfset a_struct_sub_resellers = ArrayNew(1) />
  <cfinclude template="../queries/q_select_reseller.cfm">
  <cfinclude template="../queries/q_select_sub_resellers.cfm">

  <cfset request.q_select_reseller = q_select_reseller />

</cfif>


<!--- is company administrator (technical contact ...)? --->
<cfquery name="request.q_select_company_admin">
SELECT
	companycontacts.companykey,
	companycontacts.contacttype,
	companycontacts.user_level,
	companies.companyname,
	companies.countryisocode 
FROM
	companycontacts
LEFT JOIN
	companies ON (companycontacts.companykey = companies.entrykey) 
WHERE
	companycontacts.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
; 
</cfquery>

<cfif request.q_select_company_admin.recordcount GT 0>
	
  <cfset request.a_bol_is_company_admin = true />
  <cfset request.a_arr_company_admin = ArrayNew(1) />

  <cfloop query="request.q_select_company_admin">
	
	<cfset a_int_currentrow = request.q_select_company_admin.currentrow />
	
    <cfset request.a_arr_company_admin[a_int_currentrow] = StructNew() />
    <cfset request.a_arr_company_admin[a_int_currentrow].companykey = request.q_select_company_admin.companykey />
    <cfset request.a_arr_company_admin[a_int_currentrow].user_level = request.q_select_company_admin.user_level />
    <cfset request.a_arr_company_admin[a_int_currentrow].contacttype = request.q_select_company_admin.contacttype />
    <cfset request.a_arr_company_admin[a_int_currentrow].companyname = request.q_select_company_admin.companyname />
  </cfloop>
  <cfelse>
  	<cfset request.a_bol_is_company_admin = false />
</cfif>




<cfquery name="q_insert_log" datasource="#request.a_str_db_log#">
INSERT INTO
	adminactions
	(
	userkey,
	companykey,
	resellerkey,
	dt_created,
	href,
	urlvariables,
	formvariables
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfif StructKeyExists(url, 'companykey')>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">,
	<cfelse>
	'',
	</cfif>
	<cfif StructKeyExists(url, 'resellerkey')>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">,
	<cfelse>
	'',
	</cfif>
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">
	)
;
</cfquery>

<cfif q_select_reseller.recordcount IS 0 AND request.q_select_company_admin.recordcount IS 0>
	<img src="/images/si/user.png" align="absmiddle" /> <cfoutput>#request.stSecurityContext.myusername#</cfoutput>
	<br /><br /> 
	You have no admin status.
	<br />
	Sie haben haben keinen Zugriff auf dieses Modul (Administration).
	<cfabort>
</cfif>

<cfif q_select_reseller.recordcount IS 1 AND q_select_reseller.isdistributor IS 1>
	<cfset request.a_bol_is_distributor = true />
	<cfset request.a_str_resellerkey = q_select_reseller.entrykey />
<cfelse>
	<cfset request.a_bol_is_distributor = false />
	<cfset request.a_str_resellerkey = '' />
</cfif>

<cfinclude template="queries/q_select_user_info.cfm">

