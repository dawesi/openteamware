

<table border="0" cellspacing="0" cellpadding="4" class="lightbg b_all" style="margin:10px;margin-left:0px;">
  <tr>
    <td>
		1. <cfoutput>#GetLangVal('adm_ph_shop_trial_select_accounts')#</cfoutput>
	</td>
    <td>
		<b>2. <cfoutput>#GetLangVal('adm_ph_shop_trial_confirm')#</cfoutput></b>
	</td>
    <td>
		3. <cfoutput>#GetLangVal('adm_ph_shop_trial_ready')#</cfoutput>
	</td>
  </tr>
</table>

<cfset SelectAccounts.CompanyKey = form.frmcompanykey>
<cfinclude template="../queries/q_select_accounts.cfm">

<cfset LoadCompanyData.entrykey = form.frmcompanykey>
<cfinclude template="../queries/q_select_company_data.cfm">


<cfset a_str_list_groupware = ''>
<cfset a_str_list_single = ''>
<cfset a_str_list_delete = ''>

<cfloop list="#form.fieldnames#" delimiters="," index="a_str_index">
	<cfset a_str_value = form[a_str_index]>

	<cfif FindNoCase('frmproductkey_', a_str_index) IS 1>
		<cfset a_str_userkey = ReplaceNoCase(a_str_index, 'frmproductkey_', '')>
		
		<cfswitch expression="#a_str_value#">
			<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
				<cfset a_str_list_groupware = ListPrepend(a_str_list_groupware, a_str_userkey)>
			</cfcase>
			<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
				<cfset a_str_list_single = ListPrepend(a_str_list_single, a_str_userkey)>			
			</cfcase>
			<cfcase value="delete">
				<cfset a_str_list_delete = ListPrepend(a_str_list_delete, a_str_userkey)>			
			</cfcase>
		</cfswitch>
	
	</cfif>
</cfloop>

<cfif ListLen(a_str_list_groupware) IS 0 AND ListLen(a_str_list_single) IS 0>
	<br><br>
	<b>
	You cannot delete ALL accounts.<br>
	Sie koennen nicht alle vorhandenen Konten zum Loeschen auswaehlen!
	<br><br>
	Bitte aendern Sie Ihre Auswahl!
	<br><br>
	<a href="javascript:history.go(-1);">&lt; <cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	</b>
	<cfexit method="exittemplate">
</cfif>

<!--- xy --->
<b><cfoutput>#GetLangVal('adm_ph_shop_trial_check_and_order')#</cfoutput></b>

<br><br>

<form action="default.cfm?action=shop.trialphaseend.addtobasket2" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#form.frmcompanykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#form.frmresellerkey#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="4">
  <tr class="lightbg">
    <td>
		<b>Groupware (<cfoutput>#ListLen(a_str_list_groupware)#</cfoutput>)</b>
	</td>
	<td align="right">
	<!--- show price ... --->
	<cfif ListLen(a_str_list_groupware) IS 0>
		0 EUR
	<cfelse>
	
		<!--- select prices --->
		<cfset SelectPricesRequest.Entrykey =  'AE79D26D-D86D-E073-B9648D735D84F319'>
		<cfinclude template="../queries/q_select_prices.cfm">
		
		<cfinvoke component="#request.a_Str_component_shop#" method="GetPricesEx" returnvariable="q_select_prices">
			<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
			<cfinvokeargument name="companykey" value="#q_select_company_data.entrykey#">
		</cfinvoke>
		
		<cfif q_select_prices.recordcount IS 0>
			<h4>Dieses Produkt wird leider nicht angeboten.</h4>
			<cfexit method="exittemplate">
		</cfif>
	
		<!--- select right price --->
		<cfquery name="q_select_price" dbtype="query" maxrows="1">
		SELECT
			MIN(price1) AS price1
		FROM
			q_select_prices
		WHERE
			quantity <= #val(ListLen(a_str_list_groupware))#
		;
		</cfquery>
		
		<cfset a_int_price = DecimalFormat(12 * q_select_price.price1 * ListLen(a_str_list_groupware))>
		
		<b><cfoutput>#DecimalFormat(q_select_price.price1)#</cfoutput> EUR <cfoutput>#GetLangVal('adm_ph_per_month_account')#</cfoutput></b>
		<br>
		(<cfoutput>#GetLangVal('adm_wd_total')#</cfoutput> <cfoutput>#a_int_price#</cfoutput> EUR)
	</cfif>	
	</td>
  </tr>
  <tr>
    <td>
	<input type="hidden" name="AE79D26D-D86D-E073-B9648D735D84F319" value="<cfoutput>#ListLen(a_str_list_groupware)#</cfoutput>">
	<input type="hidden" name="frmgroupware" value="<cfoutput>#a_str_list_groupware#</cfoutput>">

	<br>
	
	<cfif ListLen(a_str_list_groupware) GT 0>
		<cfquery name="q_select_accounts_groupware" dbtype="query">
		SELECT
			*
		FROM
			q_select_accounts
		WHERE
			entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_list_groupware#" list="yes">)
		;
		</cfquery>
		<blockquote>
		<cfoutput query="q_select_accounts_groupware">
			#q_select_accounts_groupware.username# (#q_select_accounts_groupware.surname#, #q_select_accounts_groupware.firstname#)<br>
		</cfoutput>
		</blockquote>
	</cfif>
	<br>

	<br>

	
	</td>
 </tr>
 <tr class="lightbg">
  	<td>
	<b>PROFESSIONAL <cfoutput>#GetLangVal('adm_wd_accounts')#</cfoutput> (<cfoutput>#GetLangVal('adm_ph_single_seat')#</cfoutput>) (<cfoutput>#ListLen(a_str_list_single)#</cfoutput>)</b>
	<input type="hidden" name="AD4262D0-98D5-D611-4763153818C89190" value="<cfoutput>#ListLen(a_str_list_single)#</cfoutput>">
	<input type="hidden" name="frmprofessional" value="<cfoutput>#a_str_list_single#</cfoutput>">	
	</td>
	<td align="right">
	<cfif ListLen(a_str_list_single) IS 0>
		0 EUR
	<cfelse>
	
		<!--- select prices --->
		<cfset SelectPricesRequest.Entrykey =  'AD4262D0-98D5-D611-4763153818C89190'>
		<cfinclude template="../queries/q_select_prices.cfm">
	
		<!--- select right price --->
		<cfquery name="q_select_price" dbtype="query" maxrows="1">
		SELECT
			MIN(price1) AS price1
		FROM
			q_select_prices
		WHERE
			quantity <= #val(ListLen(a_str_list_single))#
		;
		</cfquery>
		
		<cfset a_int_price = DecimalFormat(12 * q_select_price.price1 * ListLen(a_str_list_single))>
		
		<b><cfoutput>#DecimalFormat(q_select_price.price1)#</cfoutput> EUR <cfoutput>#GetLangVal('adm_ph_per_month_account')#</cfoutput></b>
		<br>
		(<cfoutput>#GetLangVal('adm_wd_total')#</cfoutput> <cfoutput>#a_int_price#</cfoutput> EUR)
	</cfif>	
	</td>
  </tr>
  <tr>
  	<td>
<cfif ListLen(a_str_list_single) GT 0>
	<cfquery name="q_select_accounts_single" dbtype="query">
	SELECT
		*
	FROM
		q_select_accounts
	WHERE
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_list_single#" list="yes">)
	;
	</cfquery>
	<blockquote>
	<cfoutput query="q_select_accounts_single">
		#q_select_accounts_single.username# (#q_select_accounts_single.surname#, #q_select_accounts_single.firstname#)<br>
	</cfoutput>
	</blockquote>
</cfif>
<br>

<b><cfoutput>#GetLangVal('adm_ph_shop_trial_to_delete')#</cfoutput> (<cfoutput>#ListLen(a_str_list_delete)#</cfoutput>)</b><br>
<input type="hidden" name="frmdelete" value="<cfoutput>#a_str_list_delete#</cfoutput>">

<cfif ListLen(a_str_list_delete) GT 0>
	<cfquery name="q_select_accounts_delete" dbtype="query">
	SELECT
		*
	FROM
		q_select_accounts
	WHERE
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_list_delete#" list="yes">)
	;
	</cfquery>
	<blockquote>
	<cfoutput query="q_select_accounts_delete">
		#q_select_accounts_delete.username# (#q_select_accounts_delete.surname#, #q_select_accounts_delete.firstname#)<br>
	</cfoutput>
	</blockquote>
	<br>
</cfif>
	
	</td>
  </tr>
  <tr>
    <td align="right">
		<input type="submit" value="<cfoutput>#GetLangVal('adm_ph_shop_trial_finish_order')#</cfoutput>">
	</td>
  </tr>
</form>  
</table>