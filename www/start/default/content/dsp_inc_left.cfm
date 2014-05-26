<!--- //

	Component:	Start page content
	Description:Display left column
	
	Header:		

// --->

<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<div class="divleftnavigation_center">


	<div class="divleftnavpanelactions">
	
		
		<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('start_wd_welcome')#</cfoutput>!</div>
		
		
		
		<ul class="divleftpanelactions">
			
			<cfif q_select_user_data.smallphotoavaliable>
			<li>
				<img src="/tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#request.stSecurityContext.myuserkey#</cfoutput>" />
			</li>
			</cfif>
		</ul>
	
	</div>	
	
		
	
</div>

