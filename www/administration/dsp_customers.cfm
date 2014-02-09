<!--- //



	list customers

	

	// --->

	

<cfparam name="url.subaction" type="string" default="ShowWelcome">

<cfparam name="url.resellerkey" type="string" default="">

<cfparam name="url.search" type="string" default="">

<cfparam name="url.frmrating" type="numeric" default="0">

<cfparam name="url.frmstatus" type="numeric" default="-1">

<cfparam name="url.frmcustomertype" type="numeric" default="-1">

<cfparam name="url.frmshowdisabledtoo" type="numeric" default="0">

<cfparam name="url.startrow" type="numeric" default="1">

<!--- load all companies --->
<cfinclude template="queries/q_select_companies.cfm">


<cfinclude template="utils/inc_check_security.cfm">


<cfif url.frmshowdisabledtoo IS 0>
<cfquery name="q_select_companies" dbtype="query">
SELECT
	*
FROM
	q_select_companies
WHERE
	disabled = 0
;
</cfquery>
</cfif>

<cfif len(url.resellerkey) gt 0>
	<cfquery name="q_select_companies" dbtype="query">
	SELECT
		*
	FROM
		q_select_companies
	WHERE
		resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
		OR 
		distributorkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
	;
	</cfquery>

</cfif>




<cfif len(url.search) gt 0>

	<!--- search ... --->
	<cfquery name="q_select_users" datasource="#request.a_str_db_users#">
	SELECT
		firstname,surname,username,companykey
	FROM
		users
	WHERE
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_companies.entrykey)#" list="yes">)
		AND
		(
		UPPER(username) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		OR
		UPPER(firstname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		OR
		UPPER(surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		)
	;
	</cfquery>

	<cfquery name="q_select_companies" dbtype="query">
	SELECT
		*
	FROM
		q_select_companies
	WHERE
		UPPER(companyname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		OR
		UPPER(street) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		OR
		UPPER(contactperson) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		OR
		UPPER(email) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
		
		<cfif isnumeric(url.search)>
		OR
		zipcode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.search#%">
		</cfif>
		
		<cfif q_select_users.recordcount GT 0>
		OR
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_users.companykey)#" list="yes">)
		</cfif>
		
		<cfif isnumeric(url.search)>
		OR
		customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.search#">
		</cfif>
	;
	</cfquery>

</cfif>

<cfif val(url.frmrating) gt 0>

	<!--- search ... --->

	<cfquery name="q_select_companies" dbtype="query">
	SELECT
		*
	FROM
		q_select_companies
	WHERE
		rating = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.frmrating#">
	;
	</cfquery>

</cfif>

<cfif val(url.frmstatus) gte 0>

	<!--- search ... --->

	<cfquery name="q_select_companies" dbtype="query">
	SELECT
		*
	FROM
		q_select_companies
	WHERE
		status = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.frmstatus#">
	;
	</cfquery>

</cfif>

<cfif val(url.frmcustomertype) gte 0>

	<cfquery name="q_select_companies" dbtype="query">
	SELECT
		*
	FROM
		q_select_companies
	WHERE
		customertype = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.frmcustomertype#">
	;
	</cfquery>

</cfif>

<h4><img src="/images/admin/img_companies.png" width="32" height="32" hspace="2" vspace="2" border="0" align="absmiddle"> <cfoutput>#GetLangVal('adm_ph_nav_customer_administration')#</cfoutput></h4>

<a href="default.cfm?action=newcustomer"><img src="/images/new_event.gif" width="12" height="12" hspace="2" vspace="2" border="0" align="absmiddle"> <b><cfoutput>#GetLangVal('adm_ph_create_new_customer')#</cfoutput></b></a>

<!---<cfif StructKeyExists(url, 'downloadcsv')>
	<cfset session.q_select_companies_csv_download = q_select_companies>
	<script type="text/javascript">
		window.open('tools/dl_customers_csv.cfm', '_blank');
	</script>	
<cfelse>
	| <a href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&downloadcsv=1">Als CSV herunterladen</a>
</cfif>--->

<table border="0" cellspacing="0" cellpadding="4">
<form action="default.cfm" method="get" name="formcustomers">
<input type="hidden" name="action" value="customers">
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_wd_partner')#</cfoutput>: 
	</td>
	<td>
	<select name="resellerkey">
		<option value=""><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></option>
		<cfoutput query="q_select_reseller">
		<option #writeselectedelement(q_Select_reseller.entrykey,url.resellerkey)# value="#htmleditformat(q_Select_reseller.entrykey)#"><cfloop from="1" to="#q_select_reseller.resellerlevel#" index="ii">&nbsp;</cfloop>#htmleditformat(q_Select_reseller.companyname)#</option>
		</cfoutput>
	</select>
	<br>
	<a href="javascript:OpenSelectPopup();"><cfoutput>#GetLangVal('cm_ph_select_now')#</cfoutput></a>
	
	<script type="text/javascript">
		function OpenSelectPopup()
			{
			
			url = "show_select_reseller.cfm";
			var mywin = window.open(url, "show_select_reseller", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=480,HEIGHT=240");
			mywin.window.focus();
			}
	</script>
	</td>
    <td align="right">
		<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>:
	</td>
	<td>
		<input type="text" value="<cfoutput>#htmleditformat(url.search)#</cfoutput>" name="search" size="10">
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('cm_wd_status')#</cfoutput>:
	</td>
	<td>
	<select name="frmstatus">
		<cfoutput>
		<option value="-1" #writeselectedelement(url.frmstatus, -1)#>#GetLangVal('cm_wd_all')#</option>
		<option value="0" #writeselectedelement(url.frmstatus, 0)#>#GetLangVal('adm_wd_customer')#</option>
		<option value="1" #writeselectedelement(url.frmstatus, 1)#>#GetLangVal('adm_ph_interested_party')#</option>
		</cfoutput>
	</select>
	</td>
	<td align="right">
		<cfoutput>#GetLangVal('adm_wd_rating')#</cfoutput>:
	</td>
    <td>
		<select name="frmrating">
			<cfoutput>
			<option value="0" #writeselectedelement(url.frmrating, 0)#>#GetLangVal('cm_wd_all')#</option>
			<option value="5" #writeselectedelement(url.frmrating, 5)#>#GetLangVal('adm_wd_rating_import')#</option>
			<option value="3" #writeselectedelement(url.frmrating, 3)#>#GetLangVal('adm_wd_rating_default')#</option>
			<option value="1" #writeselectedelement(url.frmrating, 1)#>#GetLangVal('adm_wd_rating_not_important')#</option>
			</cfoutput>
		</select>
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_wd_type')#</cfoutput>:
	</td>
	<td>
	<select name="frmcustomertype">
		<cfoutput>
		<option value="-1" #writeselectedelement(url.frmcustomertype, -1)#>#GetLangVal('cm_wd_all')#</option>
		<option value="1" #writeselectedelement(url.frmcustomertype, 1)#>#GetLangVal('adm_wd_type_organization')#</option>
		<option value="0" #writeselectedelement(url.frmcustomertype, 0)#>#GetLangVal('adm_wd_type_private')#</option>
		</cfoutput>
	</select>
	</td>  
	<td colspan="2" align="center">
	<input type="submit" value="<cfoutput>#GetLangVal('adm_ph_btn_search_filter')#</cfoutput>">
	</td>
  </tr>
  <tr>
  	<td align="right">
		<input type="checkbox" name="frmshowdisabledtoo" value="1" class="noborder">
	</td>
	<td>
		<cfoutput>#GetLangVal('adm_ph_show_disabled_too')#</cfoutput>
	</td>
  </tr>
</form>
</table>

<br>

<table class="table_overview" cellspacing="0">

<!--- scroller --->
<cfset a_int_maxrows = 100>

<cfif q_select_companies.recordcount GT a_int_maxrows>

<tr>
	<td colspan="9" align="center">
		<cfoutput>#GetLangVal('adm_ph_customers_found')#</cfoutput>: <cfoutput>#q_select_companies.recordcount#</cfoutput>
		&nbsp;&nbsp;
		|
		<cfloop from="1" to="#q_select_companies.recordcount#" step="#a_int_maxrows#" index="a_int_step">
			<cfset a_str_query_string = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'startrow', a_int_step)>
			
			<cfoutput>
			<a href="default.cfm?#a_str_query_string#">#a_int_step# - #(a_int_step+99)#</a>
			|
			</cfoutput>
		</cfloop>
		
	</td>
</tr>
</cfif>


<cfoutput>
  <tr class="tbl_overview_header">

    <td>&nbsp;</td>

    <td><b>#GetLangVal('cm_wd_name')#</b></td>

    <td>#GetLangVal('cm_wd_created')#</td>
	
	<td>#GetLangVal('adm_wd_rating')#</td>
	
	<td>#GetLangVal('cm_wd_status')#</td>

	<td>#GetLangVal('adm_wd_expiration')#</td>

	<td>#GetLangVal('adm_wd_accounts')#</td>
	
	<td>#GetLangVal('cm_wd_domain')#</td>

	<td>#GetLangVal('adm_wd_partner')#</td>

  </tr>
</cfoutput>
 

  <cfoutput query="q_select_companies" startrow="#url.startrow#" maxrows="#a_int_maxrows#">
  
  <cfquery name="q_select_is_reseller" datasource="#request.a_str_db_users#">
  SELECT
  	COUNT(id) AS count_id
  FROM
  	reseller
  WHERE
  	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
  ;
  </cfquery>

  <tr>

    <td>## #q_select_companies.currentrow#</td>

    <td>
	
	<a href="default.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_companies.entrykey)#&resellerkey=#urlencodedformat(q_select_companies.resellerkey)#">#htmleditformat(shortenstring(CheckZeroString(q_select_companies.companyname), 30))#</a>
	
	<cfif q_select_is_reseller.count_id IS 1>
		[RS]
	</cfif>

	</td>

	<td>

	#lsdateformat(q_select_companies.dt_created, "dd.mm.yy")#

	</td>
	</td>

	<td align="center">
		<cfswitch expression="#q_select_companies.rating#">
			<cfcase value="5">
				<img src="/images/images/high.png" width="7" height="18" align="absmiddle">
			</cfcase>
			<cfcase value="1">
				low
			</cfcase>
			<cfcase value="3">
				~
			</cfcase>
		</cfswitch>
	</td>
	
	<td align="center">
		<cfif q_select_companies.status IS 0>
			#GetLangVal('cm_wd_char_customer')# #q_select_companies.customerid#
		<cfelse>
			<font color="red"><b>#GetLangVal('cm_wd_char_interested_party')#</b>
			<cfif q_select_companies.dt_trialphase_end LT Now()>over</cfif>
			</font>
		</cfif>
	</td>

	<td>

	<cfif isDate(q_select_companies.dt_contractend) is false>

	n/a

	<cfelse>


	<cfif q_select_companies.dt_contractend LT Now()>
		<font color="red">
	</cfif>
	#dateformat(q_select_companies.dt_contractend, "dd.mm.yy")#

	</cfif>

	

	</td>

    <td align="right">

	<!--- number of customers ... --->

	<cfset GetNumberofcustomersRequest.companykey = q_select_companies.entrykey>

	<cfinclude template="queries/q_select_number_of_customers.cfm">

	#q_select_number_of_customers.count_id#

	</td>
	
	<td>
	#shortenstring(q_select_companies.domains,20)#
	</td>

	<td>

	<cfquery name="q_select_reseller_name" dbtype="query">

	SELECT companyname FROM q_Select_reseller

	WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.resellerkey#">;

	</cfquery>

	<a href="default.cfm?action=resellerproperties&entrykey=#q_select_companies.resellerkey#">#htmleditformat(Shortenstring(q_select_reseller_name.companyname, 15))#</a>

	</td>


  </tr>

  </cfoutput>

</table>

<br><br>

<a href="default.cfm?action=newcustomer"><img src="/images/new_event.gif" width="12" height="12" hspace="2" vspace="2" border="0" align="absmiddle"> <b><cfoutput>#GetLangVal('adm_ph_create_new_customer')#</cfoutput></b></a>