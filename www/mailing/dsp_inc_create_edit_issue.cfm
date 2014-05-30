<!--- //

	Module:		Newsletter
	Description:Create or edit an issue
	

// --->


<cfsavecontent variable="sJS">
	<!-- include the editor -->
	<script type="text/javascript" src="/common/js/fckeditor_current/fckeditor.js"></script>
</cfsavecontent>

<cfhtmlhead text="#sJS#" />


<cfparam name="CreateEditIssue.Action" type="string" default="Create">
<cfparam name="CreateEditIssue.Query" type="query" default="#QueryNew('entrykey,body_html,body_text,issue_name,listkey,dt_send,description,approved,autogenerate_text_version,subject,attachmentkeys')#">

<!--- entrykey holding the template key (an old issue ...) --->
<cfparam name="CreateEditIssue.TemplateKey" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>
<cfset q_select_profile = a_cmp_nl.GetNewsletterProfile(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, entrykey = url.listkey)>

<!--- new item? set default properties --->
<cfif CreateEditIssue.Action IS 'create'>
	<cfset tmp = QueryAddRow(CreateEditIssue.Query, 1) />
	
	<cfset tmp = QuerySetCell(CreateEditIssue.Query, 'entrykey', CreateUUID(), 1) />
	<cfset tmp = QuerySetCell(CreateEditIssue.Query, 'listkey', url.listkey, 1) />
	<cfset tmp = QuerySetCell(CreateEditIssue.Query, 'dt_send', Now(), 1) />
	<cfset tmp = QuerySetCell(CreateEditIssue.Query, 'approved', 0, 1) />
	<cfset tmp = QuerySetCell(CreateEditIssue.Query, 'autogenerate_text_version', 1, 1) />
	
	<!--- add default header/footer ... --->	
	<cfset a_str_html_body = '' />
	
	<cfif Len(trim(q_select_profile.default_header)) GT 0>
		<cfset a_str_html_body = q_select_profile.default_header & '<p></p>' />
	</cfif>
	
	<cfif Len(trim(q_select_profile.default_footer)) GT 0>
		<cfset a_str_html_body = a_str_html_body & '<p></p>' & q_select_profile.default_footer />
	</cfif>	
	
	<cfif Len(CreateEditIssue.TemplateKey) GT 0>
		<!--- try to load html body of old version --->
		<cfset q_select_template_issue = a_cmp_nl.GetIssue(securitycontext = request.stSecurityContext,
							usersettings = request.stUserSettings,
							entrykey = CreateEditIssue.TemplateKey) />
		
		<cfif q_select_template_issue.recordcount IS 1>
			<cfset a_str_html_body = q_select_template_issue.body_html />
		</cfif>
		
	</cfif>
	
	<cfset tmp = QuerySetCell(CreateEditIssue.Query, 'body_html', a_str_html_body, 1) />
	 
</cfif>

<cfset tmp = SetHeaderTopInfoString(q_select_profile.profile_name) />

<form action="act_save_issue.cfm" method="post" name="formsaveissue">

<cfsavecontent variable="a_str_content">

<cfoutput query="CreateEditIssue.Query">
<input type="hidden" name="frmlistkey" value="#htmleditformat(CreateEditIssue.Query.listkey)#">
<input type="hidden" name="frmentrykey" value="#htmleditformat(CreateEditIssue.Query.entrykey)#">

		<table class="table_details table_edit_form">
		  <tr>
			<td class="field_name">
				#GetLangVal('cm_wd_name')#:
			</td>
			<td>
				<input type="text" name="frmissue_name" value="#htmleditformat(CreateEditIssue.Query.issue_name)#" size="50">
			</td>
			<td class="addinfotext">
				#GetLangVal('nl_ph_name_saved_hint')#
			</td>
		  </tr>
		  <tr>
			<td class="field_name">
				#GetLangVal('cm_wd_description')#:
			</td>
			<td>
				<input type="text" name="frmdescription" value="#htmleditformat(CreateEditIssue.Query.description)#" size="50">
			</td>
		  </tr>		  
		  <tr>
			<td class="field_name">
				#GetLangVal('nl_ph_time_2_send')#:
			</td>
			<td>
				<input readonly="" type="text" size="10" name="frm_date_2send_date" value="#DateFormat(CreateEditIssue.Query.dt_send, request.a_str_default_js_dt_format)#">
				<a onClick="cal1.select(document.formsaveissue.frm_date_2send_date,'anchor1','#request.a_str_default_js_dt_format#'); return false;" href="##" id="anchor1"><img alt="#GetLangVal('cal_ph_left_nav_select')#" src="/images/si/calendar.png" class="si_img" /></a>
				
				<select name="frm_date_2send_time">
					<cfloop from="0" to="23" index="ii">
						<option #WriteSelectedElement(Hour(CreateEditIssue.Query.dt_send), ii)# value="#ii#:00">#ii#:00</option>
					</cfloop>
				</select>
				
			</td>
			<td class="addinfotext">
				#GetLangVal('nl_ph_time_2_send_hint')#
			</td>
		  </tr>
		 </table>

</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal( 'cm_wd_data' ) & ' (' & GetLangVal( 'cm_wd_profile' ) & ': ' & trim(q_select_profile.profile_name) & ')', '', a_str_content)#</cfoutput>

<script type="text/javascript" >
	var cal1 = new CalendarPopup();
</script>

<cfsavecontent variable="a_str_content">
<cfoutput query="CreateEditIssue.Query">
<table class="table_details table_edit_form">
		  <tr>
			<td class="field_name">
				#GetLangVal('mail_wd_subject')#:
			</td>
			<td>
				<input type="text" name="frmsubject" size="50" value="#htmleditformat(CreateEditIssue.Query.subject)#">
			</td>
			<td class="addinfotext" align="left">
			</td>
		  </tr>
  <tr>
    <td class="field_name">
		#GetLangVal('cm_wd_text')#:
	</td>
    <td colspan="2">
	
	<cfif q_select_profile.default_format IS 'html'>
		
		
	<cfset tmp = StartNewTabNavigation() />
	<cfset a_str_formatted_msg = AddTabNavigationItem( 'Formatierte Nachricht' ,  '', '') />
	<cfset a_str_text_msg = AddTabNavigationItem( 'Text' , '' , '') /> 

	#BuildTabNavigation('', false)#
	
	<div id="#a_str_formatted_msg#" class="b_all">
		
		<cfscript>
			fckEditor = application.components.cmp_fckeditor;
			
			fckEditor.instanceName	= "frmbody_html";
			fckEditor.value			=  CreateEditIssue.Query.body_html;
			fckEditor.width			= '100%';
			fckEditor.height		= 650;
			fckEditor.toolbarSet	= 'Default';
			fckEditor.create(); // create the editor.
		</cfscript>
		
	</div>
	<div id="#a_str_text_msg#" class="b_all" style="padding:12px;">

		<input type="checkbox" name="frmautogenerate_text_version" value="1" class="noborder" #WriteCheckedElement(autogenerate_text_version, '1')# /> Text-Version automatisch generieren
		<br /><br />
		<textarea name="frmbody_text" cols="74" rows="25" style="width:500px;">#htmleditformat(CreateEditIssue.Query.body_text)#</textarea>
		
	</div>

	<cfelse>	
		<textarea name="frmbody_text" cols="74" rows="25">#htmleditformat(CreateEditIssue.Query.body_text)#</textarea>
	</cfif>
	</td>
  </tr>
  <tr>
  	<td></td>
	<td colspan="2">
		<a href="javascript:ShowVariables();">#si_img('database_refresh')# #GetLangVal('nl_ph_insert_variable')#</a>
	</td>
  </tr>
  <tr id="id_tr_variables" style="display:none; ">
  	<td></td>
	<td class="mischeader" colspan="2">
		<b>#GetLangVal('cm_wd_common')#</b>
		<ul>
			<li><a href="javascript:InsertVariable('NOW');">#GetLangVal('nl_ph_field_current_time')#</a></li>
			<li><a href="javascript:InsertVariable('UNSUBSCRIBE_LINK');">#GetLangVal('nl_ph_field_unsubscribe_link')#</a></li>
			<li><a href="javascript:InsertVariable('SALUTATION');">#GetLangVal('nl_ph_field_salutation')#</a></li>
		</ul>
		
		<b>#GetLangVal('nl_ph_field_crm_fields')#</b>
		<ul>
			<li><a href="javascript:InsertVariable('DB_SURNAME');">#GetLangVal('adrb_wd_surname')#</a></li>
			<li><a href="javascript:InsertVariable('DB_FIRSTNAME');">#GetLangVal('adrb_wd_firstname')#</a></li>
			<li><a href="javascript:InsertVariable('DB_TITLE');">#GetLangVal('adrb_wd_title')#</a></li>
			<li><a href="javascript:InsertVariable('DB_EMAIL_PRIM');">#GetLangVal('adrb_wd_email')#</a></li>
			<li><a href="javascript:InsertVariable('DB_B_CITY');">#GetLangVal('adrb_wd_city')#</a></li>
			<li><a href="javascript:InsertVariable('DB_B_COUNTRY');">#GetLangVal('adrb_wd_country')#</a></li>
			
			
			
		</ul>
	</td>
  </tr>
  <tr>
  	 <td class="field_name">
		#GetLangVal('mail_wd_attachments')#
		<input type="hidden" name="frmattachmentkeys" value="" />
	</td>
	<td>
		<a href="##" onclick="SelectFilesFromStorage();return false;">#si_img('folder')# #GetLangVal('nl_ph_select_from_storage')#</a>
	</td>
  </tr>	
	<cfif Len(CreateEditIssue.Query.attachmentkeys) GT 0>
	<tr>
		<td></td>
		<td>
		
		
			
			<cfloop list="#CreateEditIssue.Query.attachmentkeys#" index="a_Str_attachment">
				
				<cfinvoke   
					component = "#application.components.cmp_storage#"   
					method = "GetFileInformation"   
					returnVariable = "a_struct_file_info"   
					entrykey = "#a_Str_attachment#"
					securitycontext="#request.stSecurityContext#"
					usersettings="#request.stUserSettings#"
					download=false></cfinvoke>		
					
				<cfset q_query_file = a_struct_file_info.q_select_file_info />
					
				<input type="checkbox" name="frmattachmentkeys" value="#a_Str_attachment#" class="noborder" checked /> #htmleditformat( q_query_file.filename )# #ByteConvert( q_query_file.filesize )#
				<br />
			</cfloop>
			
		
		</td>
	</tr>
	</cfif>
	<tr style="display:none; " id="id_div_tr_storage">
  	<td>
		
	</td>
	<td colspan="2" style="height:300px;overflow:scroll;" id="id_div_storage">
	</td>
  </tr>
</table>

</cfoutput>

</cfsavecontent>

<cfsavecontent variable="a_str_btn">
	<cfoutput>
	<input type="submit" class="btn btn-primary" value="#GetLangVal('cm_wd_save_button_caption')#" name="frmsubmit" />
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_email'), a_str_btn, a_str_content)#</cfoutput>

</form>

<script type="text/javascript">
	var a_cmp_http;
	function ShowVariables()
		{
		var obj1;
		obj1 = findObj('id_tr_variables');
		obj1.style.display = '';
		}
	function InsertVariable(s)
		{
		var oEditor = FCKeditorAPI.GetInstance('frmbody_html');

		// Insert the desired HTML.
		oEditor.InsertHtml('%' + s + '%') ;
		}
	function SelectFilesFromStorage() {
		$('#id_div_tr_storage').show();
		$('#id_div_storage#').html( a_str_loading_status_img );
		
		$.get("show_select_attachments.cfm", function(data){
		  	$('#id_div_storage').html( data);
			});
		}	
		
	function LoadAddAttFolderContent(sender,entrykey) {
		var a_sender = $(sender).parent();
		
		$('.temp_list_files', a_sender).hide();
		$.get("/storage/",
			  { directorykey: entrykey, action: 'SimpleSelectAttLoadFilesOfDirectory', input_name: 'frmattachmentkeys'},
			  function(data){
			    a_sender.append(data);
			  }
			);
		
		return false;
		
	}			
</script>

