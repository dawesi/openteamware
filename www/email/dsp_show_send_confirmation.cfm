<!--- //

	Module:			E-Mail
	Action:			ShowSendConfirmation
	Description:	Show confirmation about sent email
					the meta information is loaded from a temp database ...
	

// --->

<cfparam name="url.entrykey" type="string">

<!--- check if we should send out an info mail ... --->
<cfset a_int_sendinfomail = GetUserPrefPerson('email.sm', 'sendinfomail', '1', '', false) />

<cfinvoke component="#application.components.cmp_email#" method="GetSentMessageInformation" returnvariable="q_select_tmp_sent_info">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset a_bol_is_signedmail = false />

<cfsavecontent variable="a_str_content">

<cfif (q_select_tmp_sent_info.sm_action IS 'a1_sign') AND
		(Len(q_select_tmp_sent_info.smjobkey) GT 0)>
	
	<div class="mischeader bb">
		<img align="absmiddle" src="/images/partner/img_a1_logo_small.gif" vspace="8" hspace="8" border="0" /> Diese Nachricht wurde digital mit der A1 - Signatur unterschrieben.
	</div>
	
</cfif>

<br /> 

<cfset a_str_text = GetLangVal('email_ph_confirmation_subject') />
		
<cfset a_str_text = ReplaceNoCase(a_str_text, '%SUBJECT%', '"' & htmleditformat(q_select_tmp_sent_info.subject) & '"') />
		
<div style="padding:10px; ">
	<img src="/images/si/accept.png" class="si_img" alt="" /> <b><cfoutput>#a_str_text#</cfoutput></b>
	
	<cfset a_str_text = GetLangVal('email_ph_confirmation_folder') />
		
	<!--- does a localized word exist for the destination folder? --->
	<cfquery name="q_select_friendly_foldername" dbtype="query">
	SELECT
		foldername
	FROM
		request.q_select_folders
	WHERE
		fullfoldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_tmp_sent_info.destinationfolder#">
	;
	</cfquery>
	
	<cfset a_str_destination_foldername = q_select_friendly_foldername.foldername />
	
	<!--- <br /><br />  
	  
	<cfset a_str_text = ReplaceNoCase(a_str_text, '%FOLDERNAME%', a_str_destination_foldername) />
	
	<img src="/images/space_1_1.gif" class="si_img" /><a target="_blank" href="default.cfm?action=ShowMailbox&Mailbox=<cfoutput>#urlencodedformat(q_select_tmp_sent_info.destinationfolder)#</cfoutput>"><cfoutput>#a_str_text#</cfoutput></a>.
	 --->		
</div>


<cfset a_str_text = GetLangVal('email_ph_confirmation_subject') />
<cfset a_str_text = ReplaceNoCase(a_str_text, '%SUBJECT%', htmleditformat(q_select_tmp_sent_info.subject)) />

<cfset stCRMFilter = StructNew() />

<cfset a_str_to = ListAppend(q_select_tmp_sent_info.ato, q_select_tmp_sent_info.cc) />
<cfset a_str_to = ListAppend(a_str_to, q_select_tmp_sent_info.bcc) />

<!--- replace everything but email addresses ... --->
<cfset a_str_to = ReReplaceNoCase(a_str_to, '"[^"]*"', '', 'ALL') />

<!--- add to temp filter all addresses ... --->
<cfloop list="#a_str_to#" delimiters="," index="a_str_item">
	
	<cfset a_str_email_adr = ExtractEmailAdr(a_str_item) />
	
	<cfif Len(a_str_email_adr) GT 0>
		
		<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
											connector = 1,
											operator = 0,
											internalfieldname = 'email_prim',
											comparevalue = a_str_email_adr) />
									
	</cfif>
</cfloop>

	
		
<!--- load now all contacts --->
<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.fieldstoselect = 'email_prim,entrykey,id,firstname,surname,company,email_adr'>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />
	
	<form action="../addressbook/default.cfm?action=QuickAddFromWebmail" method="POST" target="_blank" style="margin:0px;">
	
	<table class="table_overview">
		<!--- <tr>
			<td></td>
			<td colspan="2"><cfoutput>#GetLangVal('mail_ph_select_contacts_to_add_to_adrb')#</cfoutput></td>
		</tr> --->
	<tr class="tbl_overview_header">
		<td style="width:20px;">
		</td>
		<td>
			<cfoutput>#GetLangVal('email_wd_confirmation_address')# (#GetLangVal('mail_wd_recipient')#)</cfoutput>
		</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_crm')#</cfoutput>
			</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
		</td>
	</tr>
	
	<cfset a_int_add_address = 0 />
	
	<!--- loop through all recipients ... --->
	<cfloop list="#a_str_to#" delimiters="," index="a_str_item">
		<!--- extract every email address ... --->
		<cfset a_str_email = ExtractEmailAdr(a_str_item) />
		
		<cfquery name="q_select_item" dbtype="query">
		SELECT
			entrykey,firstname,surname,company
		FROM
			q_select_contacts
		WHERE
			(UPPER(email_prim) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_email)#">)
			OR
			(UPPER(email_adr) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_email)#">)
		;
		</cfquery>
		
		<cfif q_select_item.recordcount GT 0>
			<!--- update lastcontact ... --->
			<cfset stUpdate = StructNew() />
			<cfset stUpdate.dt_lastcontact = GetUTCTimeFromUserTime(now()) />
					
			<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="a_bol_return">
				<cfinvokeargument name="entrykey" value="#q_select_item.entrykey#">
				<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
				<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
				<cfinvokeargument name="newvalues" value="#stUpdate#">
				<cfinvokeargument name="updatelastmodified" value="false">
			</cfinvoke>
		
			
		</cfif>
		
		<!--- <cfif a_bol_is_signedmail AND a_int_sendinfomail IS 1>
		
			<cfmodule template="../common/person/getuserpref.cfm"
				entrysection = "email.sm.sendinfomail_toaddress"
				entryname = "#a_str_email#"
				defaultvalue1 = "0"
				savesettings = true
				setcallervariable1 = "a_int_info_sent">	
				
			<cfif a_int_info_sent IS 0>
				<!--- send info now ... --->
				<cfmodule template="sm/sm_info_mail.cfm" targetaddress=#a_str_email#>
				
				<cfmodule template="../common/person/saveuserpref.cfm"
					entrysection = "email.sm.sendinfomail_toaddress"
					entryname = "#a_str_email#"
					entryvalue1 = 1>
			< / cf if>
		< /cfif> --->
	
	  <tr>
		<td style="width:20px;">
		<!--- <cfif q_select_item.recordcount is 0>
			<cfset a_int_add_address = a_int_add_address + 1>
			<input checked class="noborder" type="Checkbox" value="<cfoutput>#urlencodedformat(a_str_email)#</cfoutput>" name="frmAddAddressbook">
		</cfif> --->
		</td>
		<td>
			<img src="/images/si/bullet_orange.png" class="si_img" alt=""/>
			
			<cfif q_select_item.recordcount GT 0>
				 <a target="_parent" href="/addressbook/?action=ShowItem&entrykey=<cfoutput>#q_select_item.entrykey#</cfoutput>"><cfoutput>#application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_item.entrykey, query_holding_data = q_select_item)# (#htmleditformat(a_str_item)#)</cfoutput></a>
			<cfelse>
				<cfoutput>#htmleditformat(a_str_item)#</cfoutput> <img src="/images/si/new.png" class="si_img" />
			</cfif>
		</td>
		
		<td>
			<cfif q_select_item.recordcount GT 0>
				<cfoutput>
					<a href="javascript:AddMailToCRMHistory('#jsstringformat(q_select_tmp_sent_info.destinationfolder)#', '-1', '#JsStringFormat(url.entrykey)#', '#JsStringFormat(q_select_item.entrykey)#')">#GetLangVal('crm_ph_add_to_crm_history')#</a>
				</cfoutput>
			</cfif>
		</td>
		<td>
			
			<cfif q_select_item.recordcount is 0>
				<cfoutput>
				<a href="javascript:CallSimpleAddAddressbookDialog('#jsStringFormatEx(a_str_item)#', '#GetLangValJS('email_ph_confirmation_add_to_addressbook')#');">#si_img('vcard_add')# #GetLangVal('email_ph_confirmation_add_to_addressbook')#</a>
				</cfoutput>
				<br /> 
			</cfif>
			 
			<cfoutput>
			<a href="javascript:OpenSMSInfoPopup('#jsstringformat(q_select_item.entrykey)#','#htmleditformat(a_str_email)#','#htmleditformat(q_select_tmp_sent_info.subject)#','#htmleditformat(q_select_tmp_sent_info.afrom)#');">#GetLangVal('email_ph_confirmation_sms_alert')#</a>
			</cfoutput>
			
			<img src="/images/space_1_1.gif" class="si_img" /> 
		</td>
	 </tr>
	</cfloop>
	
	<!--- <cfif a_int_add_address gt 0>
		<!--- do we have any addresses to add? --->
		<tr>
			<td colspan="3">
			<input class="btn" type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('email_ph_confirmation_add_to_addressbook')#</cfoutput>">
			</td>
		</tr>
	</cfif> --->
	</table>
	</form>
	
</cfsavecontent>

<cfsavecontent variable="a_str_btn">
<input type="button" onclick="window.close();" class="btn2" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>" />
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('email_wd_confirmation'), a_str_btn, a_str_content)#</cfoutput>
<!--- 
<cfinvoke component="#application.components.cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="ad_email_sent">
	<cfinvokeargument name="style" value="#request.appsettings.default_stylesheet#">
</cfinvoke>

<cfsavecontent variable="a_str_content">
	<cftry>
	<cfinclude template="#a_str_page_include#">	
	<cfcatch type="any"> </cfcatch></cftry>
</cfsavecontent> 

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_hint'), '', a_str_content)#</cfoutput> --->