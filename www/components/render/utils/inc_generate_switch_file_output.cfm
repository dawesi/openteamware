<!--- //

	Module:		Render
	Function:	GeneratePageOutput
	Description:Generate the page output

// --->

<!--- url parameter holding error number (if any) --->
<cfparam name="url.ibxerrorno" type="string" default="0">

<!--- additional error message (optional) ... --->
<cfparam name="url.ibxerrormsg" type="string" default="">

<!--- url parameter for showing an info message ... --->
<cfparam name="url.otwinfono" type="string" default="0">

<!--- create default parameters if they do not exist? --->
<cfif StructKeyExists(request.a_struct_current_service_action, 'parameters') AND
	  ArrayLen(request.a_struct_current_service_action.parameters) GT 0>
	<cfinclude template="inc_set_default_parameters.cfm">
</cfif>

<!--- put together the file directory --->
<cfset variables.a_str_action_file_directory = request.a_str_base_include_path />

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
	<cfset SetHeaderTopInfoString(a_str_action_page_title) />
</cfif>

<!--- did an error occur? fire an error message? --->
<cfif val(url.ibxerrorno) GT 0>
	<cfset  AddJSToExecuteAfterPageLoad('OpenErrorMessagePopup(''' & url.ibxerrorno & ''',''' & JsStringFormatEx(url.ibxerrormsg) & ''');', '') />
</cfif>


<cfif Val(url.otwinfono) GT 0>
	<cfset AddJSToExecuteAfterPageLoad('OpenInfoMessagePopup(''' & url.otwinfono & ''');', '') />
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

<div class="container-fluid">
<!--- <div class="row">
		 <div class="12"> --->

		<cftry>
				<cfinclude template="#variables.a_str_action_file_directory##request.a_struct_current_service_action.template#">
				<cfcatch type="any">

					<!--- in case of a special errorcode, simply abort the page processing, otherwise rethrow the exception
							to call the ordinary error handling procedure ... --->

					<cfif cfcatch.ErrorCode IS 'abortpageprocessing'>
						<!--- simply abort it --->
						<cfexit method="exittemplate">
					<cfelse>
						<cfrethrow>
					</cfif>

				</cfcatch>
			</cftry>

	<!--- </div>

</div> --->
</div>

<div class="bottom_info_box" id="id_bottom_info"></div>

<!--- GA tracking --->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-53251857-1', 'auto');
  ga('send', 'pageview');

</script>
