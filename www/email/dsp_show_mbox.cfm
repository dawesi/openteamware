<!--- //

	Module:		EMail
	Action:		ShowMailbox
	Description:Generate frames for displaying mailbox content
	
// --->

<cfparam name="url.mailbox" type="string" default="INBOX">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">

<!--- cols or rows? ... --->
<cfset a_str_mbox_display_style = GetUserPrefPerson('email', 'mbox.display.viewmode', 'cols', '', false) />

<!--- message preview ... --->
<cfset a_int_display_mbox_msg_preview = GetUserPrefPerson('email', 'mbox.display.msgpreview', '1', '', false) />

<!--- set fix properties for now ... --->
<cfset a_str_mbox_display_style = 'cols' />
<cfset a_int_display_mbox_msg_preview = 1 />

<cfif Compare(a_str_mbox_display_style, 'rows') IS 0>
	<!--- row mode, never display preview --->
	<cfset a_int_display_mbox_msg_preview = 0 />
</cfif>
	
<cfif a_str_mbox_display_style IS 'rows' AND a_int_display_mbox_msg_preview IS 0>
	<!--- we do NOT need an iframe ... --->
	<!--- but add standard left/top headers ... --->
	<cflocation addtoken="no" url="default.cfm?userkey=#url.userkey#&action=ShowMailboxContent&mailbox=#urlencodedformat(url.mailbox)#&style=rows&displaymessagepreview=0&includeheader=1">
</cfif>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td id="id_div_mbox_msg_list">
			
			<div id="iddivmboxcontent" class="divmboxcontentcol">
				<div style="text-align:center;padding-top:60px;">
					
					<img src="/images/status/img_circle_loading.gif" alt="" vspace="40" hspace="40" />
					<br /><br />  
					
					<cfoutput>#GetLangVal('mail_ph_status_messages_are_being_loaded')#</cfoutput>
					
				</div>
			</div>
			
		</td>
		<td id="id_div_mox_msg_display">
			
			<!--- display the msg --->
			<div id="id_div_msg_display"></div>
			
		</td>
	</tr>
</table>	

<!--- call js to display the content ... --->
<cfset tmp = AddJSToExecuteAfterPageLoad('DisplayMBoxContentASync("#jsstringformat(url.mailbox)#")', '') />

<!--- set top header info --->
<cfset tmp = SetHeaderTopInfoString( Returnfriendlyfoldername(url.mailbox) ) />