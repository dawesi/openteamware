<!--- //

	Module:		CRM
	Description:Left side include
	

// --->

<div class="divleftnavigation_center">

	<div class="divleftnavpanelactions">
	
		<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
		
			

			<ul class="divleftpanelactions">
				<li><a href="default.cfm"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a></li>
				<li><a href="/addressbook/?filterdatatype=0"><cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput></a></li>
				<li><a href="/addressbook/?filterdatatype=1"><cfoutput>#GetLangVal('cm_wd_accounts')#</cfoutput></a></li>
				<li><a href="default.cfm?action=reports"><cfoutput>#GetLangVal('cm_wd_reports')#</cfoutput></a></li>
				<cfif request.stSecurityContext.iscompanyadmin>
				<li>
					<a href="/administration/"><cfoutput>#GetLangVal('crm_wd_product_admin')#</cfoutput></a>
				</li>	
				</cfif>
				<li>
					<a href="/crm/?action=productadmin">Bestandsverwaltung</a>
				</li>	
				<li><a href="/crm/?action=activities"><cfoutput>#GetLangVal('crm_wd_follow_ups')#</cfoutput></a></li>
				<li><a href="/calendar/"><cfoutput>#GetLangVal('cm_wd_calendar')#</cfoutput></a></li>
							
			</ul>
	
	</div>

</div>
