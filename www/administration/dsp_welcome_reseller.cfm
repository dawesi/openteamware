<!--- //

	
	
	// --->
	
<h4><cfoutput>#GetLangVal('adm_ph_welcome')#</cfoutput></h4>

<cfquery name="q_select_customers">
SELECT
	companyname,entrykey,createdbyuserkey,zipcode,city,countryisocode,status,dt_created,resellerkey,customerid
FROM
	companies
WHERE
	<cfif Compare(request.a_str_reseller_entry_key, '5872C37B-DC97-6EA3-E84EC482D29FC169') NEQ 0>
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_reseller_entry_key#">
	AND
	</cfif>
	
	disabled = 0
ORDER BY
	dt_created DESC
LIMIT 14
;
</cfquery>

<cfquery name="q_select_customers_trial_end">
SELECT
	companyname,entrykey,createdbyuserkey,zipcode,city,countryisocode,status,dt_created,resellerkey,customerid,dt_trialphase_end
FROM
	companies
WHERE
	<cfif Compare(request.a_str_reseller_entry_key, '5872C37B-DC97-6EA3-E84EC482D29FC169') NEQ 0>
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_reseller_entry_key#">
	AND
	</cfif>
	
	disabled = 0
	AND
	status = 1
	<!---AND
	dt_trialphase_end > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(DateAdd('d', -10, Now()))#">--->
	AND
	autoorderontrialend = 1
ORDER BY
	dt_trialphase_end
LIMIT 14
;
</cfquery>

<cfquery name="request.q_select_reseller" dbtype="query">
SELECT
	*
FROM
	request.q_select_reseller
WHERE
	contractingparty = 1
	AND NOT
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_reseller_entry_key#">
;
</cfquery>

<table border="0" cellspacing="10" cellpadding="6">
  <tr>
  	<form action="index.cfm" method="get">
	<input type="hidden" name="action" value="customers">
  	<td width="50%" class="b_all" valign="top">
	
		<b><img border="0" src="/images/admin/img_loupe_32x32.gif" align="absmiddle"> <cfoutput>#GetLangVal('adm_ph_search_customer')#</cfoutput></b><br><br>
		<input type="text" name="search" size="20">
		
		&nbsp;
		
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput> ...">
		<br><br>
		<font class="addinfotext"><cfoutput>#GetLangVal('adm_ph_search_customer_description')#</cfoutput></font>
				
	</td>
	</form>
  	<td width="50%" class="b_all" valign="top">
		
		<b><img border="0" src="/images/admin/img_partner_32x32.gif" align="absmiddle"> <cfoutput>#GetLangVal('adm_ph_assigned_partners')#</cfoutput></b>
		<br><br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
			<ul style="line-height:18px; ">
				<li><a href="index.cfm?action=reseller"><b><cfoutput>#GetLangVal('adm_ph_assigned_partners_showall')#</cfoutput></b></a></li>
				<cfoutput query="request.q_select_reseller" startrow="1" maxrows="5">
					<li><a href="index.cfm?action=resellerproperties&resellerkey=#request.q_select_reseller.entrykey#">#request.q_select_reseller.companyname#</a></li>
				</cfoutput>
			</ul>
			</td>
		  </tr>
		</table>
		
	</td>
	
  </tr>
  
  <tr>
	<td class="b_all">
		<a style="font-weight:bold; " href="index.cfm?action=newcustomer"><img src="/images/arrows/img_green_button_16x16.gif" align="absmiddle" border="0"> <cfoutput>#GetLangVal('adm_ph_create_new_customer')#</cfoutput></a>
	</td>  
    <td class="b_all">
	
		<a href="index.cfm?action=Stat"><b><img src="/images/icon/img_stat_32x32.gif" align="absmiddle" border="0"> <cfoutput>#GetLangVal('adm_ph_statistics_and_reporting')#</cfoutput></b></a>
	</td>	
  </tr>    
  <tr>
    <td valign="top" width="50%" class="b_all mischeader">
		
		<b><img border="0" src="/images/admin/img_flash_32x32.gif" align="absmiddle"> <cfoutput>#GetLangVal('adm_ph_new_interested_and_customers')#</cfoutput></b>
		<br><br>
		
		<table width="100%" border="1" cellspacing="0" bgcolor="white" cellpadding="4" bordercolor="#EEEEEE" style="border-collapse:collapse; ">
		<cfoutput query="q_select_customers">
		  <tr>
			<td valign="top">
				<a href="index.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_customers.entrykey)#&resellerkey=#urlencodedformat(q_select_customers.resellerkey)#"><b>&raquo; #htmleditformat(shortenstring(checkzerostring(q_select_customers.companyname), 15))#</b></a>
				<br>
				&nbsp;&nbsp;#q_select_customers.customerid#
			</td>
			<td valign="top">
				#ucase(q_select_customers.countryisocode)# #q_select_customers.zipcode#<br>#htmleditformat(q_select_customers.city)#
			</td>
			<td valign="top">
				#DateFormat(q_select_customers.dt_created, 'dd.mm.yy')#
			</td>
			<td valign="top" align="center">
				<cfif q_select_customers.status IS 0>
				#GetLangVal('cm_wd_char_customer')#
				<cfelse>
				#GetLangVal('cm_wd_char_interested_party')#
				</cfif>
			</td>
		  </tr>
		 </cfoutput>
		</table>
		

	
	</td>
    <td valign="top" width="50%" class="b_all mischeader">
	
		<b><img border="0" src="/images/admin/img_clock_32x32.gif" align="absmiddle"> <cfoutput>#GetLangVal('adm_ph_ending_trials')#</cfoutput></b>
		<br>
		<br>
		<!---<cfdump var="#q_select_customers_trial_end#">--->
		
		<table width="100%" border="1" cellspacing="0" bgcolor="white" cellpadding="4" bordercolor="#EEEEEE" style="border-collapse:collapse; ">
		<cfoutput query="q_select_customers_trial_end">
		  <tr>
			<td valign="top">
				<a href="index.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_customers_trial_end.entrykey)#&resellerkey=#urlencodedformat(q_select_customers_trial_end.resellerkey)#"><b>&raquo; #htmleditformat(shortenstring(checkzerostring(q_select_customers_trial_end.companyname), 15))#</b></a>
				<br>
				&nbsp;&nbsp;#q_select_customers_trial_end.customerid#
			</td>
			<td valign="top">
				#ucase(q_select_customers_trial_end.countryisocode)# #q_select_customers_trial_end.zipcode#<br>#htmleditformat(q_select_customers_trial_end.city)#
			</td>
			<!---<td valign="top">
				#DateFormat(q_select_customers_trial_end.dt_trialphase_end, 'dd.mm.yy')#
			</td>--->
			<td valign="top" align="center">
				<cfset a_int_diff = DateDiff('d', Now(), q_select_customers_trial_end.dt_trialphase_end) + 1>
				
				
				<cfif a_int_diff LT 0>
					#ReplaceNoCase(GetLangVal('cm_ph_n_days_ago'), '%DAYS%', a_int_diff)#
				<cfelseif a_int_diff IS 0>
					#GetLangVal('cm_wd_today')#
				<cfelseif a_int_diff IS 1>
					#GetLangVal('cm_wd_tommorrow')#
				<cfelse>
					#ReplaceNoCase(GetLangVal('cm_ph_in_n_days'), '%DAYS%', a_int_diff)#
				</cfif>
			</td>
		  </tr>
		 </cfoutput>
		</table>
	
	</td>
  </tr>
</table>