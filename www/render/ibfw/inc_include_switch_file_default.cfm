<!--- //

	Module:        Framework
	Description:   Include given file
	

// --->

<!--- url parameter holding error number (if any) --->
<cfparam name="url.ibxerrorno" type="string" default="0">

<!--- additional error message (optional) ... --->
<cfparam name="url.ibxerrormsg" type="string" default="">

<!--- create default parameters if they do not exist? --->
<cfif StructKeyExists(request.a_struct_current_service_action, 'parameters') AND
	  ArrayLen(request.a_struct_current_service_action.parameters) GT 0>
	<cfinclude template="inc_set_default_parameters.cfm">
</cfif>

<!--- put together the file directory --->
<cfset variables.a_str_action_file_directory = request.a_str_base_include_path>
		
<cfif Len(request.a_struct_current_service_action.directory) GT 0>
	<cfset variables.a_str_action_file_directory = variables.a_str_action_file_directory & request.a_struct_current_service_action.directory&request.a_str_dir_separator />
</cfif>		

<!--- include inpage / action template ... and exit afterwards --->
<cfif ListFindNoCase('inpage,action', request.a_struct_current_service_action.type) GT 0>
	<cfinclude template="#variables.a_str_action_file_directory##request.a_struct_current_service_action.template#">
	<cfexit  method="exittemplate">	
</cfif>

<!--- page title given? --->
<cfif StructKeyExists(request.a_struct_current_service_action, 'title') AND
	  Len(request.a_struct_current_service_action.title) GT 0>
	
	<cfset a_str_action_page_title = request.a_struct_current_service_action.title />
	
	<cfif FindNoCase('%LANG_', a_str_action_page_title) IS 1>
		<cfset a_str_action_page_title = ReplaceNoCase(a_str_action_page_title, '%LANG_', '') />
		<cfset a_str_action_page_title = ReplaceNoCase(a_str_action_page_title, '%', '', 'ALL') />
		
		<cfset a_str_action_page_title = GetLangVal(a_str_action_page_title) />
	</cfif>
	
	<!--- set page title / header info string --->
	<cfset tmp = SetHeaderTopInfoString(a_str_action_page_title) />
</cfif>

<!--- did an error occur? fire an error message? --->
<cfif val(url.ibxerrorno) GT 0>
	<cfset tmp = AddJSToExecuteAfterPageLoad('OpenErrorMessagePopup(''' & url.ibxerrorno & ''',''' & JsStringFormatEx(url.ibxerrormsg) & ''');', '') />
</cfif>

<cfif request.a_struct_current_service_action.type IS 'popup'>
	<cfset url.showaspopup = 1 />
</cfif>

<!--- url defined exception? --->
<cfset a_bol_force_header = StructKeyExists(url, 'includeheader') AND (url.includeheader IS 1) />

<!--- popup and no left and top header? --->
<cfset a_bol_is_popup_form = StructKeyExists(url, 'showaspopup') AND (url.showaspopup IS 1) />

<!--- printmode? --->
<cfset a_bol_in_printmode = StructKeyExists(url, 'printmode') AND (url.printmode) />

<cfif a_bol_in_printmode>
	<cfset request.a_struct_current_service_action.attributes = ListAppend(request.a_struct_current_service_action.attributes, 'fullwindow') />
</cfif>

<cfif a_bol_is_popup_form>
	<cfset request.a_struct_current_service_action.attributes = ListPrepend(request.a_struct_current_service_action.attributes,'noleftinclude') />
	<cfset request.a_struct_current_service_action.attributes = ListPrepend(request.a_struct_current_service_action.attributes,'noheader') />
</cfif>

<cfif (ListFindNoCase(request.a_struct_current_service_action.attributes, 'fullwindow') GT 0) AND NOT (a_bol_force_header)>

	<!--- display a full window with one template and ignore all other items --->
	
	<cfset variables.a_str_action_file_directory = request.a_str_base_include_path />
		
	<cfif Len(request.a_struct_current_service_action.directory) GT 0>
		<cfset variables.a_str_action_file_directory = variables.a_str_action_file_directory & request.a_struct_current_service_action.directory&request.a_str_dir_separator />
	</cfif>			
			
	<cfif NOT a_bol_in_printmode>
		<!--- do not display DIV in printmode --->
		<div id="id_div_main_fullwindow" class="div_main_fullwindow">
	</cfif>
	
	<cfinclude template="#variables.a_str_action_file_directory##request.a_struct_current_service_action.template#">
	
	<cfif NOT a_bol_in_printmode>
		</div>
	</cfif>
	
	<cfexit method="exittemplate">
	
</cfif>

<!--- if "nopadding" attribute is set, disable padding ... --->
<div id="iddivmainbody" class="div_main_box">
	
		<!--- // left include // --->
		<cfset a_bol_leftinclude_done = false />

		<cfif (Len(request.a_str_left_include) GT 0) AND (ListFindNoCase(request.a_struct_current_service_action.attributes,'noleftinclude') IS 0)>

			<!--- yes, include ... --->
			<cfset a_bol_leftinclude_done = true />
		
			<div id="iddivmenuleft" class="div_left_nav_outer">
				<div id="iddivmenuleftinner" class="div_left_nav_inner">
					
				<cfinclude template="#request.a_str_left_include#">
					
				</div>
			</div>
		</cfif>

		<!--- // check the class name to use ... // --->
		<cfif a_bol_leftinclude_done>
			<cfset variables.a_str_classname_maincontent = 'div_main_content_outer' />
		<cfelse>
			<cfset variables.a_str_classname_maincontent = 'div_main_content_outer_standalone' />
		</cfif>
		
		<div id="iddivmaincontent" class="<cfoutput>#variables.a_str_classname_maincontent#</cfoutput>">
			
			<div id="iddivmaincontent_innerdiv" class="div_main_content_inner" <cfif ListFindNoCase(request.a_struct_current_service_action.attributes, 'nopadding') GT 0>style="padding:0px;"</cfif>>
							
				<cfinclude template="#variables.a_str_action_file_directory##request.a_struct_current_service_action.template#">
		
			</div>
		</div>
</div>

<cfset a_str_show_left_bar = GetUserPrefPerson('display_interface', 'displayleftnavbar', '1', '', false) />

<cfif a_str_show_left_bar IS 0>
	<cfset tmp = AddJSToExecuteAfterPageLoad('HideLeftNavSide(false, false)', '') />
</cfif>
	

