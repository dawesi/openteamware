<!--- //

	Component:	Render
	Description:Render routines ...

// --->

<cfcomponent output="false" hint="Various render methods and functions for the framework">

	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction name="GenerateServiceDefaultFile" output="false" returntype="string">
		<cfargument name="servicekey" type="string" hint="entrykey of service">
		<cfargument name="pagetitle" type="string" default="" required="false" hint="name of displayed page">

		<cfset var sReturn = '' />
		<cfset var a_struct_current_service_actions = StructNew() />
		<cfset var a_str_html_header = '' />
		<cfset var a_str_body_start = '' />
		<cfset var a_str_page_output = '' />
		<cfset var a_str_html_endtags = '' />
		<cfset var a_str_current_action = '' />
		<cfset var a_str_main_menu_bar = '' />
		<!--- <cfset var a_struct_variables = variables /> --->
		<cfset var a_tc_count_runtime_fw = GetTickCount() />
		<cfset var a_bol_logged_in = CheckSimpleLoggedIn() />
		<cfset var a_cur_page = cgi.SCRIPT_NAME & '?' & cgi.QUERY_STRING />

		<!--- set servicekey ... --->
		<cfset request.sCurrentServiceKey = arguments.servicekey />

		<!--- set property for include pages to know, we're in the new generateservicedefaultfile routine --->
		<cfset request.a_bol_using_generate_service_default_file_framework = true />

		<!--- get actions ... --->
		<cfset a_struct_current_service_actions = GetActionSwitchesForCurrentService() />

		<!--- set default action ...--->
		<cfset a_str_current_action = SetDefaultUrlAction(a_struct_current_service_actions.defaultaction) />

		<!--- check switches ... --->
		<cfinclude template="utils/inc_check_action_switches.cfm">

		<!--- modify request if needed (e.g. page type, format, content-id to show etc) ... --->
		<cfinclude template="utils/inc_modify_page_request.cfm">

		<!--- inpage, popup ... and not logged in? exit! ... --->
		<cfif (SmartLoadEnabled() OR IsInPagePopupOrActionPageCall()) AND NOT a_bol_logged_in>
			<cfreturn '' />
		</cfif>

		<!--- check login first ... --->
		<cfinclude template="/login/check_logged_in.cfm">

		<cfset request.a_bol_simple_page_request = (SmartLoadEnabled() OR IsInPagePopupOrActionPageCall()) />

		<!--- set session variable with last called page ... --->
		<cfif NOT request.a_bol_simple_page_request AND StructKeyExists(session, 'stUserSettings')>
			<cflock scope="session" type="exclusive" timeout="3">

				<!--- set last page visit (if different from current page only) --->
				<cfif CompareNoCase(a_cur_page, session.stUserSettings.LastPageRequest) NEQ 0>
					<cfset session.stUserSettings.LastPageRequest = a_cur_page />
				</cfif>
			</cflock>
		</cfif>

		<!--- no smartload and no inpage popup ... --->
		<cfif NOT (SmartLoadEnabled() OR IsInPagePopupOrActionPageCall())>
			<cfset a_str_html_header = GenerateHTMLHeaderContent(pagetitle = arguments.pagetitle, currentaction = a_str_current_action, servicekey = arguments.servicekey) />
			<cfset a_str_body_start = GeneratePageBodyTag() />

			<cfif NOT IsInPopupMenuMode()>
				<cfset a_str_main_menu_bar = GenerateMainMenuBar(servicekey = arguments.servicekey) />
			</cfif>

		</cfif>

		<!--- core: generate output --->
		<cfset a_str_page_output = GeneratePageOutput() />

		<cfif NOT (SmartLoadEnabled() OR IsInPagePopupOrActionPageCall())>
			<cfset a_str_html_endtags = GenerateHTMLEndTags() />
		</cfif>

		<!--- compose --->
		<cfset sReturn = a_str_html_header & a_str_body_start & a_str_main_menu_bar & a_str_page_output & a_str_html_endtags />

		<!--- content id given to extract? --->
		<cfif Len( request.a_struct_current_service_action.sExtractContentID )>
			<cfset sReturn = ExtractContentbyID( sPageContent = sReturn, sContentID = request.a_struct_current_service_action.sExtractContentID ) />
		</cfif>

		<!--- which mode? --->
		<cfswitch expression="#request.a_struct_current_service_action.sFormat#">
			<cfcase value="pdf">

				<cfsavecontent variable="sReturn">
				<cfinclude template="utils/inc_generate_output_pdf.cfm" />
				</cfsavecontent>

				<cfdocument filename="/tmp/output.pdf" format="pdf" unit="cm" orientation="landscape" pagetype="A4" overwrite="true" marginbottom="1" margintop="1" marginleft="1.5" marginright="1.5">
					<cfdocumentitem type="footer">
						<div style="font-family:Arial;font-size: 8px;color:gray;text-align:center">
							<cfset stLogo = CreateObject('component', request.a_str_component_content).GetCompanyLogoImgPath(companykey = session.stSecurityContext.mycompanykey ) />

							<cfif stLogo.result>
								<cfoutput >
								<img src="http://#cgi.HTTP_HOST#/tools/img/show_company_logo.cfm?entrykey=#session.stSecurityContext.mycompanykey#" height="30px" alt="Logo" align="absmiddle" valign="middle" />
								</cfoutput>
								<br />
							</cfif>

						Created by openteamware | <cfoutput>#DateFormat( Now(), 'dd.mm.yy' )# #TimeFormat( Now(), 'HH:mm' )#</cfoutput>

						</div>
					</cfdocumentitem>
				<cfoutput>#sReturn#</cfoutput>
				</cfdocument>

				<cfheader name="content-disposition" value="attachment; filename=""Followups.pdf"""/>

				<cfcontent file="/tmp/output.pdf" reset="true" type="application/pdf">

			</cfcase>
			<cfdefaultcase>
				<!--- do nothing --->
			</cfdefaultcase>
		</cfswitch>

		<cfset variables.a_tc_count_runtime_fw = GetTickCount() - a_tc_count_runtime_fw />

		<cfreturn Trim(sReturn) />
	</cffunction>

	<cffunction access="public" name="ExtractContentbyID" returntype="string" output="false"
			hint="Get from the whole page content just a certain part by the content ID (div ID). ONLY recommended for printing etc as the whole page is rendered">
		<cfargument name="sPageContent" type="string" required="true" hint="The rendered page content" />
		<cfargument name="sContentID" type="string" required="true" hint="ID of the DIV holding the content to extract" />

		<cfset local.stFind = ReFindNoCase( '<div id="' & arguments.sContentID & '">', sPageContent, 1, true ) />

		<!--- TODO: migrate to tagsoup --->

		<!--- QUICK HACK: replace all &nbsp etc ... --->
		<cfset local.sParseContent = ReplaceNoCase( arguments.sPageContent, '&', '', 'ALL' ) />

		<cfset local.xFile = XMLParse( local.sParseContent ) />

		<!--- find right div --->
		<cfset local.xContent = XMLSearch( local.xFile, '//div[@id=''#arguments.sContentID#'']') />

		<!--- remove other stuff --->
		<cfset local.sContent = trim( ToString( local.xContent[1] ) ) />

		<cfsavecontent variable="local.sContent"><cfoutput>#local.sContent#</cfoutput></cfsavecontent>

		<cfreturn local.sContent />

	</cffunction>

	<cffunction access="public" name="IsInPopupMenuMode" output="false" returntype="boolean"
			hint="is in popup mode?">

		<cfreturn (CompareNoCase(request.a_struct_current_service_action.type,  'popup') IS 0) />

	</cffunction>

	<cffunction access="private" name="GenerateHTMLHeaderContent" output="false" returntype="string">
		<cfargument name="pagetitle" type="string" default="" required="false" hint="name of page">
		<cfargument name="servicekey" type="string" required="true" hint="entrykey of current service">
		<cfargument name="currenaction" type="string" required="false" default="" hint="name of current action">

		<cfset var sReturn = '' />

		<cfsavecontent variable="sReturn">
			<cfinclude template="utils/inc_create_html_head.cfm">
		</cfsavecontent>

		<cfreturn sReturn />
	</cffunction>

	<cffunction access="private" name="SetDefaultUrlAction" output="false" returntype="string"
			hint="check if an action has been set and if not, do it. return the action name as string">
		<cfargument name="defaultaction" type="string" required="true" hint="name of default action">

		<cfset var a_str_action = '' />

		<cfif NOT StructKeyExists(url, 'action') OR (Len(url.action) IS 0)>
			<cfset url.action = arguments.defaultaction />
		</cfif>

		<cfset a_str_action = url.action />

		<cfreturn a_str_action />
	</cffunction>

	<cffunction access="private" name="GenerateHTMLEndTags" output="false" returntype="string">
		<cfreturn '</body></html>' />
	</cffunction>

	<cffunction access="public" name="CallJavaScriptsInclude" output="false" returntype="string"
		hint="include the needed javascripts ...">
		<cfargument name="currentaction" type="string" required="false" default="" hint="name of current action">
		<cfset var sReturn = '' />

		<cfsavecontent variable="sReturn">
			<cfinclude template="utils/inc_js.cfm">
		</cfsavecontent>

		<cfreturn sReturn />
	</cffunction>

	<cffunction access="public" name="GenerateCustomHTMLHeader" output="false" returntype="string"
			hint="add custom html header content ...">
		<cfset var sReturn = '' />

		<cfsavecontent variable="sReturn">
			<cfinclude template="utils/inc_custom_html_header.cfm">
		</cfsavecontent>

		<cfreturn sReturn />
	</cffunction>

	<cffunction access="public" name="GeneratePageBodyTag" output="false" returntype="string"
			hint="generate the body tag of the html file">
		<cfset var sReturn = '' />

		<cfsavecontent variable="sReturn">
			<cfinclude template="utils/inc_generate_body_tag.cfm">
		</cfsavecontent>

		<cfreturn sReturn />
	</cffunction>

	<cffunction access="public" name="GenerateMainMenuBar" output="false" returntype="string"
			hint="Generate the main menu bar on top">
		<cfargument name="servicekey" type="string" required="false" default=""
			hint="entrykey of the current service">

		<cfset var sReturn = '' />

		<cfsavecontent variable="sReturn">
			<cfinclude template="utils/inc_generate_main_menu_bar.cfm">
		</cfsavecontent>

		<cfreturn sReturn />
	</cffunction>

	<cffunction access="public" name="GeneratePageOutput" output="false" returntype="string"
			hint="Generate the html output of the called action">

		<cfset var sReturn = '' />

		<cfsavecontent variable="sReturn">
			<cfinclude template="utils/inc_generate_switch_file_output.cfm">
		</cfsavecontent>

		<cfreturn sReturn />
	</cffunction>

</cfcomponent>