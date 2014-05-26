<!--- //

	Module:		Project
	Description:Left include
	

// --->


<div class="divleftnavigation_center">

	<div  class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
	
	<div class="divleftnavpanelactions">	
			
		<ul class="divleftpanelactions">
			<li><a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a></li>
		</ul>
			
	</div>	
	
	<div  class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_new')#</cfoutput></div>
	
	<div class="divleftnavpanelactions">	
			
		<ul class="divleftpanelactions">
<!--- 			<li><a href="index.cfm?action=NewProject&type=0"><cfoutput>#GetLangVal('crm_ph_project_type_0')#</cfoutput></a></li> --->
			<li><a href="index.cfm?action=NewProject&type=1"><cfoutput>#GetLangVal('crm_ph_project_type_1')#</cfoutput></a></li>
		</ul>
			
	</div>	
	
</div>

