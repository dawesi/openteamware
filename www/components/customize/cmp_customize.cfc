<!--- //

	Module:		Customize
	Description:Customize component

// --->

<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="GetExistingCustomStyles" output="false" returntype="string"
			hint="comma separated list of custom styles">

		<cfreturn '' />
	</cffunction>

	<cffunction access="public" name="ReturnAllAvailableStyles" output="false" returntype="struct"
			hint="return all styles inclusive default style">
		<cfset var stReturn = StructNew() />
		<cfset var sEntrykey = '' />

		<!--- default style ... --->
		<cfset stReturn[ request.a_str_default_style ] = GetCustomizeStructure( customstyle = request.a_str_default_style) />

		<cfloop list="#GetExistingCustomStyles()#" index="sEntrykey">
			<cfset stReturn[sEntrykey] = GetCustomizeStructure(customstyle = sEntrykey)>
		</cfloop>

		<cfreturn stReturn />
	</cffunction>

	<cffunction access="public" name="CustomStyleExists" output="false" returntype="boolean"
			hint="return if a custom style with this entrykey exists">
		<cfargument name="usersettings" type="struct" required="yes">

		<cfreturn StructKeyExists(server.a_struct_custom_styles, arguments.usersettings.customstyle)>
	</cffunction>


	<!--- first, check if this is just a simple style data or really something interesting ... --->
	<cffunction access="public" name="GetCustomStyleData" output="false" returntype="any">
		<cfargument name="usersettings" type="struct" required="yes" hint="entrykey of the style">
		<cfargument name="entryname" type="string" required="yes" hint="name of item">

		<cfset var a_str_custom_style = ''>

		<cfif Len(arguments.usersettings.customstyle) GT 0>
			<cfset a_str_custom_style = arguments.usersettings.customstyle>
		<cfelse>
			<cfset a_str_custom_style = request.a_str_default_style>
		</cfif>

		<cfif NOT StructKeyExists(server.a_struct_custom_styles, a_str_custom_style)>
			<!--- try to use the default style ... --->
			<cfset a_str_custom_style = request.a_str_default_style>
		</cfif>

		<cfif StructKeyExists(server.a_struct_custom_styles[a_str_custom_style], arguments.entryname)>
			<cfreturn server.a_struct_custom_styles[a_str_custom_style][arguments.entryname]>
		<cfelse>
			<cfreturn ''>
		</cfif>

	</cffunction>

	<!--- return the used style ... --->
	<cffunction access="public" name="GetUsedStyle" output="false" returntype="string">
		<cfargument name="request_scope" type="struct" required="yes">
		<cfargument name="cgi_variables" type="struct" required="yes">

		<cfset var sReturn = ''>

		<!--- now, check the request scope for a logged in user ... --->


		<!--- return the data of the appsettings  in the request scope ... --->
		<cfreturn arguments.request_scope.appsettings.default_stylesheet>

		<!--- check the cgi variables ... --->

		<cfreturn sReturn>
	</cffunction>

	<!--- load a certain settings by just using the style/entryname without providing the usersettings --->
	<cffunction access="public" name="GetCustomStyleDataWithoutUsersettings" output="false" returntype="any">
		<cfargument name="entryname" type="string" required="yes">
		<cfargument name="style" type="string" required="yes">

		<cfset var a_str_used_style = arguments.style />

		<cfif NOT StructKeyExists( server, 'a_struct_custom_styles')>
			<cfreturn request.a_str_default_style />
		</cfif>

		<cfif NOT StructKeyExists(server.a_struct_custom_styles, arguments.style)>
			<cfset a_str_used_style = request.a_str_default_style />
		</cfif>

		<cfif Len(a_str_used_style) IS 0>
			<cfset a_str_used_style = request.a_str_default_style />
		</cfif>

		<!---<cflog text="server.a_struct_custom_styles[a_str_used_style][arguments.entryname]: #server.a_struct_custom_styles[a_str_used_style][arguments.entryname]['path']#" type="Information" log="Application" file="ib_customize">
		<cflog text="a_str_used_style: #a_str_used_style#" type="Information" log="Application" file="ib_customize">--->

		<cfif StructKeyExists(server.a_struct_custom_styles[a_str_used_style], arguments.entryname)>
			<cfreturn server.a_struct_custom_styles[a_str_used_style][arguments.entryname] />
		<cfelse>
			<cfreturn '' />
		</cfif>

	</cffunction>

	<cffunction access="public" name="GetCustomizeStructure" output="false" returntype="struct">
		<cfargument name="customstyle" type="string" required="yes" hint="entrykey of the custom style">

		<cfset var stReturn = StructNew()>

		<!--- // set default settings // --->

		<!--- main --->
		<cfset stReturn.main = StructNew()>
		<cfset stReturn.main.productname = 'openTeamWare'>
		<cfset stReturn.main.baseUrl = 'www.openTeamware.com'>
		<cfset stReturn.main.AllowPublicRegister = true>
		<cfset stReturn.main.PublicRegisterURL = '/rd/signup/'>
		<cfset stReturn.main.FeedbackURL = '/support/'>
		<cfset stReturn.main.DefaultPartnerkey = '5872C37B-DC97-6EA3-E84EC482D29FC169'>

		<!--- allow the customer to take orders --->
		<cfset stReturn.main.DefaultAllowShopOwnOrder = true>
		<!--- 0 = default invoice system --->
		<cfset stReturn.main.DefaultSettlementType = 0>

		<!--- mail addresses --->
		<cfset stReturn.mail = StructNew()>
		<cfset stReturn.mail.AutomailSender = 'openTeamWare (Automatisch erstellte Nachricht) <KeineAntwortAdresse@openTeamWare.com>'>
		<cfset stReturn.mail.FeedbackMailSender = 'openTeamWare Kundenservice (feedback@openTeamWare.com) <feedback@openTeamWare.com>'>

		<!--- mobile --->
		<cfset stReturn.mobile = StructNew()>
		<cfset stReturn.mobile.smsSender = 'openTeamWare' />

		<!--- links --->
		<cfset stReturn.links = StructNew()>
		<cfset stReturn.links.homepage = '/cms/'>
		<cfset stReturn.links.shop = '/administration/?action=shop'>
		<cfset stReturn.links.company_contact = '/cms/content/view/13/32/'>
		<cfset stReturn.links.ctac = '/cms/content/view/67/'>
		<cfset stReturn.links.pricelist = '/cms/content/view/59/80/'>
		<cfset stReturn.links.privacyPolicy = '/cms/content/view/67/'>
		<cfset stReturn.links.scopeOfServices = '/cms/content/view/59/80/'>

		<!--- administration ... --->
		<cfset stReturn.administration = StructNew()>
		<cfset stReturn.administration.autoorderontrialend = true>

		<!--- misc locations ... --->
		<cfset stReturn.locations = StructNew()>
		<cfset stReturn.locations.onLogout = '/'>

		<!--- administration --->
		<!--- must accept common terms and conditions --->
		<cfset stReturn.must_accept_ctac = true>

		<!--- misc --->
		<cfset stReturn.misc = StructNew()>
		<cfset stReturn.misc.newsticker_enabled = 0 />
		<cfset stReturn.misc.recommend_form_enabled = 1 />
		<cfset stReturn.misc.newsticker_own_news_only = 0 />

		<!--- menu --->
		<cfset stReturn.menu = StructNew() />
		<cfset stReturn.menu.exclude_items = 'blog' />

		<!--- misc logos--->
		<cfset stReturn.big_logo = StructNew()>
		<cfset stReturn.big_logo.path = '/images/default_service_logo.png' />
		<cfset stReturn.big_logo.width = 133 />
		<cfset stReturn.big_logo.height = 35 />

		<cfset stReturn.medium_logo = StructNew()>
		<cfset stReturn.medium_logo.path = '/images/default_service_logo.png' />
		<cfset stReturn.medium_logo.width = 133 />
		<cfset stReturn.medium_logo.height = 35 />

		<cfset stReturn.wap_logo = StructNew()>
		<cfset stReturn.wap_logo.path = ''>
		<cfset stReturn.wap_logo.width = 0>
		<cfset stReturn.wap_logo.height = 0>

		<cfset stReturn.pda_logo = StructNew()>
		<cfset stReturn.pda_logo.path = ''>
		<cfset stReturn.pda_logo.width = 0>
		<cfset stReturn.pda_logo.height = 0>

		<cfreturn stReturn>
	</cffunction>

	<!--- returns the filename of the file to include ... --->
	<cffunction access="public" name="GetMailCustomHeader" output="false" returntype="string">
		<cfargument name="style" type="string" required="yes" hint="entrykey of used style (or empty)">
		<cfargument name="langno" type="numeric" default="0" required="no" hint="language number">

		<cfreturn '' />
	</cffunction>

	<!--- returns the filename of the file to include ... if no file exists, returns '' --->
	<cffunction access="public" name="GetMailCustomFooter" output="false" returntype="string">
		<cfargument name="style" type="string" required="yes">
		<cfargument name="langno" type="numeric" default="0" required="no">

		<cfset var a_str_page_include = ''>

		<cfif Len(arguments.style) GT 0>
			<!--- try to load custom footer --->
			<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
				<cfinvokeargument name="section" value="cobranding">
				<cfinvokeargument name="langno" value="#arguments.langno#">
				<cfinvokeargument name="template_name" value="mail_footer_#arguments.style#">
			</cfinvoke>
		</cfif>

		<cfif Len(a_str_page_include) IS 0>
			<!--- load the default file ... --->
				<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
					<cfinvokeargument name="section" value="cobranding">
					<cfinvokeargument name="langno" value="#arguments.langno#">
					<cfinvokeargument name="template_name" value="mail_footer_default">
				</cfinvoke>
		</cfif>

		<cfreturn a_str_page_include>
	</cffunction>

	<!--- try to integrate a cobranding text block ... if it does not exist, use the default data --->
	<cffunction access="public" name="GetCobrandedElement" output="false" returntype="string">
		<cfargument name="section" type="string" required="yes" hint="section name">
		<cfargument name="langno" type="numeric" default="0" required="no">
		<cfargument name="template_name" type="string" required="yes" hint="name of the template">
		<cfargument name="style" required="yes" type="string" hint="entrykey of style">

		<cfset var a_str_page_include = ''>
		<cfset var a_str_used_template = ''>
		<cfset var a_str_check_template_exists = arguments.template_name & '_' & arguments.style>
		<cfset var a_str_default_template = arguments.template_name & '_default'>
		<cfset var a_bol_template_exists = false />
		<cfset var a_cmp_translation = CreateObject('component', request.a_str_component_lang) />

		<cfinvoke component="#application.components.cmp_lang#" method="TemplateExists" returnvariable="a_bol_template_exists">
			<cfinvokeargument name="section" value="#arguments.section#">
			<cfinvokeargument name="template_name" value="#a_str_check_template_exists#">
			<cfinvokeargument name="langno" value="#arguments.langno#">
		</cfinvoke>

		<cfif a_bol_template_exists>
			<cfset a_str_used_template = a_str_check_template_exists>
		<cfelse>
			<cfset a_str_used_template = a_str_default_template>
		</cfif>

		<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
			<cfinvokeargument name="section" value="#arguments.section#">
			<cfinvokeargument name="langno" value="#arguments.langno#">
			<cfinvokeargument name="template_name" value="#a_str_used_template#">
		</cfinvoke>

		<cfreturn a_str_page_include>
	</cffunction>

	<!--- if a COMPANY has saved a custom element (e.g. custom header when sending remote edit mails
		use them --->
	<cffunction access="public" name="GetCompanyCustomElement" returntype="struct">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="elementname" type="string" required="yes">

		<cfreturn ''>
	</cffunction>

</cfcomponent>

