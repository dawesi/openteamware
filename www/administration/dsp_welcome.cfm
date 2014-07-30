<!--- //

	Service:	Admintool
	Action:		ShowWelcome
	Description:
		Header:		

// --->

<cfif ListFindNoCase('5CC09B22-C7D0-A37B-531095FF97EADD33,60A4475A-C14B-BF72-E972FDFA003DA27C',request.stSecurityContext.myuserkey) GT 0>
	<h4><a href="god/" target="_blank">/god/</a> (Admin-Funktionen)</h4>
	<h4><a href="checknewaccounts/" target="_blank">CheckNewAccounts</a> (Neuanmeldungen ueberpruefen)</h4>
	<br /> 
</cfif>

<cfif request.a_bol_is_reseller>
	<cfinclude template="dsp_welcome_reseller.cfm">
</cfif>

<cfinclude template="dsp_inc_select_company.cfm">


<cfset LoadCompanyData.entrykey = url.companykey />
<cfinclude template="queries/q_select_company_data.cfm">

<cfoutput>
<h3 style="margin-bottom:3px;"><cfoutput>#GetLangVal('adm_ph_welcome_to_the_admintool')#</cfoutput>!</h3>
</cfoutput>

<table border="0" cellspacing="0" cellpadding="10">

<cfif request.a_bol_is_reseller>
  <tr>
  	<td colspan="2" class="bb">
	<b>Reseller-Funktionen</b>
	</td>
  </tr>
  <tr>

    <td width="50%" valign="top">

	

		<table border="0" cellspacing="0" cellpadding="4" class="b_all" width="100%">

		  <tr class="lightbg">

			<td colspan="2"><a href="index.cfm?action=customers"><b><cfoutput>#GetLangVal('adm_ph_nav_customer_administration')#</cfoutput></b></a></td>

		  </tr>

		  <tr>

		  	<td valign="top">

			<img src="/images/admin/img_people.png" width="32" height="32" border="0">

			</td>

			<td style="line-height:20px;">

			<a href="index.cfm?action=newcustomer"><cfoutput>#GetLangVal('adm_ph_create_new_customer')#</cfoutput></a><br>
			<a href="index.cfm?action=customers"><cfoutput>#GetLangVal('adm_ph_search_customer')#</cfoutput></a><br>
			<a href="index.cfm?action=showinterestedparties"><cfoutput>#GetLangVal('adm_ph_show_interested_parties')#</cfoutput></a>

			</td>

		  </tr>

		</table>



	

	</td>

    <td width="50%" valign="top">

	

		<table border="0" cellspacing="0" cellpadding="4" class="b_all" width="100%">

		  <tr class="lightbg">

			<td colspan="2"><b><cfoutput>#GetLangVal('cm_wd_administration')#</cfoutput></b></td>

		  </tr>

		  <tr>

		  	<td valign="top">

			<img src="/images/img_boxes_and_folder.png" width="32" height="32" border="0" align="absmiddle">

			</td>

			<td style="line-height:20px;">

			<a href="index.cfm?action=reseller"><cfoutput>#GetLangVal('adm_wd_partners')#</cfoutput></a><br>			

			<a href="index.cfm?action=invoices"><cfoutput>#GetLangVal('adm_ph_nav_billing')#</cfoutput></a><br>

			<!---<a href="index.cfm?action=commission">Provision/Abrechnungen</a>--->

			</td>

		  </tr>

		</table>	

	

	</td>

  </tr>
  <!---<tr>
  	<td colspan="2" class="bb">
	
	<b>To Do</b>
	
	</td>
  </tr>--->
  <!---<tr>
  	<td colspan="2">
	
	<cfinclude template="queries/q_select_companies.cfm">
		
	<cfquery name="q_select_markedcontact" dbtype="query">
	SELECT
		*
	FROM
		q_select_companies
	WHERE
		dt_nextcontact IS NOT NULL
	ORDER BY
		dt_nextcontact
	;
	</cfquery>
	
	
	<i><b>Vorgemerkte Kontaktaufnahmen (<cfoutput>#q_select_markedcontact.recordcount#</cfoutput>)</b></i>
	<br>
	
	<table border="0" cellspacing="0" cellpadding="4">
	<cfoutput query="q_select_markedcontact">
		  <tr>
			<td>
				#DateFormat(q_select_markedcontact.dt_nextcontact, 'dd.mm.yy')#
			</td>
			<td>
				<a href="index.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_markedcontact.entrykey)#&resellerkey=#urlencodedformat(q_select_markedcontact.resellerkey)#">#q_select_markedcontact.companyname#</a>
			</td>
			<td>
				<cfif q_select_markedcontact.status IS 0>
				Kunde
				<cfelse>
				Interessent
				</cfif>
			</td>
		  </tr>
	</cfoutput>
	</table>
	
	<br>
	
	<i>Auslaufende Trial-Phasen</i>
	
	<br><br>
	
	<i>&Uuml;berf&auml;llige Kundenzahlungen</i>
	
	<br><br>
	<i>To-Do Eintraege aus der Aufgabenliste</i>
	</td>
  </tr>--->
</cfif>
  <tr>

    <td>&nbsp;</td>

    <td>
	

	<table border="0" cellspacing="0" cellpadding="4" class="b_all" width="100%">

		  <tr class="lightbg">

			<td colspan="2"><a href="index.cfm?action=shop<cfoutput>#WriteURLTags()#</cfoutput>"><b><cfoutput>#GetLangVal('adm_ph_edit_administrator_rights_shop')#</cfoutput></b></a></td>

		  </tr>

		  <tr>

		  	<td valign="top">

			<img src="/images/si/basket.png" class="si_img" />

			</td>

			<td style="line-height:20px;">

			<a href="index.cfm?action=shop<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_licence_users')#</cfoutput></a><br>			

			<a href="index.cfm?action=shop<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_licence_space')#</cfoutput></a><br>

			<a href="index.cfm?action=shop<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('acc_ph_buy_points')#</cfoutput></a>

			</td>

		  </tr>

		</table>

	

	</td>

  </tr>


<cfif request.a_bol_is_company_admin>

<!--- are we in the trial phase --->

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfif q_select_company_data.status IS 1>
	<tr>
		<td colspan="2">
			<div style="background-color:lightyellow;border:orange solid 2px;padding:8px;">
			<cfif request.a_bol_is_reseller>
			<b><cfoutput>#GetLangVal('adm_ph_customer_is_in_trial')#</cfoutput></b>
			<cfelse>
		
			<b><cfoutput>#GetLangVal('adm_ph_you_are_in_trial')#</cfoutput></b>
			</cfif>	
			<br><br>
			<cfoutput>#GetLangVal('cal_wd_end')#</cfoutput>: <cfoutput>#LSDateFormat(q_select_company_data.dt_trialphase_end, 'ddd, dd.mm.yy')#</cfoutput>
			<!---<br>
			Sie haben noch <cfoutput>#(DateDiff('d', now(), q_select_company_data.dt_trialphase_end)+1)#</cfoutput> Tag(e) Zeit openTeamWare.com kostenlos zu testen.--->
			<br>
			<br>
			
			<cfif (q_select_company_data.settlement_type NEQ 0) AND NOT (request.a_bol_is_reseller)>
				<!--- this customer is not allwed to order in the shop, has to order at the reseller --->
				
				<!--- check if shop url has been provided ... --->
				<cfset a_struct_links = application.components.cmp_customize.GetCustomStyleData(entryname = 'links', usersettings = session.stUserSettings)>
			
				<cfset a_str_shop_url = a_struct_links.shop>
				
				<cfif Len(a_str_shop_url) IS 0>
					<!--- forward to feedback form ... --->
					<cflocation addtoken="no" url="index.cfm?action=partnerfeedbackform&reason=shop">		
				<cfelse>
					<a style="font-weight:bold; " target="_blank" href="<cfoutput>#a_str_shop_url#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_shop_open_click')#</cfoutput></a>
				</cfif>
				
			<cfelse>
				<a href="index.cfm?action=shop.trialphaseend<cfoutput>#writeurltags()#</cfoutput>"><b><cfoutput>#GetLangVal('adm_ph_ordner_inboxcc_now')#</cfoutput></b></a>				
			</cfif>
			
			
			
			<br><br>
			<cfoutput>#GetLangVal('Wenden Sie sich bei Fragen bitte an Ihren Berater (siehe Ende der Seite)')#</cfoutput>
			</div>
		</td>
	</tr>			
</cfif>

  <tr>
  	<td colspan="2" class="bb">
	<b><cfoutput>#GetLangVal('cm_wd_administration')#</cfoutput></b>
	</td>
  </tr>
  <tr>
  <tr>

    <td width="50%" valign="top">

	

		<table border="0" cellspacing="0" cellpadding="4" class="b_all" width="100%">

		  <tr class="lightbg">

			<td colspan="2"><b><cfoutput>#GetLangVal('adm_ph_edit_administrator_group_admin')#</cfoutput></b></td>

		  </tr>

		  <tr>

		  	<td valign="top">

			<img src="/images/si/group.png" class="si_img" />

			</td>

			<td style="line-height:20px;">

			<a href="index.cfm?action=workgroups"><cfoutput>#GetLangVal('cm_wd_groups')#</cfoutput></a><br>

			<a href="index.cfm?action=workgroups"><cfoutput>#GetLangVal('adm_ph_members_administration')#</cfoutput></a><br>

			<a href="index.cfm?action=roles"><cfoutput>#GetLangVal('adm_ph_roles_and_permissions')#</cfoutput></a><br>			

			<a href="index.cfm?action=stat"><cfoutput>#GetLangVal('adm_wd_statistics')#</cfoutput></a>

			</td>

		  </tr>

		</table>



	

	</td>

    <td width="50%" valign="top">

	

		<table border="0" cellspacing="0" cellpadding="4" class="b_all" width="100%">

		  <tr class="lightbg">

			<td colspan="2"><b><cfoutput>#GetLangVal('adm_ph_edit_administrator_user_admin')#</cfoutput></b></td>

		  </tr>

		  <tr>

		  	<td valign="top">

			<img src="/images/si/user.png" class="si_img" />

			</td>

			<td style="line-height:20px;">

			<a href="index.cfm?action=useradministration<cfoutput>#writeURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_nav_user_administration_list')#</cfoutput></a><br />			

			<a href="index.cfm?action=newuser<cfoutput>#writeURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_nav_user_administration_new_user')#</cfoutput></a><br />

			<a href="index.cfm?action=licence.status<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_show_licence_status')#</cfoutput></a>
			<br />
			
			<a href="index.cfm?action=security<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_edit_administrator_security')#</cfoutput></a>

			</td>

		  </tr>

		</table>	

	

	</td>

  </tr>
  
<!---<tr>
	<td colspan="2" style="margin-top:10px;">
	<div class="b_all">
	<div style="padding:6px;" class="lightbg">
	<b>Ihr Ansprechpartner bei Fragen &amp; Bestellungen</b>
	</div>
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td valign="top">
				<img src="/images/homepage/de/img_reseller.jpg" vspace="4" hspace="4">
			</td>
			<td valign="top">
			
			<cfquery name="q_select_resellerkey">
			SELECT
				resellerkey
			FROM
				companies
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
			;
			</cfquery>
			
			<cfquery name="q_select_reseller">
			SELECT
				companyname,street,zipcode,city,telephone,emailadr,customercontact
			FROM
				reseller
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_resellerkey.resellerkey#">
			;
			</cfquery>
			
			<br><br>
			<cfoutput query="q_select_reseller">
			#ReplaceNoCase(q_select_reseller.customercontact, chr(13), '<br>')#
			<br><br>
			E-Mail: <a href="mailto:#q_select_reseller.emailadr#">#q_select_reseller.emailadr#</a>
			
			<cfif request.q_select_reseller.telephone NEQ ''>
			<br>
			Tel: #q_select_reseller.telephone#
			</cfif>
			</cfoutput>

			</td>
		  </tr>
		</table>
	</div>
	</td>
</tr>--->
</cfif>

</table>

