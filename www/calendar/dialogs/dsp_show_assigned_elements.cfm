<!--- //

	Module:		Calendar
	Action:		Create/Edit event
	Description:Display all assigned contacts, meeting members,
				resources in one place.
	

// --->

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_calendar#" method="GetMeetingMembers" returnvariable="q_select_meeting_members">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
    <cfinvokeargument name="temporary" value="true">
</cfinvoke>

<cfif q_select_meeting_members.recordcount IS 0>
	<div style="padding:10px;">
	<img src="/images/si/information.png" class="si_img" /> <cfoutput>#GetLangVal('cal_ph_no_participants_yet_defined')#</cfoutput>
	</div>
	<cfexit method="exittemplate">
</cfif>

<!--- select the assigned contacts ... type = 1 --->
<cfquery name="q_select_participating_assigned_contacts" dbtype="query">
SELECT
	parameter
FROM
	q_select_meeting_members
WHERE
	type = 1
;
</cfquery>	

<cfif q_select_participating_assigned_contacts.recordcount GT 0>
	
	<cfset a_struct_filter_load_contacts = StructNew() />
	<cfset a_struct_filter_load_contacts.entrykeys = ValueList(q_select_participating_assigned_contacts.parameter) />
	<cfset a_struct_loadoptions = StructNew() />
	<cfset a_struct_loadoptions.fieldstoselect = 'b_street,b_zipcode,b_city,b_country,firstname,surname,email_prim,entrykey,company' />
	
	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter_load_contacts#">
		<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	</cfinvoke>
	
	<cfset q_select_contacts = stReturn_contacts.q_select_contacts />
	
</cfif>



<!--- select the assigned resources ... type = 4 --->
<cfquery name="q_select_participating_assigned_resources" dbtype="query">
SELECT
	parameter
FROM
	q_select_meeting_members
WHERE
	type = 4
;
</cfquery>

<cfif q_select_participating_assigned_resources.recordcount GT 0>
	
	<cfinvoke component="#application.components.cmp_resources#" method="GetResourcesByEntrykeys" returnvariable="q_select_resources">
		<cfinvokeargument name="entrykeys" value="#ValueList(q_select_participating_assigned_resources.parameter)#">
	</cfinvoke>
	
</cfif>



<table class="table_overview">
	<tr class="tbl_overview_header">
	<cfoutput>
		<td>
			#GetLangVal('cm_wd_type')#
		</td>
		<td>
			#GetLangVal('cm_wd_name')#
		</td>
		<td align="center">
			#GetLangVal('cal_ph_send_invitation')#
		</td>
		<td>
			#GetLangVal('cm_wd_action')#
		</td>
	</cfoutput>
	</tr>
<cfoutput query="q_select_meeting_members">
	<!--- loop assigned members --->
	<tr>
		<td>
			<cfswitch expression="#q_select_meeting_members.type#">
				<cfcase value="0">
					<img src="/images/si/user.png" class="si_img" /> #GetLangVal('cm_wd_employee')#
				</cfcase>
				<cfcase value="1">
					<img src="/images/si/vcard.png" class="si_img" /> #GetLangVal('cm_wd_addressbook')#
				</cfcase>
				<cfcase value="2">
					<img src="/images/si/email.png" class="si_img" /> #GetLangVal('adrb_wd_email_address')#
				</cfcase>
				<cfcase value="4">
					<img src="/images/si/wrench.png" class="si_img" /> #GetLangVal('cm_wd_resource')#
				</cfcase>
			</cfswitch>
		</td>
		<td>
			
			<cfswitch expression="#q_select_meeting_members.type#">
				<cfcase value="0">
					
					<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
						<cfinvokeargument name="entrykey" value="#q_select_meeting_members.parameter#">
					</cfinvoke>
					
					#htmleditformat(q_select_user_data.query.username)#
						
				</cfcase>
				<cfcase value="1">
					
					<cfquery name="q_select_contact_name" dbtype="query">
					SELECT
						firstname,surname
					FROM
						q_select_contacts
					WHERE
						entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_meeting_members.parameter#">
					;
					</cfquery>
					
					#htmleditformat(q_select_contact_name.surname) & ', ' & htmleditformat(q_select_contact_name.firstname)#
					
				</cfcase>
				<cfcase value="2">
					
                    #htmleditformat(q_select_meeting_members.parameter)#
					
                </cfcase>
				<cfcase value="4">

					<cfquery name="q_select_resource_title" dbtype="query">
					SELECT
						title
					FROM
						q_select_resources
					WHERE
						entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_meeting_members.parameter#">
					;
					</cfquery>
					
					#htmleditformat(q_select_resource_title.title)#
					
				</cfcase>
			</cfswitch>
		</td>
		<td align="center">
			<cfif q_select_meeting_members.type NEQ 4>
    			<input type="checkbox" onclick="SetSendInvitation('#jsstringformat(url.entrykey)#', '#q_select_meeting_members.type#', this.value, this.checked);" name="frmsendinvitationcheck" value="#htmleditformat(q_select_meeting_members.parameter)#" #WriteCheckedElement(q_select_meeting_members.sendinvitation, 1)# />
    	    <cfelse>
    			-
			</cfif>
		</td>
		<td>
			<a href="javascript:removeAssignedElement('#jsstringformat(url.entrykey)#', '#q_select_meeting_members.type#', '#jsstringformat(q_select_meeting_members.parameter)#');"><img src="/images/si/delete.png" class="si_img" /></a>
			
			<cfif q_select_meeting_members.type EQ 1>

				<cfquery name="q_select_address" dbtype="query">
				SELECT
					*
				FROM
					q_select_contacts
				WHERE
					entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_meeting_members.parameter#">
				;
				</cfquery>
				
			    <cfset a_str_location = '' />
				
			    <cfif Len(q_select_address.b_street) GT 0>
			        <cfset a_str_location = ListAppend(a_str_location, q_select_address.b_street) />
			    </cfif>
			    <cfif Len(q_select_address.b_zipcode) GT 0>
			        <cfset a_str_location = ListAppend(a_str_location, q_select_address.b_zipcode) />
			    </cfif>
			    <cfif Len(q_select_address.b_city) GT 0>
			        <cfset a_str_location = ListAppend(a_str_location, q_select_address.b_city) />
			    </cfif>
			    <cfif Len(q_select_address.b_country) GT 0>
			        <cfset a_str_location = ListAppend(a_str_location, q_select_address.b_country) />
			    </cfif>
			    
				<cfset a_str_location = replacenocase(a_str_location, ',', ', ', 'ALL') />
				
				<cfif Len(a_str_location) GT 0>
					/
					<a href="##" onclick="$('##frmlocation').val('#JsStringFormat(a_str_location)#');$(this).append('<img src=/images/si/accept.png class=si_img />');"><img src="/images/si/map_add.png" class="si_img" /> #GetLangVal('cal_ph_set_this_location_for_meeting')#: <i>#a_str_location#</i></a>
				</cfif>
			</cfif>
			
		</td>
	</tr>
</cfoutput>
</table>

