<!--- //

	Module:		Storage
	Description:Overview 
	

// --->


<!--- 
	empty
	newfiles or
	lockedobjects
--->
<cfparam name="url.view" type="string" default="">


<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_storage')) />


<!--- tabs --->

<cfset tmp = StartNewTabNavigation() />
<cfset tmp = AddTabNavigationItem(GetLangVal('cm_wd_overview'), 'default.cfm', '') />

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<div class="b_all">
	
	<table border="0" cellpadding="6" cellspacing="0">
		<tr>
			<td class="br" valign="top">
			
					<b><img src="/images/si/eye.png" class="si_img" /> <cfoutput>#GetLangVal('adrb_wd_view')#</cfoutput></b>
					
					<table cellpadding="4" cellspacing="0" border="0">
						<tr>
							<td>
								<a  href="default.cfm?&ordertype=DESC&orderby=name"><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></a>
							</td>
							<td>
								<a <cfif url.view IS 'created'>style="font-weight:bold;"</cfif> href="default.cfm?Action=ShowWelcome&view=created"><cfoutput>#GetLangVal('cm_ph_last_added')#</cfoutput></a>
							</td>
						</tr>
						<tr>
							<td>
								<a <cfif url.view IS 'lastmodified'>style="font-weight:bold;"</cfif> href="default.cfm?Action=ShowWelcome&view=lastmodified"><cfoutput>#GetLangVal('cm_ph_last_edited')#</cfoutput></a>
							</td>
							<td>
								<a <cfif url.view IS 'locked'>style="font-weight:bold;"</cfif>  href="default.cfm?&view=locked"><cfoutput>#GetLangVal('cm_wd_locked_objects')#</cfoutput></a>
							</td>
						</tr>

					</table>
					
			</td>
			<td class="br" valign="top">
				
				 	<b><img src="/images/si/find.png" class="si_img" />Suchen</b>
				 	
				 	<form id="idformtopsearch" name="idformtopsearch" method="get" onSubmit="ShowLoadingStatus();" action="default.cfm" style="margin:0px;">
					<input type="hidden" name="action" value="search" />

					
					<table cellpadding="4" cellspacing="0" border="0">
						<tr>
							<td>
								<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frm_searchstring" value="" size="10" />

							</td>
							<!--- <td>
								<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmdescription" value="" size="10" />
							</td> --->
						</tr>

						<tr>
							
							<td>

							</td>
							<td>
								<input type="submit" value="Suchen" class="btn2" />
							</td>
						</tr>
						
					</table>
					</form>
						
				
			</td>	
		</tr>
		
	</table>
</div>

<!--- what to display? new, default or locked objects? ... --->

<cfswitch expression="#url.view#">
	<cfcase value="created">
		
		<cfset tmp = AddJSToExecuteAfterPageLoad('DisplayRecentFiles(''created'')', '') />
		
		<div id="id_div_recent_files">
			<cfoutput>#request.a_str_img_tag_status_loading#</cfoutput>
		</div>
		
	</cfcase>
	<cfcase value="lastmodified">
		<cfset tmp = AddJSToExecuteAfterPageLoad('DisplayRecentFiles(''lastmodified'')', '') />
		
		<div id="id_div_recent_files">
			<cfoutput>#request.a_str_img_tag_status_loading#</cfoutput>
		</div>
	</cfcase>
	<cfcase value="locked">
		<cfset tmp = AddJSToExecuteAfterPageLoad('DisplayRecentFiles(''locked'')', '') />
		
		<div id="id_div_recent_files">
			<cfoutput>#request.a_str_img_tag_status_loading#</cfoutput>
		</div>
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="dsp_showfiles.cfm">
	</cfdefaultcase>
</cfswitch>



<!---
<cfelse>
	<cfinclude template="dsp_showfiles.cfm">
</cfif>
--->




