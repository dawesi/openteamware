<!--- //

	Module:		Address Book
	Description:Left side include
	
// --->

<cfparam name="url.filterviewkey" type="string" default="">
<cfparam name="url.filterdatatype" type="numeric" default="0">

<cfswitch expression="#url.filterdatatype#">
	<cfcase value="1">
		<cfset a_str_title_left = GetLangVal('cm_wd_accounts') />
	</cfcase>
	<cfcase value="2">
		<cfset a_str_title_left = GetLangVal('crm_wd_leads') />
	</cfcase>
	<cfdefaultcase>
		<cfset a_str_title_left = GetLangVal('cm_wd_contacts') />
	</cfdefaultcase>
</cfswitch>

<div class="divleftnavigation_center">
	
	<cfswitch expression="#url.action#">
	<cfcase value="ShowItem">
		
	<cfif StructKeyExists(session, 'adrb_display_list_entrykeys') AND ListLen(session.adrb_display_list_entrykeys) GT 1>
		<div class="divleftnavpanelactions">
		
		<div class="divleftnavpanelheader"><cfoutput>#a_str_title_left#</cfoutput></div>
		
			<ul class="divleftpanelactions" >
			
					<cfset a_int_list_index = ListFind(session.adrb_display_list_entrykeys, url.entrykey) />
				
					<!--- next or previous --->
					<cfif a_int_list_index GT 1>
						<li><a href="index.cfm?action=ShowItem&entrykey=<cfoutput>#ListGetat(session.adrb_display_list_entrykeys, (a_int_list_index - 1))#</cfoutput>"><cfoutput>#MakeFirstCharUCase(GetLangVal('adrb_ph_previous_contact'))#</cfoutput></a></li>
					</cfif>
					
					<cfif ListLen(session.adrb_display_list_entrykeys) GT a_int_list_index>
						<li>
						<a href="index.cfm?action=ShowItem&entrykey=<cfoutput>#ListGetat(session.adrb_display_list_entrykeys, (a_int_list_index + 1))#</cfoutput>"><cfoutput>#MakeFirstCharUCase(GetLangVal('adrb_ph_next_contact'))#</cfoutput></a>
						</li>
					</cfif>
			</ul>
		</div>	
		
	</cfif>
	</cfcase>
	</cfswitch>
		
	<div class="divleftnavpanelactions">
	
		<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
		
			<ul class="divleftpanelactions">
			<li>
				<a href="index.cfm"><cfoutput>#htmleditformat(GetLangval('cm_wd_overview'))#</cfoutput></a>
			</li>
			<li>
				<a href="index.cfm?Action=createnewitem&datatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_new_item')#</cfoutput></a>
			</li>
			
			<!--- <cfif url.filterdatatype IS 0>
			<li>
				<a href="index.cfm?action=OwnContactCard"><cfoutput>#GetLangVal('adrb_ph_own_contactcard')#</cfoutput></a>
			</li>		
			</cfif> --->
			

			<cfif StructKeyExists(url, 'search')>
				<cfset a_str_url_search = url.search>
			<cfelse>
				<cfset a_str_url_search = ''>
			</cfif>
			

				<li>
					<a href="index.cfm?action=advancedsearch&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('adrb_ph_advanced_search')#</cfoutput></a>
				</li>
				
				<!--- list stored search views ... --->
				<!--- <cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_filters">
					<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
					<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
				</cfinvoke>		
					
				<cfif q_select_filters.recordcount GT 0>
				<li>
					<div>
					<cfoutput>#GetLangVal('crm_ph_saved_filters')#</cfoutput>
					</div>
					
						<cfoutput query="q_select_filters">
							
							<a <cfif CompareNoCase(q_select_filters.entrykey, url.filterviewkey) IS 0>style="font-weight:bold;"</cfif> title="#htmleditformat(q_select_filters.viewname)#" href="index.cfm?action=ShowContacts&filterviewkey=#q_select_filters.entrykey#">&gt; #htmleditformat(ShortenString(q_select_filters.viewname, 12))#</a>
							
						</cfoutput>
				</li>
				</cfif>	 --->
				<!--- <li>
					<a href="index.cfm?action=advancedsearch"><cfoutput>#GetLangVal('crm_ph_new_filter')#</cfoutput></a>
				</li> --->

			<li>
				<a href="#" onclick="$('#id_li_names_az').fadeIn();"><cfoutput>#GetLangVal('adrb_ph_name_starts_with')#</cfoutput>
			</li>
			<li class="li_a_small" id="id_li_names_az" style="display:none;">
				<cfoutput><cfloop from="65" to="90" index="ii"><a href="index.cfm?Action=ViewAll&startchar=#chr(ii)#&filterviewkey=#url.filterviewkey#">#chr(ii)#</a> </cfloop></cfoutput>
			</li>
			<li>
				<div>
					<cfoutput>#GetLangVal('cm_wd_view')#</cfoutput>
				</div>
				<a href="index.cfm?viewmode=list">- <cfoutput>#GetLangVal('adrb_wd_viewmode_list')#</cfoutput></a>
				<br />
				<a href="index.cfm?viewmode=box">- <cfoutput>#GetLangVal('adrb_wd_viewmode_boxes')#</cfoutput></a>
				</li>
			<!--- <li>
				<a href="/synccenter/"><cfoutput>#GetLangVal('adrb_ph_outlook_sync')#</cfoutput></a>
			</li> --->
			<cfif url.filterdatatype IS 0>
<!--- 
			<li>
				<a href="index.cfm?action=remoteedit"><cfoutput>#GetLangVal('adrb_wd_remote_edit')#</cfoutput></a>
			</li>
 --->
			<li>
				<a href="index.cfm?action=telephonelist"><cfoutput>#GetLangVal('adb_wd_telephonelist')#</cfoutput></a>
			</li>			
			<li>
				<a href="index.cfm?action=birthdaylist"><cfoutput>#GetLangVal('adrb_wd_birthdaylist')#</cfoutput></a>
			</li>
			</cfif>
			</ul>
	</div>	

</div>