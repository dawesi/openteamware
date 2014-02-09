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
	
	
			<ul class="divleftpanelactions">
			<li><a href="/email/?action=showmailbox&mailbox=INBOX"><cfoutput>#GetLangVal('cm_wd_inbox')#</cfoutput></a></li>
			<li><a href="javascript:OpenComposePopup();"><cfoutput>#GetLangVal('mail_ph_compose_new_mail')#</cfoutput></a></li>
			<li><a href="/addressbook/"><cfoutput>#GetLangVal('cm_wd_crm')#</cfoutput>/<cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput></a></li>
			<li><a href="/workgroups/"><cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput></a></li>

			</ul> --->
	</div>	
	
		
	
</div>

