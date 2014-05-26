<!--- //

	Component:	Render
	Function:	GenerateMainMenuBar
	Description:
	
// --->

<cfset a_bol_force_header = StructKeyExists(url, 'includeheader') AND (url.includeheader IS 1)>

<cfif (
		(ListFindNoCase('action,inpage', request.a_struct_current_service_action.type) GT 0)
		OR
		(ListFindNoCase(request.a_struct_current_service_action.attributes,'noheader') GT 0)
	  )
	  AND NOT
	  	a_bol_force_header>
	<cfexit method="exittemplate">
</cfif>



<!--- display top menu ... --->
<!--- TODO: translate and fix links ... --->
<cfscript>
	StartNewJSPopupMenu('a_menu_new_items');
	AddNewJSPopupMenuItem(GetLangval('cm_wd_email'), 'javascript:OpenComposePopupTo();');
	AddNewJSPopupMenuItem(GetLangval('cm_wd_contact'), '/addressbook/?action=CreateNewItem&datatype=0');
	AddNewJSPopupMenuItem(GetLangval('cm_wd_account'), '/addressbook/?action=CreateNewItem&datatype=1');
	AddNewJSPopupMenuItem(GetLangval('cm_wd_appointment'), '/calendar/default.cfm?action=ShowNewEvent');
	AddNewJSPopupMenuItem(GetLangval('cm_wd_file'), '/storage/?action=UploadNewFile');
	AddNewJSPopupMenuItem(GetLangval('cm_wd_task'), '/tasks/default.cfm?action=newtask');
	AddNewJSPopupMenuToPage();
</cfscript>

<div id="id_header_menu_user">
	<span id="id_activites_new_msg_indicator" style="display:none"></span>
	
	<a href="/"><cfoutput>#htmleditformat(request.stSecurityContext.myusername)#</cfoutput></a>
	&#160;|&#160;
					
					<cfif request.stSecurityContext.ISUSERSWITCHENABLED>
						<a  href="javascript:LoadUserSwitchData();">Single Sign On</a>
	&#160;|&#160;
					</cfif>
					
					<a href="/settings/"><cfoutput>#GetLangVal('cm_wd_preferences')#</cfoutput></a>
					&#160;|&#160;
					<a target="_top" onclick="ShowLogoutDialog();return false;" href="/logout.cfm"><cfoutput>#GetLangVal('cm_wd_logout')#</cfoutput></a>

					
</div>

<!--- status box --->
<div style="display:none;" id="id_top_status_information">&#160;</div>



<div class="header_menu" id="id_header_menu">
<ul>
	<li>
		<a href="/start/default/"><cfoutput>#GetLangVal('cm_wd_home')#</cfoutput></a>
	</li>
	<li>
		 <a href="/" id="idnewtest" onmouseover="ShowHTMLActionPopup('idnewtest', a_menu_new_items, false);" onclick="ShowHTMLActionPopup('idnewtest', a_menu_new_items, false);return false;"><cfoutput>#GetLangVal('cm_wd_new')#</cfoutput> &raquo;</a>
	</li>

    <li>
    	<a href="/crm/?action=activities"><cfoutput>#GetLangVal('adrb_wd_activities')#</cfoutput></a>
    </li>
   	<li>
    	<a href="/addressbook/default.cfm?filterdatatype=0"><cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput></a>
    </li>
    <li>
     	<a href="/addressbook/default.cfm?filterdatatype=1"><cfoutput>#GetLangVal('crm_wd_accounts')#</cfoutput></a>
     </li>		
     <!--- <li>
         <a href="/calendar/" id="id_men_cal" onmouseover="ShowHTMLActionPopup('id_men_cal', a_men_cal, false);" onclick="ShowHTMLActionPopup('id_men_cal', a_men_cal, false);"><cfoutput>#GetLangVal('cm_wd_calendar')#</cfoutput> &raquo;</a>
     </li> --->
	<li>
		<a href="/project"><cfoutput>#GetLangval('cm_wd_projects')#</cfoutput></a>
	</li>
    <!---<li>
		<a href="/email/" id="id_men_mail" onmouseover="ShowHTMLActionPopup('id_men_mail', a_men_email, false);" onclick="ShowHTMLActionPopup('id_men_mail', a_men_email, false);"><cfoutput>#GetLangVal('cm_wd_email')# &raquo;</cfoutput></a>
   	</li>--->
	<li>
        <a href="/mailing/"><cfoutput>#GetLangVal('cm_wd_mailings')#</cfoutput></a>
    </li>
	<!--- <li>
         <a href="/extras/" id="id_men_ex" onmouseover="ShowHTMLActionPopup('id_men_ex', a_men_ex, false);" onclick="ShowHTMLActionPopup('id_men_ex', a_men_ex, false);"><cfoutput>#GetLangVal('cm_wd_extras')#</cfoutput> &raquo;</a>
     </li>	 --->
</ul>

</div>

<div style="clear:both"></div>

<!--- 		
 --->

<div class="div_top_header_info" id="id_top_header_navigation">
openTeamware.com &gt;
<span id="id_span_header_top_info"></span>	
<span><a href="#" class="nl"><img src="/images/space_1_1.gif" class="si_img" /></a></span>
</div>

<div style="clear:both"></div>

