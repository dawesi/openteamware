<!--- //

	Module:		Admintool
	Description:Left side nav include

// --->

<div class="divleftnavigation_center">


	<cfif request.a_bol_is_reseller>

		<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('adm_ph_nav_customer_administration')#</cfoutput></div>

		<div class="divleftnavpanelactions">
			<ul class="divleftpanelactions">
				<li><a href="index.cfm?action=customers"><cfoutput>#GetLangVal('cm_wd_show')#</cfoutput></a></li>
				<li><a href="index.cfm?action=newcustomer"><cfoutput>#GetLangVal('adm_wd_nav_new')#</cfoutput> ...</a></li>
				<li><a href="index.cfm?action=newcustomer"><cfoutput>#GetLangVal('adm_wd_nav_search')#</cfoutput> ...</a></li>
				<li><a href="index.cfm?action=showinterestedparties"><cfoutput>#GetLangVal('adm_wd_nav_interested_parties')#</cfoutput> ...</a></li>
			</ul>
		</div>

		<!--- <div class="divleftnavpanelheader"><cfoutput>#GetLangVal('adm_ph_nav_marketing')#</cfoutput></div>
		<div class="divleftnavpanelactions">
			<ul class="divleftpanelactions">
				<li><a href="index.cfm?action=marketing"><cfoutput>#GetLangVal('adm_ph_nav_marketing_description')#</cfoutput></a></li>
			</ul>
		</div> --->
	</cfif>


	<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('adm_ph_nav_user_administration')#</cfoutput></div>
	<div class="divleftnavpanelactions">
			<ul class="divleftpanelactions">
				<li><a href="index.cfm?action=useradministration"><cfoutput>#GetLangVal('adm_ph_nav_user_administration_list')#</cfoutput></a></li>
				<li><a href="index.cfm?action=newuser"><cfoutput>#GetLangVal('adm_ph_nav_user_administration_new_user')#</cfoutput></a></li>
				<li><a href="index.cfm?action=workgroups"><cfoutput>#GetLangVal('adm_ph_nav_group_administration_groups')#</cfoutput></a></li>
				<!--- <li><a href="index.cfm?action=workgroups"><cfoutput>#GetLangVal('adm_ph_nav_group_administration_secretary')#</cfoutput></a></li> --->
			</ul>
	</div>

	<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('adm_wd_nav_shop')#</cfoutput></div>

	<div class="divleftnavpanelactions">
			<ul class="divleftpanelactions">
				<li><a href="index.cfm?action=shop"><cfoutput>#GetLangVal('adm_ph_nav_shop_buy_add_items')#</cfoutput></a></li>

				<!--- is this a customer that is allowed to access the shop? --->

				<li><a href="index.cfm?action=licence.status"><cfoutput>#GetLangVal('adm_ph_nav_shop_display_licence_status')#</cfoutput></a></li>
				<!--- <li><a href="index.cfm?action=promocodes"><cfoutput>#GetLangVal('adm_ph_nav_shop_promocodes')#</cfoutput></a></li>
				 ---><li><a href="index.cfm?action=invoices"><cfoutput>#GetLangVal('adm_ph_nav_billing')#</cfoutput></a></li>
				<li><a href="index.cfm?action=masterdata"><cfoutput>#GetLangVal('adm_ph_nav_account_data')#</cfoutput></a></li>

			</ul>
	</div>



	<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_adjust')#</cfoutput></div>

	<div class="divleftnavpanelactions">
			<ul class="divleftpanelactions">
				<li><a href="index.cfm?action=criteria"><cfoutput>#GetLangVal('crm_wd_criteria')#</cfoutput></a></li>
				<li><a href="index.cfm?action=companycategories"><cfoutput>#GetLangVal('adm_ph_global_categories')#</cfoutput></a></li>
				<li><a href="index.cfm?action=companynews"><cfoutput>#GetLangVal('adm_ph_nav_companynews')#</cfoutput></a></li>
				<li><a href="index.cfm?action=companylogo"><cfoutput>#GetLangVal('adm_ph_include_logo')#</cfoutput></a></li>
				<li><a href="index.cfm?action=resources"><cfoutput>#GetLangVal('cm_wd_resources')#</cfoutput></a></li>
				<li><a href="index.cfm?action=crm"><cfoutput>#GetLangVal('cm_wd_crm')#</cfoutput></a></li>
				<li><a href="index.cfm?action=forum"><cfoutput>#GetLangVal('forum_wd_foren')#</cfoutput></a></li>
				<li><a href="index.cfm?action=productadministration"><cfoutput>#GetLangVal('cm_wd_products')#</cfoutput></a></li>
			</ul>
	</div>

	<!--- <div class="divleftnavpanelheader"><cfoutput>#GetLangVal('adm_ph_nav_security')#</cfoutput></div>
	<div class="divleftnavpanelactions">
			<ul class="divleftpanelactions">
				<li><a href="index.cfm?action=security"><cfoutput>#GetLangVal('cm_wd_security')#</cfoutput></a></li>
			</ul>
	</div> --->

</div>

