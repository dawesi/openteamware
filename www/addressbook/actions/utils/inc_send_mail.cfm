

<cfmail charset="utf-8" to="#a_str_recipient#" from="#request.stSecurityContext.myusername#" subject="Weitergeleitete Kontakte von #request.a_struct_personal_properties.myfirstname# #request.a_struct_personal_properties.mysurname#">
<cfloop list="#a_str_attachments#" delimiters="," index="sFilename">
<cfmailparam file="#trim(sFilename)#" type="application/vcard">
</cfloop>
Guten Tag!
	
Anbei finden Sie die Kontakte, die Ihnen #request.a_struct_personal_properties.myfirstname# #request.a_struct_personal_properties.mysurname# weitergeleitet hat. 

Sie finden die Kontakte sowohl als VCard-Attachment als auch nachfolgend direkt als Text vor.

Die Kontakte im Einzelnen:

<cfloop index="sEntrykey" list="#form.frmcheckedentrykey#" delimiters=",">

		<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_load_contact">
			<cfinvokeargument name="entrykey" value="#sEntrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>

<cfset q_select_contact = a_struct_load_contact.q_select_contact>
-------------------------------------------------------------------------------------------

Name: #q_select_contact.surname#, #q_select_contact.firstname#
E-Mail: #q_select_contact.email_prim#
Unternehmen: #q_select_contact.company#
Abteilung: #q_select_contact.department#
Titel/Position: #q_select_contact.aposition#

Kontakt Business:
Telefon: #q_select_contact.b_telephone#
Mobil: #q_select_contact.b_mobile#
Fax: #q_select_contact.b_fax#
Ort: #q_select_contact.B_CITY#
Adresse: #q_select_contact.B_STREET#
PLZ: #q_select_contact.B_zipcode#
Staat: #q_select_contact.B_COUNTRY#
</cfloop>
-------------------------------------------------------------------------------------------
</cfmail>