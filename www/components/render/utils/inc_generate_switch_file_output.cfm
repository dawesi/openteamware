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
	<cfset tmp = SetHeaderTopInfoString(a_str_action_page_title) />
</cfif>

<!--- did an error occur? fire an error message? --->
<cfif val(url.ibxerrorno) GT 0>
	<cfset tmp = AddJSToExecuteAfterPageLoad('OpenErrorMessagePopup(''' & url.ibxerrorno & ''',''' & JsStringFormatEx(url.ibxerrormsg) & ''');', '') />
</cfif>


<cfif Val(url.otwinfono) GT 0>
	<cfset tmp = AddJSToExecuteAfterPageLoad('OpenInfoMessagePopup(''' & url.otwinfono & ''');', '') />
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

<div id="iddivmainbody" class="div_main_box">
<table border="0" cellpadding="6" cellspacing="0" width="100%">
	<tr>
		<cfif Len( request.a_str_left_include ) GT 0>
		<td id="id_left_nav">
			
			<cfinclude template="#request.a_str_left_include#">
			
		</td>
		</cfif>
		<td id="id_content_main_box">
			
			
			
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
			
		</td>
		<!--- 
		<!--- advertisment --->
		<td valign="top" style="width:130px">
		<script type="text/javascript"><!--
google_ad_client = "pub-5279195474591127";
/* openTeamWare */
google_ad_slot = "0114813449";
google_ad_width = 120;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
		<!--- 	google ads --->
		</td> --->
	</tr>
</table>
</div>


<div class="bottom_info_box" id="id_bottom_info">
	Powered by <a href="http://www.openteamware.com/?source=prod_footer" target="_blank">openTeamWare</a>
</div>
