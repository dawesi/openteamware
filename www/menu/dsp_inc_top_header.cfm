<!--- //

	Module:		Top header for services outside of login-protected area
	Description: 
	

// --->
	
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="request.stUserSettings.style" type="string" default="#request.appsettings.default_stylesheet#">

<cfset a_struct_medium_logo = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'medium_logo') />


<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
  	<td>
		<a href="/" target="_top"><img width="<cfoutput>#a_struct_medium_logo.width#</cfoutput>" height="<cfoutput>#a_struct_medium_logo.height#</cfoutput>" vspace="4" src="<cfoutput>#a_struct_medium_logo.path#</cfoutput>" hspace="3" border="0"></a>		
		
	</td>
	<td align="right">
	
		 	<table border="0" cellpadding="4" cellspacing="0" >
		    	<tr>
				<td>
					<a target="_top" href="/"><img src="/images/si/star.png" class="si_img" /> <cfoutput>#htmleditformat(GetLangVal('start_wd_home'))#</cfoutput></a>
				</td>
				<td>
					<a href="/"><img src="/images/si/information.png" class="si_img" /> <cfoutput>#GetLangVal('cm_wd_about')#</cfoutput> <cfoutput>#request.appsettings.description#</cfoutput></a>
				</td>		
				<td>
					<a  href="/rd/signup/" target="_blank"><img src="/images/si/exclamation.png" class="si_img" /> <cfoutput>#GetLangVal('hpg_ph_free_test_drive_now')#</cfoutput></a>
				</td>		
				</tr>
		   </table>
	
	</td>
	<cfif NOT StructKeyExists(request, 'stSecurityContext')>
    <td align="right" style="padding-right:20px;" valign="middle">	
		<a href="/rd/signup/?source=topmenu_header" style="font-weight:bold;"><cfoutput>#GetLangVal('hpg_ph_free_test_drive_now')#</cfoutput></a>
	</td>
	</cfif>
  </tr>
</table>


