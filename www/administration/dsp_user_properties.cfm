<!--- //

	Module:		Admintool
	Action:		UserProperties
	Description:display properties of a user ...
	
// --->

	
<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="dsp_inc_select_company.cfm">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
  <cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_userdata = stReturn.query>

<!--- create components ... --->
<cfset a_cmp_customers = application.components.cmp_customer />
<cfset a_cmp_users = application.components.cmp_user>
<cfset cmp_get_workgroup_memberships = application.components.cmp_user>
<cfset cmp_get_workgroup_name = CreateObject("component", request.a_str_component_workgroups)>


<b><cfoutput>#GetLangVal('cm_wd_actions')#</cfoutput></b>:
		
		<a href="index.cfm?action=user.createdatasheet&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput>#si_img('page_white_acrobat')# #GetLangVal('adm_ph_create_datasheet')#</cfoutput></a>
		<a href="index.cfm?action=user.edit&section=data&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput>#si_img('pencil')# #GetLangVal('adm_ph_edit_userdata')#</cfoutput></a>
		<a href="index.cfm?action=user.setphoto&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput>#si_img('photo')# #GetLangVal('adm_ph_set_photo')#</cfoutput></a>
		<a href="index.cfm?action=user.managesso&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>">Manage SSO</a>
		<a href="index.cfm?action=user.resetpassword&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput>#si_img('key')# #GetLangVal('adm_ph_set_new_password')#</cfoutput></a>
		<a href="index.cfm?action=user.changeaccounttype&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_change_account_type')#</cfoutput></a>
		<cfif q_userdata.allow_login IS 1>
		<a href="index.cfm?action=user.disable&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##writeurltags()#</cfoutput>"><cfoutput>#si_img('cross')# #GetLangVal('adm_wd_deactivate')#</cfoutput></a>
		<cfelse>
		<a style="color:darkgreen;" href="index.cfm?action=user.enable&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##writeurltags()#</cfoutput>"><b><cfoutput>#GetLangVal('adm_wd_activate_again')#</cfoutput></b> ...</a>
		</cfif>
		<a href="index.cfm?action=user.delete&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput><span class="glyphicon glyphicon-trash�></span> #GetLangVal('adm_wd_delete_user')#</cfoutput></a>
		
<h4 style="margin-bottom:3px;"><cfoutput>#ReplaceNoCase(GetLangVal('adm_ph_properties_of_user'), '%USERNAME%', q_userdata.username)#</cfoutput></h4>
<cfif q_userdata.bigphotoavaliable IS 1>
					<img src="../tools/img/show_big_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>&source=admintool" border="0" align="right" />
			<cfelseif q_userdata.smallphotoavaliable IS 1>
				<img src="../tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>&source=admintool" border="0" align="right" />
			<cfelse>
				(<cfoutput>#GetLangVal('adm_ph_no_photo_avaliable')#</cfoutput>
				
				<a href="index.cfm?action=user.setphoto&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_set_photo')#</cfoutput></a> 
				)
			</cfif>


     <cfoutput query="q_userdata"> 
	 
	 
	<cfsavecontent variable="a_str_content">
		  <table class="table table_details">
		  <cfif IsInternalIPOrUser()>
		  	<tr>
				<td class="field_name">Entrykey</td>
				<td>#url.entrykey#</td>
			</tr>
		  </cfif>
		  <tr>
		  	<td class="field_name">#GetLangVal('adm_ph_login_allowed')#:</td>
			<td>
				<cfif q_userdata.allow_login IS 1>
					#GetLangVal('cm_wd_yes')#
				<cfelse>
					<font color="red">#GetLangVal('cm_wd_no')#</font>
				</cfif>
			</td>
		  </tr>
 			<tr> 
            <td class="field_name">#GetLangVal('cm_wd_name')#:</td>
            <td>#htmleditformat(q_userdata.surname)#, #htmleditformat(q_userdata.firstname)#</td>
          </tr>
		  <tr>
		  	<td class="field_name">#GetLangVal('cm_ph_iden_code_short_member')#:</td>
			<td>
				#htmleditformat(q_userdata.identificationcode)#
			</td>
		  </tr>		
		  <tr>
		  	<td class="field_name">
				#GetLangVal('cm_wd_language')#:
			</td>
			<td>
				#application.components.cmp_lang.GetLanguageShortNameByNumber(q_userdata.defaultlanguage)#
			</td>
		  </tr>  
          <tr> 
            <td class="field_name">#GetLangVal('adm_ph_account_type')#:</td>
            <td> 
			<cfswitch expression="#q_userdata.productkey#">
				<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
					Mobile Office
				</cfcase>
				<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
					Mobile CRM
				</cfcase>
			</cfswitch>
			 </td>
          </tr>
		  <tr>
		  	<td class="field_name">#GetLangVal('adrb_wd_department')#:</td>
			<td>
				#htmleditformat(q_userdata.department)#
			</td>
		  </tr>
		  <tr>
		  	<td class="field_name">#GetLangVal('adrb_wd_position')#:</td>
			<td>
				#htmleditformat(q_userdata.aposition)#
			</td>
		  </tr>		
		  <tr>
		  	<td class="field_name">#GetLangVal('cm_wd_status')#:</td>
			<td>
				<cfif q_userdata.activitystatus IS 1>
					#GetLangVal('cm_wd_active')#
				<cfelse>
					#GetLangVal('cm_wd_inactive')#
				</cfif>
			</td>
		  </tr>  
		  </table>
	</cfsavecontent>
	
	<cfsavecontent variable="a_str_btn">
		<cfoutput >
		<input type="button" class="btn btn-primary" value="#GetLangVal('cm_wd_edit')#" onclick="location.href='index.cfm?action=user.edit&section=data&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#';"/>
		</cfoutput>
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(q_userdata.username, a_str_btn, a_str_content)#</cfoutput>

	
	<br/>
	
    <!--- load workgroup memberships ... --->
    <cfset q_select_workgroups = cmp_get_workgroup_memberships.GetWorkgroupMemberships(q_userdata.entrykey)>
	
	<cfsavecontent variable="a_str_content">
		
		
		<table class="table table_details">
  			<cfloop query="q_select_workgroups">
            <tr> 
              <td class="field_name">###q_select_workgroups.currentrow#</td>
              <td> 
                <a href="index.cfm?action=workgroupproperties&entrykey=#urlencodedformat(q_select_workgroups.workgroupkey)##writeurltags()#">#htmleditformat(checkzerostring(cmp_get_workgroup_name.GetWorkgroupNameByEntryKey(q_select_workgroups.workgroupkey)))#</a>
				
				&nbsp;&nbsp;#GetLangVal('adm_wd_roles')#:
				 <cfloop index="a_str_role_key" list="#q_select_workgroups.roles#" delimiters=",">
                  <cfset a_str_rolename = cmp_get_workgroup_name.getrolenamebyentrykey(a_str_role_key)>
                  #a_str_rolename# </cfloop>
				
				</td>
            </tr>
          </cfloop>

          <cfif q_select_workgroups.recordcount is 0>
            <tr> 
              <td></td>
              <td>n/a</td>
            </tr>
          </cfif>
		  
		  
		  <cfinvoke component="/components/management/workgroups/cmp_secretary" method="GetAllAttendedUsers" returnvariable="q_select_attended_users">
		  	<cfinvokeargument name="userkey" value="#q_userdata.entrykey#">
		  </cfinvoke>
		  
		  <tr>
		  	<td></td>
			<td>
				#GetLangVal('adm_ph_secretary_entries')#: #q_select_attended_users.recordcount#
			</td>
		  </tr>
		  <cfif q_select_attended_users.recordcount GT 0>
		  	<tr>
				<td></td>
				<td>
				<cfloop query="q_select_attended_users">
					#cmp_get_workgroup_memberships.GetUsernamebyentrykey(q_select_attended_users.userkey)#<br>
				</cfloop>
				</td>
			</tr>
		  </cfif>
		</table>
	</cfsavecontent>
	
	<cfsavecontent variable="a_str_btn">
		<cfoutput >
		<input type="button" class="btn btn-primary" value="#GetLangVal('cm_wd_edit')#" onclick="location.href='index.cfm?action=user.edit&section=workgroups&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#';"/>
		</cfoutput>
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(GetLangVal('adm_ph_group_memberships'), a_str_btn, a_str_content)#</cfoutput>

	
	<br/>
	
	<cfsavecontent variable="a_str_content">
		
		
		<table class="table table-hover">
 			<tr class="tbl_overview_header">
            	<td>#GetLangVal('adm_ph_security_role')#</td>
            <td>
		</tr>
		<tr>
			<td>
			<cfif Len(q_userdata.securityrolekey) IS 0>
				#GetLangVal('adm_ph_none_defined')#
			</cfif>
			<cfinvoke component="#application.components.cmp_security#" method="GetSecurityRole" returnvariable="stReturn">
				<cfinvokeargument name="companykey" value="#url.companykey#">
				<cfinvokeargument name="entrykey" value="#q_userdata.securityrolekey#">
			</cfinvoke>
			
			<a href="index.cfm?action=securityrole.display&entrykey=#urlencodedformat(stReturn.q_select_security_role.entrykey)##WriteURLTags()#">#stReturn.q_select_security_role.rolename#</a>

			</td>
          </tr>
		</table>
		
		<cfset q_select_sso_settings = application.components.cmp_security.LoadSwitchUsersData(userkey = q_userdata.entrykey)>
		
		<cfif q_select_sso_settings.recordcount GT 0>
			<br/>
			<b>Single Sign On</b>
			<table class="table table-hover">
				<tr class="tbl_overview_header">
					<td>Username</td>
					<td>Company</td>
				</tr>
				<cfloop query="q_select_sso_settings">
					<tr>
						<td>
							#a_cmp_users.getusernamebyentrykey(q_select_sso_settings.otheruserkey)#
						</td>
						<td>
							#a_cmp_customers.GetCustomerNameByEntrykey(a_cmp_users.GetCompanyKeyOfuser(q_select_sso_settings.otheruserkey))#
						</td>
					</tr>
				</cfloop>
			</table>
		</cfif>

	</cfsavecontent>
	
	<cfsavecontent variable="a_str_btn">
		<cfoutput >
		<input type="button" class="btn btn-primary" value="#GetLangVal('cm_wd_edit')#" onclick="location.href='index.cfm?action=user.edit&section=security&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#';"/>
		<input type="button" class="btn btn-primary" value="#GetLangVal('cm_wd_edit')# SSO" onclick="location.href='index.cfm?action=user.managesso&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#'"/>
		</cfoutput>
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_security'), a_str_btn, a_str_content)#</cfoutput>

	
	<br/>
		
		<cfsavecontent variable="a_str_content">
		
		<table class="table table-hover">
			<tr class="tbl_overview_header">
				<td><cfoutput>#GetLangVal('cm_wd_type')#</cfoutput></td>
				<td><cfoutput>#GetLangVal('cm_wd_email_address')#</cfoutput></td>
			</tr>
			
 		<!--- // select all external addresses and aliases ... //--->
		  <cfinvoke component="/components/email/cmp_accounts" method="GetEmailAccounts" returnvariable="q_select_pop3_data">
		  	<cfinvokeargument name="userkey" value="#url.entrykey#">
		  </cfinvoke>
		  
		  <cfinvoke component="/components/email/cmp_accounts" method="GetAliasAddresses" returnvariable="q_select_alias_addresses">
			<cfinvokeargument name="userkey" value="#url.entrykey#">
		</cfinvoke>
		  
		  <!--- select aliases ... --->
		  <cfquery name="q_select_external_addresses" dbtype="query">
		  SELECT
		  	*
		  FROM
		  	q_select_pop3_data
		  WHERE
		  	origin = 1
		  ;	
		  </cfquery>		  
		  
		  <cfloop query="q_select_alias_addresses">
		  	<tr>
				<td>#GetLangVal('adm_ph_alias_addresses')#</td>
				<td>#htmleditformat(q_select_alias_addresses.aliasaddress)#</td>
			</tr>
		  </cfloop>
		  <cfloop query="q_select_external_addresses">
		  	<tr>
				<td>#GetLangVal('adm_ph_pop3_collector_addresses')#</td>
				<td>				
					#htmleditformat(q_select_external_addresses.emailadr)# (#htmleditformat(q_select_external_addresses.pop3server)#)
				</td>
			</tr>
		  </cfloop>
		</table>
	</cfsavecontent>
		
	<cfsavecontent variable="a_str_btn">
		<input type="button" class="btn btn-primary" value="#GetLangVal('cm_wd_edit')#" onclick="location.href='index.cfm?action=user.edit&section=emailaddresses&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#';"/>
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(GetLangVal('prf_ph_email_addresses'), a_str_btn, a_str_content)#</cfoutput>
	
	<br /> 
	
	<cfsavecontent variable="a_str_content">
		<table class="table table_details">
  <!--- edit mailbox limit ... --->		  
		  <cfinvoke component="#application.components.cmp_email_tools#" method="GetQuotaDataForUser" returnvariable="a_struct_quota">
		  	<cfinvokeargument name="username" value="#q_userdata.username#">
		  </cfinvoke>
		  
          <tr> 
             <td class="field_name">#GetLangVal('adm_ph_mailbox_limit')#:</td>
            <td valign="top">
			
			#GetLangVal('adm_ph_mailbox_limit_ava_used')#: #byteConvert(a_struct_quota.maxsize)# / #byteConvert(a_struct_quota.currentsize)#
						
			</td>
          </tr>
		  <tr>
		  	<td>&nbsp;</td>
			<td>
			<cfset a_int_one_perc = val(a_struct_quota.maxsize) / 100>
			<cftry>
			<cfset a_int_share = Int(a_struct_quota.currentsize / a_int_one_perc)*2>
			<cfcatch type="any">
				<cfset a_int_share = 0>
			</cfcatch>
			</cftry>
			<div class="b_all" style="height:5px;width:200px;"><img src="/images/bar_small.gif" width="#a_int_share#px" height="5"></div>
			</td>
		  </tr>
		  <cfset a_struct_tmp_securitycontext = StructNew()>
		  
		  <cfset a_struct_tmp_securitycontext.myuserkey = q_userdata.entrykey>
		<cfinvoke   
			component = "#application.components.cmp_storage#"   
			method = "GetUsageInfo"   
			returnVariable = "q_query_usage"   
			securitycontext="#a_struct_tmp_securitycontext#"></cfinvoke>		  
          <tr> 
             <td class="field_name">#GetLangVal('cm_wd_storage')#:</td>
            <td>
				#GetLangVal('adm_ph_mailbox_limit_ava_used')#: #ByteConvert(q_query_usage.maxsize)# / #ByteConvert(q_query_usage.bused)#
			</td>
          </tr>
		  <tr>
		  	<td></td>
			<td>
				<a href="index.cfm?action=user.edit&section=quota&entrykey=#urlencodedformat(url.entrykey)##writeurltags()#"><img src="/images/editicon.gif" align="absmiddle" border="0"> #GetLangVal('cm_wd_edit')#</a>
			</td>
		  </tr>
		</table>
		
		</cfsavecontent>
			
	<cfoutput>#WriteNewContentBox(GetLangVal('adm_wd_quota'), '', a_str_content)#</cfoutput>
	
	
	
	<br /> 
		
		<cfsavecontent variable="a_str_content">
		<table class="table table_details">
 			<tr> 
             <td class="field_name">#GetLangVal('adm_wd_logins')#:</td>
            <td>#val(q_userdata.login_count)#</td>
          </tr>
          <tr> 
            <td class="field_name">#GetLangVal('adm_ph_last_login')#:</td>
            <td> #lsdateformat(q_userdata.lasttimelogin, "dd.mm.yy")# #TimeFormat(q_userdata.lasttimelogin, "HH:mm")# </td>
          </tr>
		  <tr>
		  	 <td class="field_name">#GetLangVal('cm_wd_contacts')#:</td>
			<td>
				<cfquery name="q_select_addresses">
				SELECT
					COUNT(id) AS count_id
				FROM
					addressbook
				WHERE
					userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_userdata.entrykey#">
				;
				</cfquery>
				
				#q_select_addresses.count_id#
			</td>
		  </tr>
		  <tr>
		  	 <td class="field_name">#GetLangVal('cm_wd_events')#:</td>
			<td>
				<cfquery name="q_select_calendar">
				SELECT
					COUNT(id) AS count_id
				FROM
					calendar
				WHERE
					userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_userdata.entrykey#">
				;
				</cfquery>
				
				#q_select_calendar.count_id#
			</td>
		  </tr>
		  <tr>
		  	 <td class="field_name">#GetLangVal('cm_wd_files')#:</td>
			<td>
				<cfquery name="q_select_storage">
				SELECT
					COUNT(id) AS count_id
				FROM
					storagefiles
				WHERE
					userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_userdata.entrykey#">
				;
				</cfquery>
				
				#q_select_storage.count_id#
			</td>
		  </tr>
		  <tr>
		  	 <td class="field_name">#GetLangVal('cm_wd_tasks')#:</td>
			<td>
				<cfquery name="q_select_tasks">
				SELECT
					COUNT(id) AS count_id
				FROM
					tasks
				WHERE
					userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_userdata.entrykey#">
				;
				</cfquery>
				
				#q_select_tasks.count_id#
			</td>
		  </tr>		  		  
		  <tr>
		  	 <td class="field_name"></td>
			<td>
			<a href="index.cfm?action=security.logbook&companykey=#urlencodedformat(url.companykey)#&resellerkey=#urlencodedformat(url.resellerkey)#&userkey=#urlencodedformat(url.entrykey)#">#GetLangVal('adm_ph_show_security_log')#</a>
			
			<cfif request.a_bol_is_reseller>
			<br>
			<a href="index.cfm?action=activity&#WriteURLTags()#&userkey=#urlencodedformat(url.entrykey)#">#GetLangVal('adm_ph_show_user_usage')#</a>
			</cfif>
			</td>
		  </tr>
		</table>
		</cfsavecontent>
			
	<cfoutput>#WriteNewContentBox(GetLangVal('adm_wd_statistics'), '', a_str_content)#</cfoutput>
	
	
	</cfoutput>
	





