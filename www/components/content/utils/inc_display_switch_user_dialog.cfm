<!--- //

	Description:Show switch user dialog ...
	

// --->

<!--- load userdata .. --->
<cfinvoke component="#application.components.cmp_load_user_data#" method="LoadUserData" returnvariable="a_struct_load_userdata">
	<cfinvokeargument name="entrykey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<!--- load SSO data ... --->
<cfset q_select_sso_settings = application.components.cmp_security.LoadSwitchUsersData(userkey = arguments.securitycontext.myuserkey)>

<cfset a_cmp_email_accounts = CreateObject('component', '/components/email/cmp_accounts')>

<table class="table table_details">
<tr>

<cfoutput query="q_select_sso_settings">
		
	<!--- display login for other user ... --->
	<cfset a_str_other_userkey = q_select_sso_settings.otheruserkey>
	<cfset a_str_pwd_md5 = q_select_sso_settings.otherpassword_md5>
	
	<cfif CompareNoCase(a_str_other_userkey, arguments.securitycontext.myuserkey) IS 0>
		<cfset a_str_other_userkey = q_select_sso_settings.userkey>
		
		<!--- a_str_pwd_md5 must be set to the password of the other user ...
			check if the stored password hash is the password hash
			of the current user to see if the other has added this user properly ... --->
		<cfif a_str_pwd_md5 IS Hash(a_struct_load_userdata.query.pwd)>
			
			<cfset q_select_other_user_pwd = application.components.cmp_load_user_data.LoadUserData(entrykey = a_str_other_userkey).query>
			
			<!--- set the md5 hashed password to the password
				of the other user ... --->
			<cfset a_str_pwd_md5 = Hash(q_select_other_user_pwd.pwd)>
			
		</cfif>
	</cfif>
	
	<td valign="top">

		<a href="javascript:document.forms.idformsso#q_select_sso_settings.currentrow#.submit();">
		<img class="nl" border="0" vspace="2" hspace="2" src="/tools/img/show_company_logo.cfm?entrykey=#application.components.cmp_user.GetCompanyKeyOfuser(a_str_other_userkey)#"/>
		<br /> 
		<b>#htmleditformat(application.components.cmp_user.getusernamebyentrykey(a_str_other_userkey))#</b>
		<br/>
		#application.components.cmp_customer.GetCustomerNameByEntrykey(entrykey = application.components.cmp_user.GetCompanyKeyOfuser(a_str_other_userkey))#
		</a>
		
		<!--- offer quick login ... --->
		<form target="_top" action="/login/act_login.cfm" method="post" style="margin:0px;" id="idformsso#q_select_sso_settings.currentrow#">
			<input type="hidden" name="frmUsername" value="#application.components.cmp_user.getusernamebyentrykey(a_str_other_userkey)#"/>
			<input type="hidden" name="frmpassword_md5" value="#a_str_pwd_md5#"/>
		</form>
		
		<!--- display number of new emails ... --->
		
		<cfinvoke component="#a_cmp_email_accounts#" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
			<cfinvokeargument name="userkey" value="#a_str_other_userkey#">
		</cfinvoke>
		
		<cftry>
		
		<cfinvoke component="#application.components.cmp_email#" method="loadfolders" returnvariable="a_struct_load_email_folders">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="accessdata" value="#request.stSecurityContext.a_struct_imap_access_data#">
		</cfinvoke>
		
		<cfif a_struct_load_email_folders.result IS 'OK'>
		
			<cfset q_select_folders = a_struct_load_email_folders.query>
			
			<cfquery name="q_select_folders" dbtype="query">
			SELECT
				fullfoldername,unreadmessagescount
			FROM
				q_select_folders
			WHERE
				unreadmessagescount > 0
			;
			</cfquery>
			
			<cfif q_select_folders.recordcount GT 0>
			
				<br/>
				#GetLangVal('mail_ph_new_mails')#:
				<br/>
				
				<cfloop query="q_select_folders">
					#Returnfriendlyfoldername(q_Select_folders.fullfoldername)#: #q_select_folders.unreadmessagescount#
					<br/>
				</cfloop>
				
			</cfif>
		</cfif>
		
		

		<cfcatch type="any">
		</cfcatch>
		</cftry>
	</td>
	</cfoutput>
</tr>	
</table>

