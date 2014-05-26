<!--- //

	Module:		Forum
	Description:Left include
	

// --->


<cfparam name="url.forumkey" type="string" default="">

<cfinvoke component="#application.components.cmp_forum#" method="GetForumList" returnvariable="q_select_foren">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<div class="divleftnavigation_center">

	<div  class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
	
	<div class="divleftnavpanelactions">
						
			
			<ul class="divleftpanelactions">
				<li><a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a></li>
			</ul>
			
	</div>	
	
	<div  class="divleftnavpanelheader"><cfoutput>#GetLangVal('forum_wd_foren')#</cfoutput></div>
	
	<div class="divleftnavpanelactions">
	
		<ul class="divleftpanelactions">
			<cfoutput query="q_select_foren">
				<li>
					<a href="index.cfm?action=ShowForum&entrykey=#q_select_foren.entrykey#">#htmleditformat(q_select_foren.forumname)#</a>
					
					<cfif Len(q_select_foren.description) GT 0>
						<div>
						#htmleditformat(q_select_foren.description)#
						</div>
					</cfif>
				</li>
			</cfoutput>
		</ul>
	</div>
	
</div>


