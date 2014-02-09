<!--- //

	settings concerning the address book
	
	// --->
<cfparam name="url.saved" type="numeric" default="0">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail"
	defaultvalue1 = "0"
	savesettings = true
	setcallervariable1 = "a_int_enabled">
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail_smartsend"
	defaultvalue1 = "1"
	savesettings = true
	setcallervariable1 = "a_int_enabled_smartsend">	
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.remoteedit.addvcardtomail"
	defaultvalue1 = "1"
	savesettings = true
	setcallervariable1 = "a_int_enabled_re">
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail.entrykey"
	defaultvalue1 = ""
	savesettings = true
	setcallervariable1 = "sEntrykey">			
	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts>	
	
<cf_disp_navigation mytextleft="#GetLangVal('cm_wd_addressbook')#">
<br>
<p>
	<img src="/images/info.jpg" hspace="3" vspace="3" align="left">
	<cfoutput>#GetLangVal('prf_ph_addressbook_intro')#</cfoutput>
</p>
<cfif url.saved is 1>
	<div style="border:orange solid 2px;padding:6px; "><cfoutput>#GetLangVal('prf_ph_settings_saved')#</cfoutput></div>
	<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="4">
<form action="act_save_addressbook.cfm" method="post" name="formaddressbook">
  <tr>
    <td align="right">
		<input type="checkbox" name="frmsendvcard" value="1" class="noborder" <cfoutput>#WriteCheckedElement(a_int_enabled, 1)#</cfoutput>>
	</td>
    <td>
		<cfoutput>#GetLangVal('prf_ph_addressbook_vcard_autoattach')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right">
		<input type="checkbox" name="frmsendvcard_smart" value="1" class="noborder" <cfoutput>#WriteCheckedElement(a_int_enabled_smartsend, 1)#</cfoutput>>
	</td>
    <td>
		<cfoutput>#GetLangVal('prf_ph_addressbook_vcard_onlyfirst')#</cfoutput>
	</td>
  </tr>  
  <tr>
    <td align="right" valign="top">
		<cfoutput>#GetLangVal('prf_ph_addressbook_vcard_entry')#</cfoutput>
	</td>
    <td valign="top">
		<b><cfoutput>#GetLangVal('prf_ph_addressbook_vcard_pleaseselectyourentry')#</cfoutput></b><br>
		<cfoutput>#GetLangVal('prf_ph_addressbook_vcard_createnew')#</cfoutput><br><br>
		<select name="frmentrykey" size="10">
			<option value="">--</option>
			<cfoutput query="q_select_contacts">
				<option #writeselectedelement(sEntrykey,q_select_contacts.entrykey)# value="#q_select_contacts.entrykey#">#q_select_contacts.surname#, #q_select_contacts.firstname# (#q_select_contacts.email_prim#)</option>
			</cfoutput>
		</select>
		&nbsp;|&nbsp;
		<a href="javascript:ShowContact();"><cfoutput>#GetLangVal('prf_ph_addressbook_vcard_show')#</cfoutput></a>
	</td>
  </tr>
  <tr>
  	<td></td>
	<td>
		<a href="/addressbook/?action=createnewitem" target="_blank"><cfoutput>#GetLangVal('prf_ph_addressbook_vcard_createnewcontact')#</cfoutput></a> | <a href="javascript:location.reload();"><cfoutput>#GetLangVal('cm_ph_reload_page')#</cfoutput></a>
	</td>
  </tr>
  <tr>
  	<td align="right">
		<input type="checkbox" name="frmcbremoteedit" value="1" class="noborder" <cfoutput>#WriteCheckedElement(a_int_enabled_re, 1)#</cfoutput>>
	</td>
	<td>
		<cfoutput>#GetLangVal('prf_ph_addressbook_remoteedit')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="<cfoutput>#GetLangVal('prf_ph_addressbook_save')#</cfoutput>">
	</td>
  </tr>
</form>  
</table>

<script type="text/javascript">
	function ShowContact()
		{
		location.href = '/addressbook/?action=ShowItem&entrykey='+escape(document.formaddressbook.frmentrykey.value);
		}
</script>