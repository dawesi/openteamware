<!--- //

	Module:		Display/edit newsletter subscribers
	Action:		
	Description:	
	

// --->


<cfset tmp = SetHeaderTopInfoString( GetLangVal('nl_wd_subscribers') ) />
	
<cfparam name="url.listkey" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>

<cfset q_select_profile = a_cmp_nl.GetNewsletterProfile(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, entrykey = url.listkey)>

<cfswitch expression="#q_select_profile.listtype#">
	<cfcase value="0">
	Dieses Newsletter-Profil basiert auf einem CRM Filter. Die Abonnenten werden daher dynamisch ermittelt!
	</cfcase>
	<cfcase value="1">1</cfcase>
	<cfcase value="2">
	Die Abonnenten werden fix aus dem Adressbuch ausgewaehlt.
	</cfcase>
</cfswitch>
<br /><br />

<cfset q_select_subscribers = a_cmp_nl.GetSubscribers(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, listkey = url.listkey)>

<cfsavecontent variable="a_str_content">

<cfif q_select_profile.listtype IS 1>
	<table class="table table-hover">
	  <tr class="tbl_overview_header">
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <cfoutput query="q_select_subscribers">
	  <tr>
		<td>
			#q_select_subscribers.emailadr#
		</td>
		<td>&nbsp;</td>
	  </tr>
	  </cfoutput>
	</table>
</cfif>

<cfif ListFindNoCase('0,2', q_select_profile.listtype) GT 0>
	<table class="table table-hover">
	  <tr class="tbl_overview_header">
		<td><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_email')#</cfoutput></td>
		<cfif q_select_profile.listtype IS 2>
			<td>Hinzugef&uuml;gt</td>
		</cfif>
		<td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
	  </tr>
	  <cfoutput query="q_select_subscribers">
	  <tr>
	  	<td>
			<a href="../addressbook/?action=ShowItem&entrykey=#q_select_subscribers.entrykey#">#si_img('vcard')# #htmleditformat(q_select_subscribers.surname)#, #htmleditformat(q_select_subscribers.firstname)#</a>
		</td>
		<td>
			#htmleditformat(q_select_subscribers.email_prim)#
		</td>
		<cfif q_select_profile.listtype IS 2>
			<td>
				#DateFormat(q_select_subscribers.dt_created_nl_subscription, 'dd.mm.yy')#
			</td>
		</cfif>
		<td align="center">
			<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_delete_subscriber.cfm?listkey=#url.listkey#&listtype=2&contactkey=#q_select_subscribers.entrykey#">#si_img('delete')#</a>
		</td>
	  </tr>
	  </cfoutput>
	</table>
</cfif>

</cfsavecontent>

<cfoutput>#WriteNewContentBox( GetLangVal('nl_wd_subscribers') , '' , a_str_content)#</cfoutput>


<br />

<!--- // display ignore items ... // --->
<cfset q_select_ignore_list = a_cmp_nl.LoadIgnoreList(listkey = url.listkey)>

<cfif q_select_ignore_list.recordcount GT 0>

	<cfsavecontent variable="a_str_content">
		
		<cfif ListFindNoCase('0,2', q_select_profile.listtype) GT 0>
		
		<cfset a_struct_filter = StructNew()>
		<cfset a_struct_filter.entrykeys = ValueList(q_select_ignore_list.contactkey)>
	
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="filter" value="#a_struct_filter#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>
		
		
		
		<cfset q_select_ignore_contacts = stReturn.q_select_contacts>
	
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
			<cfoutput query="q_select_ignore_contacts">
			  <tr>
				<td>
					<a href="/addressbook/?action=ShowItem&entrykey=#q_select_ignore_contacts.entrykey#">#htmleditformat(q_select_ignore_contacts.surname)#, #htmleditformat(q_select_ignore_contacts.firstname)#</a>
				</td>
				<td>
					#htmleditformat(q_select_ignore_contacts.email_prim)#
				</td>
				<td>
					<cfquery name="q_select_unsubscribe_data" dbtype="query">
					SELECT dt_created,contactkey FROM q_select_ignore_list WHERE contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_ignore_contacts.entrykey#">;
					</cfquery>

					#DateFormat(q_select_unsubscribe_data.dt_created, 'dd.mm.yy')#
				</td>
				<td>
					<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_remote_from_ignore_list.cfm?listkey=#url.listkey#&contactkey=#q_select_unsubscribe_data.contactkey#"><img src="/images/del.gif" border="0" align="absmiddle"></a>
				</td>
			  </tr>
			</cfoutput>
		</table>
		
		</cfif>
	
	</cfsavecontent>

	<cfoutput>#WriteNewContentBox( 'Kontakte, die ignoriert werden sollen (kein Abo/Abbestellt)' , '' , a_str_content)#</cfoutput>

</cfif>

