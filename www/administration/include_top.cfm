<!--- //

	Module:		Admintool
	Description:Top navigation
	
// --->

<cfset a_struct_medium_logo = application.components.cmp_customize.GetCustomStyleData(usersettings = session.stUserSettings, entryname = 'medium_logo') />
<div id="iddivmenutop">
	<div class="mischeader" style="padding:0px; ">
		
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="200" class="br" style="text-align:center;background-color:white; ">
				<a href="index.cfm"><img vspace="4" src="<cfoutput>#a_struct_medium_logo.path#</cfoutput>" height="<cfoutput>#a_struct_medium_logo.height#</cfoutput>" width="<cfoutput>#a_struct_medium_logo.width#</cfoutput>" hspace="3" align="absmiddle" border="0"></a>
			</td>
			<td style="font-weight:bold;font-size:15px;padding-left:10px;">
				<cfoutput>#GetLangVal('adm_ph_title_main')#</cfoutput>	
			</td>
			<td align="right">


				<table border="0" cellspacing="0" cellpadding="4">
				  <tr>
					<td align="center">
						<img src="/images/si/user.png" class="si_img" /> <cfoutput><b>#q_select_user_info.firstname# #q_select_user_info.surname#</b> &lt;#request.stSecurityContext.myusername#&gt;</cfoutput>
					</td>
				  </tr>
				  <tr>
					<td align="center">
						<a class="a_topframe_dark" href="logout.cfm" target="_top"><img src="/images/si/stop.png" class="si_img" /> <cfoutput>#GetLangVal('adm_ph_logout')#</cfoutput></a>
					</td>
				  </tr>
				</table>


			</td>
		  </tr>
		</table>
	
		 
	</div>
</div>

<cfset a_bol_printversion = StructKeyExists(url, 'printversion') AND url.printversion>
<cfif NOT a_bol_printversion>

<div id="iddivtopheaderservice" class="bb div_main_content_top_menu">
<table class="tablemaincontenttop">
<tr>
	<td><a href="index.cfm" class="TopHeaderLink">
		<cfoutput>#GetLangVal('adm_ph_nav_top_overview')#</cfoutput></a>&nbsp;
	</td>
	<td class="tdtopheaderdivider">|</td>
	<td class="TopHeaderLink">
		<a class="TopHeaderLink" href="/administration/index.cfm?action=shop"><cfoutput>#GetLangVal('cm_wd_shop')#</cfoutput></a>
	</td>
	
	<cfif request.a_bol_is_reseller>
		<td class="tdtopheaderdivider">|</td>
		<td class="TopHeaderLink">
			<a class="TopHeaderLink" style="font-weight:bold; " href="/administration/index.cfm?action=customers"><cfoutput>#GetLangVal('adm_ph_nav_customer_administration')#</cfoutput></a>
		</td>	
		<td class="tdtopheaderdivider">|</td>
		<td class="TopHeaderLink">
			<a class="TopHeaderLink" style="font-weight:bold; " href="/administration/index.cfm?action=reseller"><cfoutput>#GetLangVal('adm_wd_partner')#</cfoutput></a>
		</td>
		<td class="tdtopheaderdivider">|</td>
		<td class="TopHeaderLink">
			<a class="TopHeaderLink" href="/administration/index.cfm?action=stat"><cfoutput>#GetLangVal('adm_wd_reporting')#</cfoutput></a>
		</td>		
	</cfif>
	
	<td class="tdtopheaderdivider">|</td>
	<td class="TopHeaderLink">
		<a class="TopHeaderLink" href="/" target="_blank"><cfoutput>#GetLangVal('adm_ph_user_interface')#</cfoutput></a>
	</td>		
	<!---<td class="tdtopheaderdivider">|</td>
	<td class="TopHeaderLink">
		<a href="index.cfm?action=routeplanner" class="TopHeaderLink">Routenplaner</a>
	</td>	
	<td class="tdtopheaderdivider">|</td>
--->	
</tr>
</table> 
</div>

  </cfif>

  
<cfif request.a_bol_is_reseller AND StructKeyExists(url, 'action') AND url.action IS 'ShowWelcome'>

		<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
			<cfinvokeargument name="section" value="admintool">
			<cfinvokeargument name="langno" value="#client.langno#">
			<cfinvokeargument name="template_name" value="admin_tool_welcome_for_partners">
		</cfinvoke>
		
		<cftry>
		
		<cfinclude template="#a_str_page_include#">
		
		<cfcatch type="any"></cfcatch></cftry>

</cfif>

