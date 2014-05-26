<!--- 





--->



<cfparam name="url.resellerkey" type="string" default="">

<cfparam name="url.subaction" type="string" default="">



<!--- is this user allowed to watch this data? --->

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

<cfinvoke component="/components/management/resellers/cmp_reseller" method="LoadResellerData" returnvariable="q_select_reseller">

	<cfinvokeargument name="entrykey" value="#url.resellerkey#">

</cfinvoke>



<!---<cfdump var="#q_select_reseller#">--->



<h4>Reseller-Eigenschaften</h4>


<!---
<table border="0" cellspacing="0" cellpadding="4" class="b_all">
  <tr>
    <td class="br">
		<a href="index.cfm?action=resellerproperties&resellerkey=<cfoutput>#urlencodedformat(url.resellerkey)#</cfoutput>">&Uuml;bersicht</a>
	</td>
    <td class="br">
		<a href="index.cfm?action=resellerproperties&subaction=sales&resellerkey=<cfoutput>#urlencodedformat(url.resellerkey)#</cfoutput>">Ums&auml;tze</a>
	</td>
    <td>
		<a href="index.cfm?action=resellerproperties&subaction=performance&resellerkey=<cfoutput>#urlencodedformat(url.resellerkey)#</cfoutput>">Performance/Statistik</a>
	</td>
  </tr>
</table>



<br>--->


<table border="0" cellspacing="0" cellpadding="4">

<cfoutput query="q_select_reseller">
  <tr>
  	<td align="right">Vertragspartner:</td>
	<td>
		#YesNoFormat(q_select_reseller.contractingparty)#
	</td>
  </tr>
  
  <cfif ListFindNoCase('5CC09B22-C7D0-A37B-531095FF97EADD33,60A4475A-C14B-BF72-E972FDFA003DA27C',request.stSecurityContext.myuserkey) GT 0>
  	<tr>
		<td></td>
		<td>
			<a href="index.cfm?action=customerproperties&companykey=#q_select_reseller.entrykey#&resellerkey=">Companydata</a>
		</td>
	</tr>
  </cfif>
  <tr>

  	<td align="right" valign="top">Name:</td>

	<td valign="top">

	#htmleditformat(q_select_reseller.companyname)#
	<br>
	#q_select_reseller.street#<br>
	#q_select_reseller.zipcode# #q_select_reseller.city#<br>
	#q_select_reseller.country#
	</td>

  </tr>

  <tr>

    <td align="right">erstellt:</td>

    <td>

	#dateformat(q_select_reseller.dt_created, "dd.mm.yy")#

	</td>

  </tr>
  
  <tr>
  	<td align="right">Kunden:</td>
	<td>
	#q_select_companies.recordcount#
	&nbsp;&nbsp;Konten:
	<cfset a_str_companykey_list = ValueList(q_select_companies.entrykey)&',0'>
	
	<cfquery name="q_select_total_accounts_count" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(userid) AS count_users
	FROM
		users
	WHERE
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey_list#" list="yes">)
	;
	</cfquery>
	
	#q_select_total_accounts_count.count_users#
	
	&nbsp;&nbsp;|&nbsp;&nbsp;
	
	</td>
  </tr>



</table>



<br>

<h4>Aktionen</h4>

<ul style="line-height:20px; ">
	<li>
		<a href="index.cfm?Action=customers&resellerkey=#urlencodedformat(q_select_reseller.entrykey)#"><b>Kundenverwaltung</b></a>
		<br>
		Alle Kunden dieses Resellers anzeigen ...
	
	</li>
	<li>
		<a href="stat/index.cfm?resellerkeys=#urlencodedformat(q_select_reseller.entrykey)#"><b>Reporting anzeigen</b></a>	
		<br>
		Umsatz/Kundenentwicklung/Demographie
	</li>
</ul>
</cfoutput>
<!---
<cfswitch expression="#url.subaction#">

	<cfcase value="performance">
	<cfinclude template="reseller/dsp_inc_performance.cfm">
	</cfcase>
	
	<cfcase value="sales">
	<cfinclude template="reseller/dsp_inc_sales.cfm">
	</cfcase>

</cfswitch>--->