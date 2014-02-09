

<div class="divleftnavigation_center">
	

	<div class="divleftnavpanelactions">
			
			<div class="divleftnavpanelheader"><cfoutput>#GetLangVal("cm_wd_global")#</cfoutput></div>
	
			<ul class="divleftpanelactions">
			<li>
				<a style="font-weight:bold; " href="default.cfm?action=PersonalData"><cfoutput>#GetLangVal("prf_wd_personal")#</cfoutput></a>
				
				<div>
				<cfoutput>#GetLangVal("prf_ph_personal_description")#</cfoutput>
				</div>
			</li>
			<!--- <li>
				<a style="font-weight:bold; " href="default.cfm?action=emailaccounts"><cfoutput>#GetLangVal("prf_ph_email_addresses")#</cfoutput></a>
				<div>
				<cfoutput>#GetLangVal("prf_ph_email_addresses_description1")#</cfoutput>
				<br>
				<cfoutput>#GetLangVal("prf_ph_email_addresses_description2")#</cfoutput>
				</div>
			</li> --->
			<li>
				<a style="font-weight:bold; " href="default.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal("prf_ph_display_and_security")#</cfoutput></a>
				<div>
				<cfoutput>#GetLangval("prf_ph_display_description")#</cfoutput>
				</div>
			</li>
			<!--- <li>
				<a style="font-weight:bold; " href="default.cfm?action=Wireless">Mobile/SMS</a>
				<div>
				<cfoutput>#GetLangval("prf_ph_wireless_description")#</cfoutput>
				</div>
			</li> --->
			</ul>
		
	
	</div>
	

</div>