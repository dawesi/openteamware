<!--- //

	Module:		Mailings
	Description:Create / Edit a profile
	

// --->

<cfparam name="CreateEditNLProfile.action" type="string" default="create">
<cfparam name="CreateEditNLProfile.Query" type="query" default="#querynew('replyto,lang,CONFIRMATION_URL_SUBSCRIBED,CONFIRMATION_URL_unSUBSCRIBED,entrykey,profile_name,listtype,sender_name,sender_address,name,description,crm_filter_key,default_header,default_footer,langno,test_email_addresses')#">

<!--- set data --->
<cfif CreateEditNLProfile.action IS 'create'>
	
	<cfset tmp = QueryAddRow(CreateEditNLProfile.Query, 1)>
	<cfset tmp = QuerySetCell(CreateEditNLProfile.Query, 'entrykey', createUUID(), 1)>
	<cfset tmp = QuerySetCell(CreateEditNLProfile.Query, 'listtype', 0, 1)>
	<cfset tmp = QuerySetCell(CreateEditNLProfile.Query, 'lang', 0, 1)>
	<cfset tmp = QuerySetCell(CreateEditNLProfile.Query, 'test_email_addresses', request.stSecurityContext.myusername)>
	
</cfif>

<form action="act_update_profile.cfm" method="post">

<cfoutput query="CreateEditNLProfile.Query">

<input type="hidden" name="frmentrykey" value="#CreateEditNLProfile.Query.entrykey#">
<div style="padding:4px;">
<img src="/images/si/exclamation.png" class="si_img" /> #GetLangVal('cm_ph_please_do_not_forget_saving_changes')#
</div>

<table class="table_details table_edit_form">
  <tr>
    <td class="field_name">
		#GetLangVal('cm_wd_name')#:
	</td>
    <td>
		<input type="text" name="frmname" value="#htmleditformat(CreateEditNLProfile.Query.profile_name)#" size="25">
	</td>
  </tr>
  <tr>
    <td class="field_name">
		#GetLangVal('cm_wd_description')#:
	</td>
    <td>
		<input type="text" name="frmdescription" value="#htmleditformat(CreateEditNLProfile.Query.description)#" size="25">
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		#GetLangVal('cm_wd_language')#
	</td>
	<td>
		<select name="frmlanguage">
			<option value="0" #writeselectedelement(CreateEditNLProfile.Query.lang, 0)#>DE</option>
			<option value="1" #writeselectedelement(CreateEditNLProfile.Query.lang, 1)#>EN</option>
			<option value="2" #writeselectedelement(CreateEditNLProfile.Query.lang, 2)#>CZ</option>
			<option value="3" #writeselectedelement(CreateEditNLProfile.Query.lang, 3)#>SK</option>
			<option value="4" #writeselectedelement(CreateEditNLProfile.Query.lang, 4)#>PL</option>
			<option value="5" #writeselectedelement(CreateEditNLProfile.Query.lang, 5)#>RO</option>
		</select>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		#GetLangVal('nl_ph_listtype')#:
	</td>
	<td>
		<!---<select name="">
			<option #WriteSelectedElement(CreateEditNLProfile.Query.listtype, 0)# value="0">#GetLangVal('nl_ph_listtype_dynamic')#</option>
			<option #WriteSelectedElement(CreateEditNLProfile.Query.listtype, 2)# value="2">#GetLangVal('nl_ph_listtype_select_addressbook')#</option>			
			<option #WriteSelectedElement(CreateEditNLProfile.Query.listtype, 1)# value="1">#GetLangVal('nl_ph_listtype_email_only')#</option>
		</select>--->
		
		<input onClick="SetListType(this.value);" #writecheckedelement(CreateEditNLProfile.Query.listtype, 0)# class="noborder" type="radio" name="frm_type" value="0"> #GetLangVal('nl_ph_listtype_dynamic')#
		<br><br>
		<input onClick="SetListType(this.value);" #writecheckedelement(CreateEditNLProfile.Query.listtype, 2)# class="noborder" type="radio" name="frm_type" value="2"> #GetLangVal('nl_ph_listtype_select_addressbook')#
		<!---<br><br>
		<input disabled onClick="SetListType(this.value);" #writecheckedelement(CreateEditNLProfile.Query.listtype, 1)# class="noborder" type="radio" name="frm_type" value="1"> #GetLangVal('nl_ph_listtype_email_only')#--->
	</td>
  </tr>
  


	<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>	
	
  <tr id="id_tr_crm_filter">
  	<td class="field_name">
		#GetLangVal('crm_ph_filter')#:
	</td>
	<td>
		<select name="frmfilterkey">
			<option value="">#GetLangVal('nl_ph_filter_all')#</option>
			<cfloop query="q_select_all_filters">
				<option #writeselectedelement(CreateEditNLProfile.Query.crm_filter_key, q_select_all_filters.entrykey)# value="#q_select_all_filters.entrykey#">#htmleditformat(q_select_all_filters.viewname)#</option>
			</cfloop>
		</select>
		&nbsp;
		[ <a href="/addressbook/?action=advancedsearch" target="_blank"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('crm_ph_filter')# #GetLangVal('cm_wd_edit')#</a> ]
	</td>
  </tr>  
  <tr>
  	<td class="field_name">
		#GetLangVal('nl_ph_sender_name')#:
	</td>
	<td>
		<input type="text" name="frm_sender_name" value="#htmleditformat(CreateEditNLProfile.Query.sender_name)#" size="25">
		<br /> 
		<font class="addinfotext">#GetLangVal('nl_ph_sender_name_hint')#</font>
	</td>
  </tr>
  </tr>
  
  		<cfinclude template="../email/queries/q_select_all_pop3_data.cfm">
  
		<cfinvoke component="/components/email/cmp_accounts" method="GetAliasAddresses" returnvariable="q_select_alias_addresses">
			<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
		</cfinvoke>	
		  
  <tr>
  	<td class="field_name">
		#GetLangVal('nl_ph_sender_address')#:
	</td>
	<td>
		<select name="frm_sender_address">
			<cfloop query="q_select_all_pop3_data">
				<option #writeselectedelement(CreateEditNLProfile.Query.sender_address, q_select_all_pop3_data.emailadr)# value="#q_select_all_pop3_data.emailadr#">#q_select_all_pop3_data.emailadr#</option>
			</cfloop>
			<cfloop query="q_select_alias_addresses">
				<option #writeselectedelement(CreateEditNLProfile.Query.sender_address, q_select_alias_addresses.aliasaddress)# value="#q_select_alias_addresses.aliasaddress#">#q_select_alias_addresses.aliasaddress#</option>
			</cfloop>
		</select>

		<br /> 
		<font class="addinfotext">#GetLangVal('nl_ph_sender_address_hint')#</font>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		#GetLangVal('nl_ph_reply_address')#:
	</td>
	<td>
		<input type="text" name="frmreplyto" value="#htmleditformat(CreateEditNLProfile.Query.replyto)#" size="25">
		<br /> 
		<font class="addinfotext">#GetLangVal('nl_ph_replyto_hint')#</font>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		#GetLangVal('nl_ph_test_addresses')#:
	</td>
	<td>
		<input type="text" name="frm_test_addresses" value="#htmleditformat(CreateEditNLProfile.Query.test_email_addresses)#" size="25">
		<br /> 
		<font class="addinfotext">#GetLangVal('nl_ph_test_addresses_hint')#</font>
	</td>
  </tr>
  <tr style="display:none; ">
    <td class="field_name">
		#GetLangVal('nl_wd_customize')#:
	</td>
    <td>
		<input type="checkbox" name="frm_customize" class="noborder" value="1" checked>
	</td>
  </tr>
  <tr style="display:none; ">
    <td class="field_name">
		#GetLangVal('nl_ph_subscription_management')#:
	</td>
    <td>
		<input type="checkbox" name="frm_subscription_management" class="noborder" value="1" checked>
	</td>
  </tr>
  <tr style="display:none; ">
    <td class="field_name">
		#GetLangVal('nl_ph_open_tracking')#:
	</td>
    <td>
		<input type="checkbox" name="frm_open_tracking" class="noborder" value="1" checked>
	</td>
  </tr>  
  <tr>
    <td class="field_name">
		#GetLangVal('cm_wd_format')#:
	</td>
    <td>
		<select name="frmdefaultformat">
			<option value="html">HTML</option>
		</select>
	</td>
  </tr>
  <tr style="display:none; ">
  	<td class="field_name">
		Medien:
	</td>
	<td>
		E-Mail
	</td>
  </tr>
  <tr style="display:none; ">
  	<td class="field_name">
		#GetLangVal('nl_ph_url_confirm_subscriber')#:
	</td>
	<td>
		<input type="text" name="frm_confirmationurl_subscribe" value="#CreateEditNLProfile.Query.confirmation_url_subscribed#" size="25">
	</td>
  </tr>    
  <tr>
  	<td class="field_name">
		#GetLangVal('nl_ph_url_confirm_unsubscriber')#:
	</td>
	<td>
		<input type="text" name="frm_confirmationurl_unsubscribe" value="#CreateEditNLProfile.Query.confirmation_url_unsubscribed#" size="25">
		&nbsp;
		<font class="addinfotext">#GetLangVal('nl_ph_unsubscribe_page')#</font>
	</td>
  </tr>
  <tr>
  	<td class="field_name">#GetLangVal('nl_ph_default_header')#:</td>
	<td>
		<div class="b_all">
		<cfscript>
			fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
			fckEditor.instanceName	= "frmheader";
			fckEditor.value			=  CreateEditNLProfile.Query.default_header;
			fckEditor.width			= 650;
			fckEditor.height		= 120;
			fckEditor.toolbarSet	= 'INBOX_Default';
			fckEditor.create(); // create the editor.
		</cfscript>
		</div>
	</td>
  </tr>
  <tr>
  	<td class="field_name">#GetLangVal('nl_ph_default_footer')#:</td>
	<td>
		<div class="b_all">
		<cfscript>
			fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
			fckEditor.instanceName	= "frmfooter";
			fckEditor.value			=  CreateEditNLProfile.Query.default_footer;
			fckEditor.width			= 650;
			fckEditor.height		= 120;
			fckEditor.toolbarSet	= 'INBOX_Default';
			fckEditor.create(); // create the editor.
		</cfscript>
		</div>
	</td>
  </tr>
  <tr>
    <td class="field_name">&nbsp;</td>
    <td>
		<input type="submit" value="#GetLangVal('cm_wd_save_button_caption')#" name="frmsubmit" class="btn btn-primary" />
	</td>
  </tr>
</table>
</cfoutput>
</form>

<script type="text/javascript">
	SetListType(<cfoutput>#CreateEditNLProfile.Query.listtype#</cfoutput>);
</script>

