<!--- //

	extended signature function ...

	// --->

<cfparam name="url.email_adr" type="string" default="">
<cfparam name="url.subaction" type="string" default="">
<cfparam name="url.format" type="string" default="text">
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="/components/email/cmp_accounts" method="GetEmailAccounts" returnvariable="q_select_accounts">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfset tmp = SetHeaderTopInfoString( GetLangVal('mail_ph_email_signatures') ) />

<!--- // load signatures for this email address // --->
<cfinvoke component="#application.components.cmp_content#" method="GetSignaturesOfUser" returnvariable="q_select_signatures">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<!--- load all formats ... --->
	<cfinvokeargument name="format" value="-1">
	<cfinvokeargument name="email_adr" value="#url.email_adr#">
</cfinvoke>


<cfoutput>#GetLangVal('prf_ph_signature_explanation')#</cfoutput>
<br /><br />

<cfif Len(url.subaction) IS 0>

<cfsavecontent variable="a_str_buttons">
	<cfoutput>
		<input type="button" class="btn2" onclick="GotoLocHref('index.cfm?action=signatures&subaction=createnewedit&format=1');return false;" value="#GetLangVal('prf_ph_create_new_sig_html')#" />
		<input type="button" class="btn2" onclick="GotoLocHref('index.cfm?action=signatures&subaction=createnewedit&format=0');return false;" value="#GetLangVal('prf_ph_create_new_sig_text')#" />
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="a_str_content">
	
	<cfoutput query="q_select_signatures">
		<br /><br />
	
	<fieldset class="bg_fieldset" style="width:500px; ">
		<legend>#htmleditformat(CheckZeroString(q_select_signatures.title))# (<cfif q_select_signatures.sig_type IS 0>Text<cfelse>HTML</cfif>)</legend>
		<div style="padding:8px; ">
		
			<cfif q_select_signatures.default_sig IS 0>
				<p>
					<a href="act_set_default_sig.cfm?entrykey=#q_select_signatures.entrykey#&format=#q_select_signatures.sig_type#">#si_img('star')# Diese Signatur als Standard-Signatur setzen (<cfif q_select_signatures.sig_type IS 0>Text<cfelse>HTML</cfif>)</a>
				</p>
			<cfelse>
				<p>#si_img('star')# Dies ist die standardmaessige Signatur (<cfif q_select_signatures.sig_type IS 0>Text<cfelse>HTML</cfif>)</p>
			</cfif>			
			
			<cfif Len(q_select_signatures.email_adr) GT 0>
				<p>#GetLangVal('prf_ph_signatures_email_addresses')#: #q_select_signatures.email_adr#</p>
			</cfif>
			
			<p>
				<a href="index.cfm?action=signatures&email_adr=#urlencodedformat(url.email_adr)#&subaction=createnewedit&entrykey=#q_select_signatures.entrykey#">#si_img('pencil')# #GetLangval('cm_wd_edit')#</a>
				&nbsp;|&nbsp;
				<a href="act_delete_signatur.cfm?entrykey=#q_select_signatures.entrykey#" onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');">#si_img('delete')# #GetLangVal('cm_wd_delete')#</a>
			</p>
			
			<div class="b_all mischeader" style="margin-top:10px; ">
			
				<cfif q_select_signatures.sig_type IS 0>
					<pre>#q_select_signatures.sig_data#</pre>
				<cfelse>
					#q_select_signatures.sig_data#
				</cfif>
			
			</div>
			
		</div>
	</fieldset>
	</cfoutput>
	
	
</cfsavecontent>

<cfoutput>#WriteNewContentBox( GetLangVal('mail_ph_email_signatures') , a_str_buttons , a_str_content)#</cfoutput>
</cfif>


<cfif CompareNoCase(url.subaction, 'createnewedit') IS 0>

	<cfset a_str_title = ''>
	<cfset a_str_sig_data = ''>
	<cfset a_str_email_adr = ''>
	
	<cfif Len(url.entrykey) GT 0>
		<!--- load sig --->
		<cfquery name="q_select_sig" dbtype="query">
		SELECT
			*
		FROM
			q_select_signatures
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
		;
		</cfquery>
		
		<cfif q_select_sig.recordcount IS 1>
			<cfset a_str_title = q_select_sig.title>
			<cfset a_str_sig_data = q_select_sig.sig_data>
			<cfset a_str_email_adr = q_select_sig.email_adr>
			<cfset url.format = q_select_sig.sig_type>
		</cfif>
	</cfif>

<fieldset class="default_fieldset">
	<legend><cfoutput>#GetLangVal('prf_ph_signatures_create_signatures')#</cfoutput></legend>
	
	<form action="act_create_edit_signature.cfm" method="post" style="margin:0px; ">
	
	<input type="hidden" name="frmentrykey" value="<cfoutput>#url.entrykey#</cfoutput>">
	
	<input type="hidden" name="frmformat" value="<cfoutput>#val(url.format)#</cfoutput>">
	
	<table class="table_details table_edit">
	  <tr>
	  	<td class="field_name">
			<cfoutput>#GetLangVal('prf_ph_signatures_email_addresses')#</cfoutput>
		</td>
		<td>
			<select size="3" name="frmemail_adr" multiple style="width:450px; ">
				<option <cfif Len(a_str_email_adr) IS 0>selected</cfif> value=""><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></option>
				<cfoutput query="q_select_accounts">
					<option <cfif ListFindNoCase(a_str_email_adr, q_select_accounts.emailadr) GT 0>selected</cfif>  value="#htmleditformat(q_select_accounts.emailadr)#">#htmleditformat(q_select_accounts.emailadr)#</option>
				</cfoutput>
			</select>
			
			<cfoutput>#htmleditformat(url.email_adr)#</cfoutput></td>
	  </tr>
	  <tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_title')#</cfoutput>
		</td>
		<td>
			<input type="text" style="width:450px;" name="frmtitle" value="<cfoutput>#htmleditformat(a_str_title)#</cfoutput>" size="40">
		</td>
	  </tr>
	  <tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_data')#</cfoutput>
		</td>
		<td>
		
		<cfif url.format IS 1>
			<div class="b_all" style="padding:0px;margin:0px;">
			<cfscript>
				fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
				fckEditor.instanceName	= "frm_sig_data";
				fckEditor.value			= a_str_sig_data;
				fckEditor.width			= "650";
				fckEditor.height		= "400";
				//fckEditor.toolbarSet	= 'INBOX_Default';
				fckEditor.create(); // create the editor.
			</cfscript>
			</div>
			<font class="addinfotext"><cfoutput>#GetLangVal('prf_ph_description_html_editor_linkbreak')#</cfoutput></font>
		<cfelse>
			<textarea rows="5" style="width:450px; " cols="60" name="frm_sig_data"><cfoutput>#htmleditformat(a_str_sig_data)#</cfoutput></textarea>
		</cfif>
		
		</td>
	  </tr>
	  <tr>
		<td class="field_name"></td>
		<td>
			<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>" class="btn" />
			&nbsp;&nbsp;
			<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_cancel')#</cfoutput></a>
		</td>
	  </tr>
	</table>	
	</form>
	
</fieldset>
</cfif>

