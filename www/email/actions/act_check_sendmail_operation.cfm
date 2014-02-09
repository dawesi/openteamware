<!--- //

	Module:		EMail
	Action:		ActCheckSendMailOperation
	Description:Check the desired Sendmail operation ...
	

// --->

<cfparam name="form.frmhandleattachments" default="sendreally">
<cfparam name="form.mailAttachments" default="">
<cfparam name="form.frmpriority" default="3">
<cfparam name="form.frmRequestReadConfirmation" type="numeric" default="0">
<cfparam name="form.frmcbvcard" type="numeric" default="0">
<cfparam name="form.frmjobkey" type="string" default="">

<!--- format: text or html 	--->
<cfparam name="form.frmformat" type="string" default="text">

<!--- the original id ... --->
<cfparam name="form.frmoriginalid" type="numeric" default="0">

<cfparam name="form.mailfrom" type="string" default="#request.stSecurityContext.myusername#">
<cfparam name="form.mailcc" type="string" default="">
<cfparam name="form.mailbcc" type="string" default="">
<cfparam name="form.mailsubject" type="string" default="">
<cfparam name="form.mailbody" type="string" default="">
<cfparam name="form.frmsmaction" type="string" default="">
<cfparam name="form.frmreferences" type="string" default="">

<!--- are we in Draft autosave mode? --->
<cfparam name="form.frmDraftAutoSave" type="boolean" default="false">

<!--- always empty ... when composing an multipart/alternative version, the text body to use
	if empty, text version will be auto-generated from html version --->
<cfparam name="form.mailbody_text" type="string" default="">

<cfinclude template="utils/inc_check_header_data.cfm">

<!--- <cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="mail operation" type="html">
<cfdump var="#form#">
</cfmail> --->

<!--- absender account herausfinden ... --->
<cfset AAccount = form.mailfrom>

<cfset a_str_account = ExtractEmailAdr(form.mailfrom)>

<cfif FindNoCase("<", AAccount, 1) gt 0>
	<cfset aii = FindNoCase("<", AAccount, 1)>
	<cfset AAccount = Mid(AAccount, aii+1, len(AAccount))>
	<cfset aii = FindNoCase(">", AAccount, 1)>
	<cfset AAccount = Mid(AAccount, 1, aii)>
</cfif>

<!--- check closing "," in the recipients ... --->
<cfset form.mailcc = ReReplaceNoCase(trim(form.mailcc), '\,$', '')>
<cfset form.mailbcc = ReReplaceNoCase(trim(form.mailbcc), '\,$', '')>
<cfset form.mailto = ReReplaceNoCase(trim(form.mailto), '\,$', '')>

<cfif StructKeyExists(form, 'frmq_virtual_attachments')>
	<!--- we've got a wddx saved query with information about a virtual table with files to add to this email --->
	<cfwddx action="wddx2cfml" input="#form.frmq_virtual_attachments#" output="q_add_virtual_attachments">
</cfif>

<cfif CompareNoCase(form.frmsmaction, 'a1_sign') IS 0>
	<!--- A1 Signature ... create virtual attachment table and add verification file, set html body and so on --->
	<cfinclude template="../sm/inc_add_virtual_attachments_on_send.cfm">
</cfif>

<cfif (val(form.frmoriginalid) gt 0) AND
	  (ListFindNoCase('1,2', form.frmtype) GT 0)>

	<!--- set the original message to "replied" ... --->
	<cfinvoke component="/components/email/cmp_tools" method="setmessagestatus" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#form.frmmailbox#">
		<cfinvokeargument name="uid" value="#form.frmoriginalid#">
		<cfinvokeargument name="status" value="1">
	</cfinvoke>

</cfif>

<!--- choose now the operation ... --->
<cfswitch expression="#form.mailAction#">

	<cfcase value="sendmail">
		<!--- send the e-mail now ... --->
		<cfinclude template="inc_mailaction_send.cfm">			
	</cfcase>

	<cfcase value="cancelmsg">
		<!--- cancel ... --->
		<cfinclude template="inc_mailaction_cancel.cfm">
	</cfcase>

	<cfcase value="savedraft">
		<!--- save the message as draft ... --->
		<cfinclude template="inc_mailaction_savedraft.cfm">
	</cfcase>

	<cfcase value="removeattachment">
		<!--- remove an attachment ... --->
		<cfinclude template="inc_mailaction_removeattachment.cfm">	
	</cfcase>

	<cfcase value="convertmsgformat">
		<!--- convert message format ... --->
		<cfinclude template="inc_mailaction_convertformat.cfm">
	</cfcase>

	<cfcase value="addattachment">
		<!--- add an attachment ... --->
		<cfinclude template="inc_mailaction_addattachment.cfm">
	</cfcase>

</cfswitch>


