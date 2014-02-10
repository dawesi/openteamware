<!--- //

	Module:		Address Book
	Function:	ActivateRemoteEdit
	Description:send out remote edit e-mail 
	

// --->

<cfset q_select_contact_re = a_struct_load_contact.q_select_contact />

<!--- language ... use a) the default language or b) the language of the contact (stated in the RE job) --->

<!--- load standard address ... --->
<cfinvoke component="/components/email/cmp_accounts" method="GetStandardAddressFromTag" returnvariable="a_str_from_adr">
	<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<cfset a_str_mail_text = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_mail_text') />
<cfset a_str_mail_text = ReplaceNoCase(a_str_mail_text, '%NAME%', q_select_user_data.firstname&' '&q_select_user_data.surname, 'ALL') />

<cfif q_select_user_data.sex is 0>
	<cfset a_str_mail_text = ReplaceNoCase(a_str_mail_text, '%HE_OR_SHE%', application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_he_cap'), 'ALL') />
	<cfset a_str_mail_text = ReplaceNoCase(a_str_mail_text, '%HIM_OR_HER%', application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_him'), 'ALL') />
<cfelse>
	<cfset a_str_mail_text = ReplaceNoCase(a_str_mail_text, '%HE_OR_SHE%', application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_she_cap'), 'ALL') />
	<cfset a_str_mail_text = ReplaceNoCase(a_str_mail_text, '%HIM_OR_HER%', application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_her'), 'ALL') />
</cfif>

<cfset a_str_mail_text = ReplaceNoCase(a_str_mail_text, '%HREF_REMOTE_EDIT%', "https://#a_str_base_url#/rd/a/re/?#urlencodedformat(a_str_job_key)#", 'ALL')>

<cfset a_str_mail_subject = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_mail_subject')>
<cfset a_str_mail_subject = ReplaceNoCase(a_str_mail_subject, '%NAME%', q_select_user_data.firstname&' '&q_select_user_data.surname, 'ALL')>

<cfinvoke component="#application.components.cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_page_include_remote_edit_text_version">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="remotedit_text_version">
	<cfinvokeargument name="style" value="#a_str_user_style#">
</cfinvoke>

<cfsavecontent variable="a_str_remote_edit_text_body">
	<cfinclude template="#a_str_page_include_remote_edit_text_version#">
</cfsavecontent>

<cfset a_str_remote_edit_text_body = ReplaceNoCase(a_str_remote_edit_text_body, '%SENDER_NAME%', q_select_user_data.firstname & ' ' & q_select_user_data.surname, 'ALL')> 
<cfset a_str_remote_edit_text_body = ReplaceNoCase(a_str_remote_edit_text_body, '%REMOTEEDIT_LINK%', "https://#a_str_base_url#/rd/a/re/?#urlencodedformat(a_str_job_key)#", 'ALL')> 

<cfinvoke component="#application.components.cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_page_include_ad_remote_edit_bottom">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="ad_remotedit_bottom">
	<cfinvokeargument name="style" value="#a_str_user_style#">
</cfinvoke>

<!--- attach vcard? --->

<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail.entrykey"
	defaultvalue1 = ""
	userid = #q_select_user_data.userid#
	setcallervariable1 = "a_str_addressbook_vcard_entrykey">	
	
<cfif Len(a_str_addressbook_vcard_entrykey) GT 0>

	<!--- try to load contact --->
	<cfset a_struct_load_contact_vcard_attach = GetContact(entrykey = a_str_addressbook_vcard_entrykey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings)>
	
	<cfif StructKeyExists(a_struct_load_contact_vcard_attach, 'q_select_contact')>
	
		<cfset q_select_contact_vcard = a_struct_load_contact_vcard_attach.q_select_contact>
	
		<!--- ok, create vCard now --->
		<cfset sVcard = CreateVCard(entrykey = a_str_addressbook_vcard_entrykey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings)>

		<!---<cfinvoke component="#application.components.cmp_addressbook#" method="CreateVCard" returnvariable="sVcard">
			<cfinvokeargument name="entrykey" value="#a_str_addressbook_vcard_entrykey#">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
		</cfinvoke>--->
		
		<cfset sVcard_directory = request.a_str_temp_directory & request.a_str_dir_separator & 'vcard' & CreateUUID()> 
		
		<cfdirectory action="create" directory="#sVcard_directory#">
	
		<cfset sVcard_filename = sVcard_directory & request.a_str_dir_separator & 'Kontakt.vcf' />
	
		<cffile action="write" file="#sVcard_filename#" output="#sVcard#" charset="iso-8859-1">	
		
		<cfset a_bol_user_vcard_available = true />
	
	</cfif>

<cfelse>
	<cfset sVcard_filename = '' />
</cfif>

<cfmail mailerid="openTeamWare RemoteEdit" from="#a_str_from_adr#" to="#ExtractEmailadr(q_select_contact_re.email_prim)#" subject="#a_str_mail_subject#">
<cfif a_bol_user_vcard_available>
	<cfmailparam file="#sVcard_filename#" type="text/vcard">
</cfif>
<cfmailpart type="text">#a_str_remote_edit_text_body#</cfmailpart>
<cfmailpart type="html">
<html>
	<head>
		<title>RemoteEdit</title>
		<style>
			body,p,a,td{font-family:"Lucida Grande", Tahoma,Verdana; font-size:11px;}
		</style>
		<base href="https://#a_str_base_url#/" />
	</head>
<body>

<cfif Len(a_str_header) GT 0>
	<div style="padding:6px;border-bottom:silver solid 1px;">
	#a_str_header#
	</div>
</cfif>

<table border="0" cellspacing="0" cellpadding="8">
  <tr>
    <td valign="top" style="line-height:17px;">
		
	<cfif Len(q_select_contact_re.surname) GT 0 AND (q_select_contact_re.sex NEQ -1)>
		<!--- add the name if possible! --->
		
		<cfif q_select_contact_re.sex IS 0>
			<cfset a_str_salutation = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_male') />
		<cfelse>
			<cfset a_str_salutation = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_female') />
		</cfif>
		
		<cfset a_str_salutation = ' ' & a_str_salutation & ' ' & q_select_contact_re.surname />
	</cfif>
	
	<cfset a_str_anrede = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_hello') />
	<cfset a_str_anrede = ReplaceNoCase(a_str_anrede, '%SALUTATION%', a_str_salutation) />
		
	<div style="padding:6px; ">

	<b>#a_str_anrede#</b>
	<br /> 
	
	<cfif Len(arguments.ownintromsg) GT 0>
		#arguments.ownintromsg#
	<cfelse>
	
		<cfset a_str_text = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_mail_html_intro')>
		<cfset a_str_text = ReplaceNocase(a_str_text, '%REPLYADDRESS%', ExtractEmailAdr(a_str_from_adr), 'ALL')>
		<cfset a_str_text = ReplaceNocase(a_str_text, '%NAME%', trim(q_select_user_data.firstname&' '&q_select_user_data.surname), 'ALL')>
		<cfset a_str_text = ReplaceNocase(a_str_text, '%BASEURL%', trim(a_str_base_url), 'ALL')>
		<cfset a_str_text = ReplaceNocase(a_str_text, '%PRODUCTNAME%', a_str_product_name, 'ALL')>	
		#a_str_text#
		
	</cfif>

	<br /><br />  

		<div style="background-color:##EEEEEE;padding:8px;border:silver solid 1px;">
			<a href="https://#a_str_base_url#/rd/a/re/?#urlencodedformat(a_str_job_key)#" target="_blank"><img src="/images/si/arrow_right.png" width="16" height="16" border="0" align="absmiddle" /> #application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_mail_html_please_click_here')#</a> (<img src="/images/si/key.png" border="0" align="absmiddle" width="16" height="16" hspace="2"/> #application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_mail_html_ssl_encrypted')#)
		</div>
	
	</div>
	
	<br />
	
	<table border="0" cellpadding="10" cellspacing="0">
		<tr>
			<td valign="top">
			
			
			<fieldset style="border:silver solid 1px; ">
				<legend>
					<img src="/images/si/user.png" align="absmiddle" height="16" width="16" vspace="4" hspace="4" border="0"> <b>#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adr_ph_remoteedit_your_data')#</b>
				</legend>

			<table width="100%" border="0" cellspacing="0" cellpadding="5">
			  <tr>
			  	<td colspan="2">
					<b>#htmleditformat(q_select_contact_re.surname)#, #htmleditformat(q_select_contact_re.firstname)#</b>
				</td>
			  </tr>
			  <tr>
				<td width="50%">
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_email')#: #WriteUnknownReField(q_select_contact_re.email_prim, iLangNo)#
				</td>
				<td width="50%">
				</td>
			  </tr>			  
			  <tr>
			  	<td colspan="2" style="color:gray;border-bottom:silver solid 1px;border-top:silver solid 1px;background-color:##EEEEEE;">#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_business_data')#</td>
			  </tr>			  
			  <tr>
				<td width="50%">
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_company')#: #WriteUnknownReField(q_select_contact_re.company, iLangNo)#
				</td>
				<td width="50%">
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_department')#: #WriteUnknownReField(q_select_contact_re.department, iLangNo)#
				</td>
			  </tr>
			  <tr>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_street')#: #WriteUnknownReField(q_select_contact_re.b_street, iLangNo)#
				</td>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_zipcode')#: #WriteUnknownReField(q_select_contact_re.b_zipcode, iLangNo)#;&nbsp;Ort: #WriteUnknownReField(q_select_contact_re.b_city, iLangNo)#
				</td>
			  </tr>
			  <tr>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_country')#: #WriteUnknownReField(q_select_contact_re.b_country, iLangNo)#
				</td>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_telephone')#: #WriteUnknownReField(q_select_contact_re.b_telephone, iLangNo)#;&nbsp;Fax: #WriteUnknownReField(q_select_contact_re.b_fax, iLangNo)#
				</td>
			  </tr>
			  <tr>
			  	<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_mobile')#: #WriteUnknownReField(q_select_contact_re.b_mobile, iLangNo)#
				</td>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_url')#: #WriteUnknownReField(q_select_contact_re.b_url, iLangNo)#
				</td>
			  </tr>
			  <tr>
			  	<td colspan="2" style="color:gray;border-top:silver solid 1px;border-bottom:silver solid 1px;background-color:##EEEEEE;">#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_private_data')#</td>
			  </tr>			  
			  <tr>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_street')#: #WriteUnknownReField(q_select_contact_re.p_street, iLangNo)#
				</td>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_zipcode')#: #WriteUnknownReField(q_select_contact_re.p_zipcode, iLangNo)#;&nbsp;Ort: #WriteUnknownReField(q_select_contact_re.p_city, iLangNo)#
				</td>
			  </tr>
			  <tr>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_country')#: #WriteUnknownReField(q_select_contact_re.p_country, iLangNo)#
				</td>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_wd_telephone')#: #WriteUnknownReField(q_select_contact_re.p_telephone, iLangNo)#;&nbsp;Fax: #WriteUnknownReField(q_select_contact_re.p_fax, iLangNo)#
				</td>
			  </tr>
			  <tr>
			  	<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_mobile')#: #WriteUnknownReField(q_select_contact_re.p_mobile, iLangNo)#
				</td>
				<td>
					#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_url')#: #WriteUnknownReField(q_select_contact_re.p_url, iLangNo)#
				</td>
			  </tr>
			</table>
			</fieldset>
			
			</td>
			
			<cfif a_bol_user_vcard_available>
			<td width="160" valign="top">
			
				<fieldset style="border:##F2F2F2 solid 1px;">
					<legend>
						<img src="/images/webmail/16adressen_business.gif" width="14" align="absmiddle" height="11" border="0"> <b>#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adr_ph_remoteedit_my_data')#</b><img src="/images/space_1_1.gif" width="1" height="32" vspace="4" hspace="4" border="0" align="absmiddle">
					</legend>
				
				
					<div style="padding:4px;line-height:17px;">
						
						
						#htmleditformat(q_select_contact_vcard.title)# #htmleditformat(q_select_contact_vcard.firstname)# #htmleditformat(q_select_contact_vcard.surname)#
						<br />
						<cfif Len(q_select_contact_vcard.company GT 0)>
							#htmleditformat(q_select_contact_vcard.company)#
								
								<cfif Len(q_select_contact_vcard.aposition GT 0)>
									/ #htmleditformat(q_select_contact_vcard.aposition)#
								</cfif>
							<br />
						</cfif>
						
						#htmleditformat(q_select_contact_vcard.b_zipcode)# #htmleditformat(q_select_contact_vcard.b_city)#
						<br />
						#htmleditformat(q_select_contact_vcard.b_country)#
						<br />						
						Tel: #htmleditformat(q_select_contact_vcard.b_telephone)#
						<br />
						#htmleditformat(q_select_contact_vcard.email_prim)#
						<br /><br />
						#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_remote_edit_vcard_attachment')#
						
					</div>
				
				</fieldset>
			</td>
			</cfif>
		</tr>
	</table>
	
		<br /> 
		
		<div style="padding:6px; ">
			<cftry>
				<cfinclude template="#a_str_page_include_ad_remote_edit_bottom#">
			<cfcatch type="any"> </cfcatch>
			</cftry>
		</div>
		
		<a href="https://#a_str_base_url#/"><img align="right" src="#a_struct_big_logo.path#" width="#a_struct_big_logo.width#" height="#a_struct_big_logo.height#" vspace="10" hspace="10" border="0" /></a>
	</td>
    <td style="border-left:##EEEEEE solid 1px;" valign="top" width="160" background="/addressbook/re/o.cfm/#urlencodedformat(a_str_job_key)#/" align="center">
	
	
	<cfif q_select_user_data.bigphotoavaliable IS 1>
		<img align="absmiddle" src="/tools/img/show_big_userphoto.cfm?entrykey=#urlencodedformat(q_select_user_data.entrykey)#&source=re">
	<cfelse>
		<img src="/images/addressbook/img_re_addressbook.gif" width="101" height="94">
		<h3>#application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='cm_wd_address_book')#</h3>
	
		<cfset a_str_please_correct = application.components.cmp_lang.GetLangValExt(langno = iLangNo, entryid='adrb_ph_re_check_data')>
	
		#ReplaceNoCase(a_str_please_correct, '/', ' / ', 'ALL')#
	</cfif>
	
	</td>
  </tr>
</table>

<cfif Len(a_str_footer) GT 0>
	<div style="padding:6px;border-top:silver solid 1px; ">
		#a_str_footer#
	</div>
</cfif>
	
</body>
</html>
</cfmailpart>
</cfmail>

