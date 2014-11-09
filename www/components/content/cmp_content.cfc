<!--- //

	Component:	Content
	Description:Content routines


// --->
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="GetSignaturesOfUser" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="yes" hint="entrykey of user">
		<cfargument name="format" type="numeric" required="no" hint="empty = -1, text = 0, html = 1">
		<cfargument name="email_adr" type="string" required="no" default="" hint="email address (if filter set)">

		<cfinclude template="queries/q_select_signatures.cfm">

		<cfreturn q_select_signatures>
	</cffunction>

	<cffunction access="public" name="SetDefaultSignature" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="format" type="numeric" default="-1">

		<cfinclude template="queries/q_update_set_default_sig.cfm">

		<cfreturn true />
	</cffunction>

	<cffunction access="public" name="DeleteSignature" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		<cfinclude template="queries/q_delete_signature.cfm">
		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="CreateUpdateSignature" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="title" type="string" required="yes">
		<cfargument name="sig_data" type="string" required="yes">
		<cfargument name="format" type="numeric" required="yes">
		<cfargument name="email_adr" type="string" required="no" default="">
		<cfargument name="default" type="boolean" required="no" default="false">



		<cfif len(arguments.entrykey) GT 0>
			<cfset DeleteSignature(entrykey=arguments.entrykey, securitycontext=arguments.securitycontext)>
		</cfif>

		<cfif Len(arguments.entrykey) IS 0>
			<cfset arguments.entrykey = CreateUUID()>
		</cfif>

		<cfinclude template="queries/q_insert_signature.cfm">

		<cfreturn true />
	</cffunction>

	<!--- if a COMPANY has saved a custom element (e.g. custom header when sending remote edit mails
		use them --->
	<cffunction access="public" name="GetCompanyCustomElement" returntype="string">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="elementname" type="string" required="yes">

		<cfinclude template="queries/q_select_company_custom_element.cfm">

		<cfreturn trim(q_select_company_custom_element.content) />
	</cffunction>

	<cffunction access="public" name="SetCompanyCustomElement" returntype="string">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="elementname" type="string" required="yes">
		<cfargument name="elementvalue" type="string" required="yes">
		<cfargument name="createdbyuserkey" type="string" required="yes">

		<cfinclude template="queries/q_set_company_custom_element.cfm">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="UpdateCompanyLogo" output="false" returntype="struct"
			hint="update the logo of the company">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="companykey" type="string" required="true"
			hint="entrykey of the company">
		<cfargument name="imagedata" type="binary" required="true"
			hint="image data">
		<cfargument name="contenttype" type="string" required="true"
			hint="content type, e.g. image/jpeg">

		<cfset var stReturn = GenerateReturnStruct()>

		<cfif NOT IsBinary(arguments.imagedata) OR
			  (FindNoCase('image', arguments.contenttype) IS 0)>
			<cfreturn SetReturnStructErrorCode(stReturn, 15000)>
		</cfif>

		<cfinclude template="queries/q_delete_company_logo.cfm">
		<cfinclude template="queries/q_insert_company_logo.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>

	<cffunction access="public" name="GetCompanyLogoImgPath" returntype="struct"
			hint="return the img src path for the given companykey; return false if no logo exists">

		<cfset var stReturn = GenerateReturnStruct()>

		<cfinclude template="queries/q_select_company_logo.cfm">

		<cfif q_select_company_logo.recordcount IS 1>
			<cfset stReturn.contenttype = q_select_company_logo.filetype>
			<cfset stReturn.imagedata = q_select_company_logo.imagedata>
			<cfset stReturn.entrykey = q_select_company_logo.entrykey>

			<cfreturn SetReturnStructSuccessCode(stReturn)>
		<cfelse>
			<cfreturn stReturn>
		</cfif>

	</cffunction>

	<cffunction access="public" name="DeleteCompanyLogo" returntype="struct" output="false"
			hint="delete the currently saved company logo">
		<cfargument name="companykey" type="string" required="true">
		<cfset var stReturn = GenerateReturnStruct()>

		<cfinclude template="queries/q_delete_company_logo.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>

	<cffunction access="public" name="SendActivationMail" output="false" returntype="boolean" hint="send out the activation mail">
		<cfargument name="companykey" type="string" required="yes">

		<cfinclude template="utils/inc_send_activation_mail.cfm">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="SendWelcomeMail" returntype="boolean" output="false" hint="Send the official welcome email">
		<cfargument name="userkey" type="string" required="yes" hint="entrykey of user">
		<cfargument name="companykey" type="string" required="yes" hint="company">
		<cfargument name="createdbyusername" type="string" required="no" default="">
		<cfargument name="AdditionalInfo" type="string" required="no" default="">

		<cfset var a_str_username = ''>
		<cfset var a_str_used_style = ''>
		<cfset var a_cmp_user = 0 />
		<cfset var a_cmp_customize = 0 />
		<cfset var a_cmp_translation = 0 />
		<cfset var a_struct_load_userdata = 0 />
		<cfset var q_user_data = 0 />
		<cfset var a_str_used_style = 0 />
		<cftry>

		<!--- create components --->
		<cfset a_cmp_user = application.components.cmp_user>
		<cfset a_cmp_customize = application.components.cmp_customize />
		<cfset a_cmp_translation = application.components.cmp_lang>

		<!--- check if user exists ... --->
		<cfset a_str_username = a_cmp_user.GetUsernamebyentrykey(arguments.userkey)>

		<cfif Len(a_str_username) IS 0>
			<cfreturn false>
		</cfif>

		<!--- load user data ... --->
		<cfset a_struct_load_userdata = CreateObject('component', '/components/management/users/cmp_load_userdata').LoadUserdata(entrykey = arguments.userkey)>
		<cfset q_user_data = a_struct_load_userdata.query>

		<!--- get style of user ... --->
		<cfset a_str_used_style = a_cmp_user.GetUserCustomStyle(userkey = arguments.userkey)>

		<!--- get footer --->
		<cfset a_str_include_footer = a_cmp_customize.GetMailCustomFooter(style = a_str_used_style, langno = q_user_data.defaultlanguage)>

		<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_user.GetUsersettings(userkey = arguments.userkey), entryname = 'mail').AutomailSender>
		<cfset a_str_base_url = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_user.GetUsersettings(userkey=arguments.userkey), entryname = 'main').BaseURL>

		<!--- get company data ... --->
		<cfset a_str_content_company_text = GetCompanyCustomElement(companykey = arguments.companykey, elementname = 'welcomemail')>
		<cfset a_str_content_company_header = GetCompanyCustomElement(companykey = arguments.companykey, elementname = 'mail_header')>
		<cfset a_str_content_company_footer = GetCompanyCustomElement(companykey = arguments.companykey, elementname = 'mail_footer')>

		<cfinclude template="utils/inc_send_welcome_mail.cfm">

		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="error on sending welcome mail" type="html">
				<cfdump var="#arguments#">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>

		<cfreturn true>
	</cffunction>
</cfcomponent>