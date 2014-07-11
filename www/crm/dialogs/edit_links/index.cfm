<cfinclude template="/login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">


<!--- entrykey of source object --->
<cfparam name="url.entrykey" type="string" default="">

<!--- servicekey of source element --->
<cfparam name="url.servicekey" type="string" default="">

<!--- servicekey of destination element --->
<cfparam name="url.dest_servicekey" type="string" default="">

<cfif Len(url.dest_servicekey)  IS 0>
	<cfset url.dest_servicekey = url.servicekey>
</cfif>

<cfinvoke component="#application.components.cmp_tools#" method="GetElementLinksFromTo" returnvariable="q_select_links">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>


<!--- get the source name ... --->
<cfset a_str_source_name = ''>

<cfswitch expression="#url.servicekey#">
	<cfcase value="52227624-9DAA-05E9-0892A27198268072">
		<!--- ... --->
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_load_contact">
			<cfinvokeargument name="entrykey" value="#url.entrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>
		
		<cfset q_select_contact = a_struct_load_contact.q_select_contact>
		<cfset a_Str_source_name = q_select_contact.firstname & ' ' & q_select_contact.surname>
	</cfcase>
</cfswitch>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<cfinclude template="/common/js/inc_js.cfm">
	<cfinclude template="../../../render/inc_html_header.cfm">
	<title><cfoutput>#GetLangVal('crm_wd_contact_links')#</cfoutput></title>
	
	<script type="text/javascript">
		function SetProposalstring(s)
			{
			findObj('frm_conn_string').value = s;
			CloseOpenActionPopups();	
			}
	</script>	
</head>

<body class="body_popup">

<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_wd_contact_links') & ' (' & htmleditformat(a_Str_source_name) & ')')#</cfoutput>

		
		<cfif q_select_links.recordcount IS 0>
			<cfoutput>#GetLangVal('crm_ph_links_no_links_found')#</cfoutput>
		<cfelse>
		
			<table class="table table-hover">
			  <cfoutput query="q_select_links">
			  <tr>
				<td>
				
					<cfset a_str_source_link = ''>
					
					<cfswitch expression="#q_select_links.dest_servicekey#">
						<cfcase value="52227624-9DAA-05E9-0892A27198268072">
							<cfset a_str_source_link = '/addressbook/?action=ShowItem&entrykey=' & urlencodedformat(q_select_links.source_entrykey)>
						</cfcase>
					</cfswitch>
									
					<a href="#a_str_source_link#" target="_blank">#htmleditformat(q_select_links.source_name)#</a>
				</td>
				<td>
					<font style="color:blue; ">#q_select_links.connection_type#</font>
					
					<cfset a_str_dest_link = ''>
					
					<cfswitch expression="#q_select_links.dest_servicekey#">
						<cfcase value="52227624-9DAA-05E9-0892A27198268072">
							<cfset a_str_dest_link = '/addressbook/?action=ShowItem&entrykey=' & urlencodedformat(q_select_links.dest_entrykey)>
						</cfcase>
					</cfswitch>
					
					<a href="#a_str_dest_link#" target="_blank">#htmleditformat(q_select_links.dest_name)#</a>
				</td>
				<td>
					<cfif Len(q_select_links.comment) GT 0>
						(#htmleditformat(q_select_links.comment)#)
					</cfif>
				</td>
				<td>
					<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_delete_link.cfm?entrykey=#q_select_links.entrykey#"><img src="/images/email/img_trash_19x16.gif" border="0"/></a>
				</td>
			  </tr>
			  </cfoutput>
			</table>
			
		</cfif>


<br/>
	
<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_ph_create_new_link'))#</cfoutput>

	
		<form id="id_form_search" onSubmit="DoContactsSearch();return false;" style="margin:0px;" action="#">
		<table class="table table-hover">
		  <tr>
			<td width="200px;" align="right">
				<cfoutput>#GetLangVal('cm_wd_search')# (#GetLangVal('cm_wd_addressbook')#)</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmsearch" id="frmsearch" value="" size="20">
				
				<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn btn-primary">
			</td>
		  </tr>
		 </table>
		 </form>
		 
		 <div id="id_search_output"></div>
		 
		 <div id="id_add_link" style="display:none;padding:0px;padding-top:10px;">
		 
		 <form action="act_add_link.cfm" id="id_form_add_link" name="id_form_add_link" method="post" style="margin:0px; ">
		 	<input type="hidden" name="frm_source_entrykey" id="frm_source_entrykey" value="<cfoutput>#url.entrykey#</cfoutput>">
		 	<input type="hidden" name="frm_dest_entrykey" id="frm_dest_entrykey" value="">
			<input type="hidden" name="frm_source_name" id="frm_source_name" value="<cfoutput>#htmleditformat(a_Str_source_name)#</cfoutput>">
			<input type="hidden" name="frm_dest_name" id="frm_dest_name" value="">
			<input type="hidden" name="frm_source_servicekey" id="frm_source_servicekey" value="<cfoutput>#url.servicekey#</cfoutput>">
			<input type="hidden" name="frm_dest_servicekey" id="frm_dest_servicekey" value="<cfoutput>#url.dest_servicekey#</cfoutput>">
						
						
			<table class="table table_details">
			<tr>
				<td align="right" width="200px;">
					<cfoutput>#htmleditformat(a_Str_source_name)#</cfoutput>
				</td>
				<td>
					
					<a id="id_a_open_proposals" onClick="ShowHTMLActionPopup(this.id, 'id_div_connection_type_proposals');return false;"><input type="text" name="frm_conn_string" id="frm_conn_string" size="20" value="" style="width:200px;color:blue;"><img src="/images/misc/img_dropdownbox_btn.png" align="absmiddle" border="0" style="cursor:hand; "></a>
			
			
					<div class="div_action_popup" id="id_div_connection_type_proposals" style="display:none;padding:0px;">
					<ul>
								<cfset a_str_lang = GetLangVal('crm_ph_links_service_' & ReplaceNoCase(url.dest_servicekey, '-', '', 'ALL'))>
								
								<!--- default options ... depend on destination service --->
								<cfloop list="#a_str_lang#" delimiters="#chr(13)#" index="a_str_item">
									<cfoutput>
									<li>
										<a href="javascript:SetProposalstring('#JsStringFormat(a_str_item)#');">#htmleditformat(a_str_item)#</a>
									</li>
									</cfoutput>
								</cfloop>
					</ul>
					</div>
			
					&nbsp;
				
					<span id="id_td_dest_name"></span>
					</td>
				</tr>
			  <tr>
			  	<td align="right">
					<cfoutput>#GetLangVal('adm_wd_comment')#</cfoutput>
				</td>
				<td>
					<input type="text" name="frm_comment" size="20" style="width:200px; ">
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td>
					<input type="submit" class="btn btn-primary" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
				</td>
			  </tr>
			</table>
			
		 </form>
		 
		 </div>
		

<script type="text/javascript">
	var a_http_search;
	function DoContactsSearch()
		{
		var obj1 = findObj('frmsearch');
		var obj2 = findObj('id_search_output');
		var url = 'show_search_contacts.cfm?search=' + escape(obj1.value);
		
		obj2.innerHTML = '<p align="center"><img src="/images/img_bar_status_loading.gif" width="107" height="13" border="0"></p>';
		obj1.value = '';
		
		a_http_search = GetNewHTTPObject();
		CallHTTPGet(a_http_search, url, processReqDisplayContactsSearch);		
		}
		
	function processReqDisplayContactsSearch()
		{
		var obj1;
		if (a_http_search && (a_http_search.readyState == 4) && (a_http_search.status == 200))
			{							
			obj1 = findObj('id_search_output');							
			obj1.innerHTML = a_http_search.responseText;		
			}
		}
		
	function ConnectContact(entrykey, displayname)
		{
		var obj1 = findObj('id_search_output');
		var obj2 = findObj('id_add_link');
		var obj3 = findObj('frm_dest_entrykey');
		var obj4 = findObj('frm_dest_name');
		var obj5 = findObj('id_td_dest_name');
		
		obj1.style.display = 'none';
		obj2.style.display = '';
		obj3.value = entrykey;
		
		obj4.value = displayname;
		obj5.innerText = displayname;
		
		}		
</script>

</body>
</html>
