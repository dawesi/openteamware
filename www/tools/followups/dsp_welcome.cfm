<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.userkey = request.stSecurityContext.myuserkey>
<cfset a_struct_filter.done = 0>

<cfset a_cmp_fup = CreateObject('component', request.a_str_component_followups)>

<cfinvoke component="#a_cmp_fup#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cf_disp_navigation mytextleft="#GetLangVal('crm_wd_follow_ups')#">
<br>

<cfsavecontent variable="a_str_content">

	<div style="padding:8px; ">
		<cfoutput>#GetLangVal('crm_ph_followups_explanation')#</cfoutput>
	</div>
	
		<table class="table_overview">
		  <tr class="tbl_overview_header">
			<td><cfoutput>#GetLangVal('cm_wd_title')#</cfoutput></td>
			<td><cfoutput>#GetLangVal('cm_wd_type')#</cfoutput></td>
			<td><cfoutput>#GetLangVal('cm_wd_date')#</cfoutput></td>
			<td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
		  </tr>
		  <cfoutput query="q_select_follow_ups">
		  <tr>
			<td>
				#application.components.cmp_tools.GenerateLinkToItem(usersettings = request.stUserSettings, servicekey = q_select_follow_ups.servicekey, title = q_select_follow_ups.objecttitle, objectkey = q_select_follow_ups.objectkey)#
				
				<cfif Len(q_select_follow_ups.comment) GT 0>
					<br>
					#htmleditformat(q_select_follow_ups.comment)#
				</cfif>
			</td>
			<td>
					<cfswitch expression="#q_select_follow_ups.followuptype#">
						<cfcase value="0">#GetLangVal('crm_wd_follow_up')#</cfcase>
						<cfcase value="1">#GetLangVal('cm_wd_email')#</cfcase>
						
						<cfcase value="2">#GetLangVal('crm_wd_follow_up_call')#</cfcase>
						<cfcase value="3">#GetLangVal('crm_wd_follow_up_write_letter')#</cfcase>
					</cfswitch>
			</td>
			<td>
				#LSDateFormat(q_select_follow_ups.dt_due, request.stUserSettings.default_dateformat)#
			</td>
			<td class="addinfotext">
				<a href="index.cfm?action=editjob&entrykey=#q_select_follow_ups.entrykey#"><img src="/images/editicon.gif" align="absmiddle" vspace="3" hspace="4" border="0"> #GetLangVal('cm_wd_edit')#</a> | 
				<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_delete_follow_up.cfm?entrykey=#q_select_follow_ups.entrykey#"><img src="/images/email/img_trash_19x16.gif" align="absmiddle" border="0">#GetLangVal('cm_wd_delete')#</a>
			</td>
		  </tr>
		  </cfoutput>
		</table>
</cfsavecontent>


<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_follow_ups'), '', a_str_content)#</cfoutput>

<br>
<cfsavecontent variable="a_str_content">

	

	<cfset a_struct_filter = StructNew()>
	<cfset a_struct_filter.createdbyuserkey = request.stSecurityContext.myuserkey>
	<cfset a_struct_filter.not_userkey= request.stSecurityContext.myuserkey>
	<cfset a_struct_filter.done = 0>
	
	<cfinvoke component="#request.a_str_component_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
		<cfinvokeargument name="servicekey" value="">
		<cfinvokeargument name="objectkeys" value="">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">
	</cfinvoke>
	
	<cfset variables.a_cmp_show_username = CreateObject('component', request.a_str_component_users)>
	
	<table class="table_overview">
	<tr class="tbl_overview_header">
		<td><cfoutput>#GetLangVal('cm_wd_title')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_ph_created_for')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_type')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_date')#</cfoutput></td>
	  </tr>
	  <cfoutput query="q_select_follow_ups">
	  <tr>
	
		<td>
				#a_cmp_fup.GenerateFollowupLink(servicekey = q_select_follow_ups.servicekey, title = q_select_follow_ups.objecttitle, objectkey = q_select_follow_ups.objectkey)#
				
				<cfif Len(q_select_follow_ups.comment) GT 0>
					<br>
					#htmleditformat(q_select_follow_ups.comment)#
				</cfif>
		</td>
		<td>
			#variables.a_cmp_show_username.GetUsernamebyentrykey(q_select_follow_ups.userkey)#
		</td>	
		<td>
				<cfswitch expression="#q_select_follow_ups.followuptype#">
					<cfcase value="0">#GetLangVal('crm_wd_follow_up')#</cfcase>
					<cfcase value="1">#GetLangVal('cm_wd_email')#</cfcase>
					
					<cfcase value="2">#GetLangVal('crm_wd_follow_up_call')#</cfcase>
					<cfcase value="3">#GetLangVal('crm_wd_follow_up_write_letter')#</cfcase>
				</cfswitch>
		</td>
		<td>
			#LSDateFormat(q_select_follow_ups.dt_due, request.stUserSettings.default_dateformat)#
		</td>
	  </tr>
	  </cfoutput>
	</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_followups_createdbyyouforothers'), '', a_str_content)#</cfoutput>
