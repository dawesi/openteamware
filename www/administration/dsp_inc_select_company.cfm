<!--- //

	Service:	Admintool
	Description:general routine for getting the company key if no is supplied ...
		Header:	

// --->

<cfinclude template="utils/inc_check_security.cfm">

<cfif request.a_bol_is_reseller>
	<!--- this user is also a reseller ... check if the reseller key has been provided --->
	<cfinclude template="dsp_inc_select_reseller.cfm">

	<cfif NOT StructKeyExists(url, 'resellerkey')>
		<cfthrow errorcode="abortpageprocessing">
	</cfif>
</cfif>	

<cfparam name="url.companykey" type="string" default="">

<cfset a_bol_data_missing = false />

<!--- only one company? / and company admin --->
<cfif (NOT request.a_bol_is_reseller) AND
		(request.q_select_company_admin.recordcount IS 1)>
	<!--- set the two standard elements ... --->
	<cfset url.companykey = request.q_select_company_admin.companykey />
	<cfset form.frmcompanykey = request.q_select_company_admin.companykey />
	
	<!--- set empty resellerkey by default ... --->
	<cfparam name="url.resellerkey" type="string" default="">
	
	<!--- <cfinvoke component="#request.a_str_component_licence#" method="CheckDunningLetters" returnvariable="q_select_dunning_letters">
		<cfinvokeargument name="companykey" value="#request.q_select_company_admin.companykey#">
	</cfinvoke>
	
	<!--- check dunning one or two ... --->
	<cfquery name="q_select_dunningletter0" dbtype="query">
	SELECT
		*
	FROM
		q_select_dunning_letters
	WHERE
		dunninglevel = 0
	;
	</cfquery>
	
	<cfif q_select_dunningletter0.recordcount GT 0>
		<div style="background-color:#EEEEEE;padding:6px;border:orange solid 1px;"><a href="default.cfm?action=invoices">Es liegen offene Rechnungen vor - jetzt anzeigen ...</a></div>
	</cfif>
		
	<cfquery name="q_select_dunningletter1" dbtype="query">
	SELECT
		*
	FROM
		q_select_dunning_letters
	WHERE
		dunninglevel = 1
	;
	</cfquery>	
	
	<cfif q_select_dunningletter1.recordcount GT 0>
		<div style="background-color:#EEEEEE;padding:6px;border:orange solid 1px;"><a style="font-weight:bold;" href="default.cfm?action=invoices">Es liegen offene und bereits gemahnte Rechnungen vor - jetzt anzeigen ...</a></div>
	</cfif>
	
	<cfquery name="q_select_dunningletter2" dbtype="query">
	SELECT
		*
	FROM
		q_select_dunning_letters
	WHERE
		dunninglevel = 2
	;
	</cfquery>
	
	<cfif q_select_dunningletter2.recordcount GT 0>
		<cfparam name="url.action" type="string" default="">
		
		<div style="background-color:#EEEEEE;padding:6px;border:orange solid 1px;"><img src="/images/img_attention.png" align="left" vspace="6" hspace="6"><a style="font-weight:bold;" href="default.cfm?action=invoices"><cfoutput>#GetLangVal('adm_ph_access_blocked_open_invoice1')#</cfoutput></a>
		<br /><br />  
		<cfoutput>#GetLangVal('adm_ph_access_blocked_open_invoice2')#</cfoutput>
		
		<br /><br />  
		
		</div><br><br>
		
		<cfif FindNoCase('dl_invoice.cfm', cgi.SCRIPT_NAME) IS 0 AND ListFindNoCase('invoices,paybill', url.action) IS 0>
			
			<cfhtmlhead text="<meta http-equiv=""refresh"" content=""3;URL=default.cfm?action=invoices"">">
			<cfabort>		
		</cfif>
	</cfif> --->
</cfif>

<!--- check now ... --->
<cfif Len(url.companykey) IS 0>
		
		
		<form method="get" action="<cfoutput>#cgi.SCRIPT_NAME#</cfoutput>">
		<table class="table_details table_edit_form">
		
		<cfloop collection="#url#" item="F">
		
			<cfif ListFindNoCase('companykey', f) IS 0>
				<cfoutput>
				<input type="hidden" name="#lcase(f)#" value="#structFind(url, F)#">
				</cfoutput>
			</cfif>
		
		</cfloop>	
		
		
		<cfset a_bol_data_missing = true />
			
		  <tr>
			<td class="field_name"></td> 
			<td>
				<b><cfoutput>#si_img('exclamation')# #GetLangVal('adm_ph_please_select_desired_customer')#</cfoutput></b>
			</td>
		  <tr>
			<td class="field_name"><cfoutput>#GetLangVal('adm_wd_customer')#</cfoutput>:</td>
			<td>
			<select name="companykey">
			<!--- is this user a reseller? load all sub companies --->
				<cfif request.a_bol_is_reseller>
					<cfinclude template="queries/q_select_companies.cfm">
					
					<cfquery name="q_select_companies" dbtype="query">
					SELECT
						*
					FROM
						q_select_companies
					WHERE
						resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
					;
					</cfquery>
				
					<option value="">--- <cfoutput>#GetLangVal('adm_ph_customers_found')#</cfoutput>: <cfoutput>#q_select_companies.recordcount#</cfoutput> ---</option>
					<cfoutput query="q_select_companies">
					<option value="#htmleditformat(q_select_companies.entrykey)#">#htmleditformat(q_select_companies.companyname)#</option>
					</cfoutput>
				</cfif>
			
				<option value="">--- <cfoutput>#GetLangVal('adm_ph_internal_companies_found')#</cfoutput>: <cfoutput>#request.q_select_company_admin.recordcount#</cfoutput> ---</option>
				<cfoutput query="request.q_select_company_admin">
				<option value="#htmleditformat(request.q_select_company_admin.companykey)#">#htmleditformat(request.q_select_company_admin.companyname)#</option>
				</cfoutput>
			</select>		
			</td>
		  </tr>
		  
		  <tr>
			<td class="field_name">&nbsp;</td>
			<td><input type="submit" value="<cfoutput>#GetLangVal('adm_ph_btn_search_filter')#</cfoutput>" class="btn" /></td>
		  </tr>
			  
		<cfif StructKeyExists(session, 'a_str_last_companykey')>
		 <tr>
			<td class="field_name">&nbsp;</td>
			<td>
			<cfoutput>#GetLangVal('adm_ph_last_selected_company')#</cfoutput>&nbsp;
			
			<cfoutput>
			<a href="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&companykey=#session.a_str_last_companykey#">#si_img('lorry')# #session.a_str_last_companyname#</a>
			</cfoutput>
			</td>
		 </tr>
		</cfif>
		</table>
		</form>
		
		
	</cfif>
	
<cfif a_bol_data_missing IS TRUE>
	<cfthrow errorcode="abortpageprocessing">
<cfelse>

	<!--- check if this user has access to this company
	
		(SECURITY)
		
		--->
		
	<!---
	<cfquery name="q_select_access_allowed" dbtype="query">
	SELECT
		*
	FROM
		q_select_company_admin
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
	;
	</cfquery>
	
	<cfif q_select_access_allowed.recordcount is 0>
		<h4>405 access not allowed</h4>
		<cfabort>
	</cfif>--->
		
		
</cfif>

<cfquery name="q_select_company_name_2_display" datasource="#request.a_str_db_users#">
SELECT
	companyname,resellerkey,status
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<cflock scope="session" type="exclusive" timeout="3">
	<cfset session.a_str_last_companykey = url.companykey>
	<cfset session.a_str_last_resellerkey = q_select_company_name_2_display.resellerkey>
	<cfset session.a_str_last_companyname = q_select_company_name_2_display.companyname>
</cflock>

<div class="b_all mischeader" style="padding:6px;margin-bottom:10px;">
<img src="/images/si/wrench.png" class="si_img" /> <b><cfoutput>#GetLangVal('adm_ph_you_are_now_in_the_admintool')#</cfoutput></b>
<br /> 
<img src="/images/space_1_1.gif" class="si_img" alt="" /> <cfoutput>#GetLangVal('adm_ph_selected_customer')#</cfoutput>: <a href="default.cfm?action=customerproperties&<cfoutput>#WriteURLTags()#</cfoutput>"><b><cfoutput>#htmleditformat(q_select_company_name_2_display.companyname)#</cfoutput></b></a> <cfif q_select_company_name_2_display.status IS 1> [ <font color="red"><cfoutput>#GetLangVal('cm_wd_trialphase')#</cfoutput></font> ]</cfif>
</div>