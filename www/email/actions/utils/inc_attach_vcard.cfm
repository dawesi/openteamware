

<cfset a_str_addressbook_vcard_entrykey = GetUserPrefPerson('email', 'addressbook.addvcardtomail.entrykey', '', '', false) />

<cfif Len(a_str_addressbook_vcard_entrykey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_enabled_smartsend = GetUserPrefPerson('email', 'addressbook.addvcardtomail_smartsend', '1', '', false) />	

<!--- smart send? --->
<cfif a_int_enabled_smartsend IS 1>
	<cfset a_str_url_to = Hash(form.mailto)>
	
	<!--- check how many times this user has received the vcard? ... --->
	<cfmodule template="/common/person/howoftenseen.cfm"
		userid = #request.stSecurityContext.myuserid#
		section="email.addressbook.vcard_smartsend"
		page="#a_str_url_to#">

	<cfif PersonTimesSeen GT 5>
		<!--- more than 5 times ... enough! --->
		<cfexit method="exittemplate">
	</cfif>
</cfif>

<!--- load vcard ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="CreateVCard" returnvariable="sVcard">
	<cfinvokeargument name="entrykey" value="#a_str_addressbook_vcard_entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif Len(sVcard) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset sVcard_filename = request.a_str_temp_directory & createuuid() />

<cffile action="write" file="#sVcard_filename#" output="#sVcard#" charset="ISO-8859-1">

<cfif StructKeyExists(variables, 'q_add_virtual_attachments')>
	<!--- add ... --->
	<cfset tmp = QueryAddRow(q_add_virtual_attachments, 1) />
<cfelse>
	<!--- create query ... --->
	<cfset q_add_virtual_attachments = QueryNew("afilename,location,contenttype") />
	<cfset tmp = QueryAddRow(q_add_virtual_attachments, 1) />
</cfif>

<cfset QuerySetCell(q_add_virtual_attachments, 'afilename', 'Visitenkarte.vcf', q_add_virtual_attachments.recordcount) />
<cfset QuerySetCell(q_add_virtual_attachments, 'location', sVcard_filename, q_add_virtual_attachments.recordcount) />
<cfset QuerySetCell(q_add_virtual_attachments, 'contenttype', 'text/vcard', q_add_virtual_attachments.recordcount) />
