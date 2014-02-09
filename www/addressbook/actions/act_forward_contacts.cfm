<!--- //

	Module:		Address Book
	Action:		DoForwardContacts
	Description:
	
// --->

<!--- the IDs of the selected addresses --->
<cfparam name="form.frmcheckedentrykey" default="" type="string">

<cfset a_int_contact_count = 0 />
<cfset a_str_attachments = '' />

<cfif StructKeyExists(form,  'frmSubmitEmail')>

	<cfset a_str_recipient = ExtractEmailAdr(form.frmemailto) />
	
	<cfif Len(a_str_recipient) IS 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message='#GetLangVal('adrb_ph_error_no_recipient_address_entered')#'>
		<cfexit method="exittemplate">
	</cfif>

	<cfset sDirectory = request.a_str_temp_directory & request.a_str_dir_separator & CreateUUID()>
	
	<cfdirectory directory="#sDirectory#" action="create">

	<cfloop index="sEntrykey" list="#form.frmcheckedentrykey#" delimiters=",">

		<!--- save vcard for each contact --->
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="CreateVCard" returnvariable="sVcard">
			<cfinvokeargument name="entrykey" value="#sEntrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>


		<!--- save now to file ... --->
		
		<cfif Len(sVcard) GT 0>
			
			<cfset a_int_contact_count = a_int_contact_count + 1>
			
			<cfset sFilename = sDirectory & request.a_str_dir_separator & 'Kontakt' & a_int_contact_count & '.vcf'>
			
			<!--- save vcard ... --->
			<cffile action="write" addnewline="no" charset="ISO-8859-1" file="#sFilename#" output="#sVcard#">

			<cfset a_str_attachments = ListPrepend(a_str_attachments, sFilename)>
		</cfif>


	</cfloop>
	
	<cfif Len(a_str_attachments) GT 0>
		<cfinclude template="utils/inc_send_mail.cfm">
	</cfif>

	<cflocation addtoken="No" url="/addressbook/">


<cfelseif IsDefined("form.frmSubmitMobile")>

	<!--- send to a mobile --->
	<!--- one sms per contact --->

	<cfloop index="sEntrykey" list="#form.frmcheckedentrykey#" delimiters=",">

		<cfset SendContactPerSMS.entrykey = sEntrykey>
		<cfset SendContactPerSMS.SMSType = form.frmMobileType>
		<cfset SendContactPerSMS.Recipient = form.frmMobileNr>
		
		<cfinclude template="utils/inc_send_sms.cfm">
	</cfloop>

	<cflocation addtoken="No" url="/addressbook/">

<cfelse>

	<!--- error or something ... redirect --->
	<cflocation addtoken="No" url="/addressbook/">
</cfif>

