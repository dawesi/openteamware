<!--- //

	Module:		E-Mail
	Action:		ShowInsertTextBlockSignatur
	Description:Show dialog for inserting textblock or signture
	

// --->

<cfparam name="url.emailadr" type="string" default="#request.stSecurityContext.myusername#">
<cfparam name="url.format" type="string" default="text">

<cfset url.emailadr = extractemailadr(url.emailadr) />

<cfset tmp = StartNewTabNavigation() />
<cfset a_str_id_textblock = AddTabNavigationItem(GetLangValJS('scr_wd_textblocks'), '', '') />
<cfset a_str_id_signatur = AddTabNavigationItem(GetLangValJS('mail_ph_email_signatur'), '', '') />

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<!--- load text blocks ... --->
<cfset SelectNoticesRequest.Itemtype = 3 />

<div class="div_module_tabs_content_box" id="<cfoutput>#a_str_id_textblock#</cfoutput>">

<b><cfoutput>#GetLangVal("mail_ph_insert_textblock_description")#</cfoutput></b>

<br /><br />  
<form name="form1" action="#">
<table class="table_overview">
	<tr class="tbl_overview_header">
		<td>
			<cfoutput>#GetLangVal('cm_wd_title')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>
		</td>
		<td></td>
	</tr>
<cfoutput query="q_select_notices">
	
	<input type="hidden" value="#htmleditformat(q_select_notices.notice)#" name="frmnotice#q_select_notices.currentrow#" id="frmnotice#q_select_notices.currentrow#" />
	
	<tr>
		<td>
			#htmleditformat(q_select_notices.subject)#
		</td>
		<td>
			#ReplaceNoCase(htmleditformat(q_select_notices.notice), chr(10), ' ... ', 'ALL')#
		</td>
		<td style="text-align:right;">
			<input type="button" name="frmInsertText" class="btn2" value="#GetLangVal('mail_ph_insert_text')#" onClick="AddTextToBody('text', 'frmnotice#q_select_notices.currentrow#');" />
		</td>
	</tr>
	
</cfoutput>

	<tr>
		<td colspan="3">
			<a href="../rd/scratchpad/textblocks/" target="_blank"><cfoutput>#GetLangVal('mail_ph_edit_textblocks')#</cfoutput></a>
		</td>
	</tr>
</table>

</form>
</div>

<cfif url.format IS 'text'>
	<cfset a_int_format = 0 />
<cfelse>
	<cfset a_int_format = 1 />
</cfif>

<cfinvoke component="#application.components.cmp_content#" method="GetSignaturesOfUser" returnvariable="q_select_signatures">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="format" value="#a_int_format#">
	<cfinvokeargument name="email_adr" value="#url.emailadr#">
</cfinvoke>

<div class="div_module_tabs_content_box" style="display:none;" id="<cfoutput>#a_str_id_signatur#</cfoutput>">

	<b><cfoutput>#GetLangVal('mail_ph_textblocks_description')#</cfoutput></b>


	<br /><br />  
	<form name="form1" action="#">
	<table class="table_overview">
		<tr class="tbl_overview_header">
			<td>
				<cfoutput>#GetLangVal('cm_wd_title')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>
			</td>
			<td></td>
		</tr>
	<cfoutput query="q_select_signatures">
		
		<input type="hidden" value="#htmleditformat(q_select_signatures.sig_data)#" name="frmsignature_#q_select_signatures.currentrow#" id="frmsignature_#q_select_signatures.currentrow#" />
		
		<tr>
			<td>
				#htmleditformat(q_select_signatures.title)#
			</td>
			<td>
				<cfif q_select_signatures.sig_type IS 0>
					<cfset a_str_format = 'text' />
					#ReplaceNoCase(htmleditformat(q_select_signatures.sig_data), chr(10), ' ... ', 'ALL')#
				<cfelse>
					<cfset a_str_format = 'html' />
					#q_select_signatures.sig_data#
				</cfif>
			</td>
			<td style="text-align:right;">
				<input type="button" name="frmInsertText" class="btn2" value="#GetLangVal('mail_ph_insert_text')#" onClick="AddTextToBody('#a_str_format#', 'frmsignature_#q_select_signatures.currentrow#');" />
			</td>
		</tr>
		
	</cfoutput>
	</table>
		
	</form>

</div>

