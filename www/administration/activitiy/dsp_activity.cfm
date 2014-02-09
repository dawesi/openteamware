<!---

	aktivit�t
	
	--->
	
<cfinclude template="../dsp_inc_select_company.cfm">

<cfsetting requesttimeout="2000">

<cfparam name="url.userkey" type="string" default="">

<cfset SelectAccounts.CompanyKey = url.companykey>
<cfinclude template="../queries/q_select_accounts.cfm">

<cfif q_select_accounts.recordcount IS 0>
	<h2><cfoutput>#GetLangVal('adm_ph_activitiy_no_accounts_yet')#</cfoutput></h2>
	<a href="default.cfm?action=useradministration&<cfoutput>#WriteURLTAgs()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_activitiy_no_accounts_yet_Create_here')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>
	
<cfif Len(url.userkey) GT 0>
	<cfquery name="q_select_account_exists" dbtype="query">
	SELECT
		*
	FROM
		q_select_accounts
	WHERE
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userkey#" list="yes">)
	;
	</cfquery>
	
	<cfif q_select_account_exists.recordcount IS 0>
		ALERT.<br>
		access denied.
		<cfabort>
	</cfif>
</cfif>

<table border="0" cellspacing="0" cellpadding="8">
<form action="default.cfm" method="get">
<input type="hidden" name="action" value="activity">
<input type="hidden" name="companykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="resellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
  <tr>
    <td>
		<select name="userkey" multiple size="5">
			<cfoutput query="q_select_accounts">
				<option <cfif ListFind(url.userkey, q_select_accounts.entrykey) GT 0>selected</cfif> value="#q_select_accounts.entrykey#">#q_select_accounts.username#</option>
			</cfoutput>
		</select>
	</td>
    <td>
		<input type="submit" value="Anzeigen">
		<br><br>
		<span class="addinfotext"><cfoutput>#GetLangVal('adm_ph_activitiy_no_accounts_multiselect_possible')#</cfoutput></span>
	</td>
  </tr>
</form>
</table>

<br>

<cfif StructKeyExists(variables, 'q_select_account_exists')>
	<b><cfoutput>#GetLangVal('adm_ph_activitiy_no_accounts_selected_accounts')#</cfoutput>: <cfoutput>#ValueList(q_select_account_exists.username)#</cfoutput></b>
</cfif>
<br>

<h4><cfoutput>#GetLangVal('adm_ph_activitiy_logins')#</cfoutput></h4>
<cfoutput>#GetLangVal('adm_ph_activitiy_logins_description')#</cfoutput><br>

<cfset a_struct_filter = StructNew()>

<cfset a_struct_filter.companykey = url.companykey>
<cfset a_struct_filter.userkeys = url.userkey>

<cfinvoke component="/components/stat/cmp_stat" method="Customers_GenerateReturnQuery" returnvariable="stReturn">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="stat_type" value="logins">
	<cfinvokeargument name="interval" value="week">
</cfinvoke>

<cftry>
<cfchart chartwidth="600" format="png" showxgridlines="no" showygridlines="no" showborder="no" fontbold="no" fontitalic="no" show3d="no" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
	<cfchartseries query="stReturn.q_return" type="curve" valuecolumn="data1" itemcolumn="date_data_display"></cfchartseries>
</cfchart>
<cfcatch type="any"> </cfcatch>
</cftry>

<!--- logins finished --->

<cfset a_struct_filter = StructNew()>

<cfset a_struct_filter.companykey = url.companykey>
<cfset a_struct_filter.userkeys = url.userkey>

<cfinvoke component="/components/stat/cmp_stat" method="Customers_GenerateReturnQuery" returnvariable="stReturn">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="stat_type" value="usage">
	<cfinvokeargument name="interval" value="week">
</cfinvoke>

<cfset q_select_services = stReturn.q_select_services>

<cfquery name="q_return" dbtype="query">
SELECT
	<cfloop from="1" to="#q_select_services.recordcount#" index="ii">data#ii#,</cfloop>date_start,date_end,date_data_display
FROM
	stReturn.q_return
;
</cfquery>

<!---<cfdump var="#q_return#">

<cfdump var="#q_select_services#">--->
<h4><cfoutput>#GetLangVal('adm_ph_activitiy_most_used_services')#</cfoutput></h4>
<cfchart chartwidth="600" format="png" showxgridlines="no" showygridlines="no" showborder="no" fontbold="no" fontitalic="no" show3d="no" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
	<cfchartseries query="q_select_services" type="pie" valuecolumn="total_clicks" itemcolumn="servicename"></cfchartseries>
</cfchart>

<h4><cfoutput>#GetLangVal('adm_ph_activitiy_most_used_services_usage')#</cfoutput></h4>
<cfchart chartwidth="600" format="png" showxgridlines="no" showygridlines="no" showborder="no" fontbold="no" fontitalic="no" show3d="no" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
	<cfloop query="q_select_services">
	<cfchartseries query="q_return" type="curve" serieslabel="#q_select_services.servicename#" valuecolumn="data#q_select_services.currentrow#" itemcolumn="date_data_display"></cfchartseries>
	</cfloop>
</cfchart>

