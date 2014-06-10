<!--- //

	Module:		CRM
	Description:Left side include
	

// --->

<div class="divleftnavigation_center">

	<div class="divleftnavpanelactions">
	
		<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
		
			

			<ul class="divleftpanelactions">
				<li><a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a></li>
				<li><a href="/addressbook/?filterdatatype=0"><cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput></a></li>
				<li><a href="/addressbook/?filterdatatype=1"><cfoutput>#GetLangVal('cm_wd_accounts')#</cfoutput></a></li>
				<!--- <li><a href="index.cfm?action=reports"><cfoutput>#GetLangVal('cm_wd_reports')#</cfoutput></a></li> --->
							
			</ul>
	
	</div>

</div>
