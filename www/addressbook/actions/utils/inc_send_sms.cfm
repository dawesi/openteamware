<!--- contact id --->
<cfparam name="SendContactPerSMS.entrykey" default="" type="string">

<!--- number to send sms to --->
<cfparam name="SendContactPerSMS.Recipient" default="0" type="string">

<!--- sms type --->
<cfparam name="SendContactPerSMS.SMSType" default="0">

<cfset a_str_sms_to = SendContactPerSMS.Recipient>


<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_load_contact">
	<cfinvokeargument name="entrykey" value="#sEntrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif NOT StructKeyExists(a_struct_load_contact, 'q_select_contact')>
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_contact = a_struct_load_contact.q_select_contact>

<cfswitch expression="#val(SendContactPerSMS.SMSType)#">
	<cfcase value="0">

		<!--- send out normal sms 
			demo: Kontakt Vorname Nachname Telefon: +491711234567 Email: test@test.com | verschickt von peter mayer <test@test.com>
		--->
		<cfset a_str_sms_text = "Kontaktdaten fuer "&q_select_contact.firstname&" "&q_select_contact.surname>
	
		<cfif trim(q_Select_contact.company) neq "">
			<cfset a_str_sms_text = a_str_sms_text&";Firma: "&shortenstring(q_select_contact.company, 15)>	
		</cfif>
	
		<cfif trim(q_select_contact.b_mobile) neq "">
			<cfset a_str_sms_text = a_str_sms_text&";Mobil: "&BeautifyNumber(q_select_contact.b_mobile)>
		</cfif>
		
		<cfif trim(q_select_contact.b_telephone) neq "">
			<cfset a_str_sms_text = a_str_sms_text&";Tel (Firma): "&BeautifyNumber(q_select_contact.b_telephone)>
		</cfif>	
	
		<cfif trim(q_select_contact.p_telephone) neq "">
			<cfset a_str_sms_text = a_str_sms_text&";Tel (priv): "&BeautifyNumber(q_select_contact.p_telephone)>
		</cfif>	
	
		<cfif trim(q_select_contact.p_mobile) neq "">
			<cfset a_str_sms_text = a_str_sms_text&";Mobil priv: "&BeautifyNumber(q_select_contact.p_mobile)>
		</cfif>
	
		<cfif trim(q_select_contact.email_prim) neq "">
			<cfset a_str_sms_text = a_str_sms_text&";E-Mail: "&q_Select_contact.email_prim>
		</cfif>
	
		<cfset a_str_sms_text = a_str_sms_text&";Info von "&request.a_struct_personal_properties.myfirstname&" "&request.a_struct_personal_properties.mysurname>
		
		<cfset a_str_sms_text = Mid(a_str_sms_text, 1, 160)>
	</cfcase>

	

	<cfcase value="1">
		<!--- 
			demo: //SCKE2BEGIN:VCARDN:Firstname Lastname TEL:number END:VCARD		
		--->	
		<cfif trim(q_select_contact.b_mobile) neq "">
			<cfset ANumber = q_select_contact.b_mobile>
		<cfelseif trim(q_select_contact.p_mobile) neq "">
			<cfset ANumber = q_select_contact.p_mobile>	
		<cfelse>
			<cfset ANumber = "">		
		</cfif>
		<cfset a_str_sms_text = "//SCKE2BEGIN:VCARDN:"&q_select_contact.firstname&" "&q_select_contact.surname&" TEL:"&BeautifyNumber(ANumber)&" END:VCARD">
	</cfcase>

	<cfcase value="2">
	<!--- extended
	
		BEGIN:VCARD
		VERSION: 2.1
		N:Posch,Hansjoerg
		TEL;Home:+4312345738
		TEL;CELL:+436763509515
		TEL;FAX:+12344354343
		END:VCARD
	--->	

	<cfset a_str_sms_text = "BEGIN:VCARD"&chr(13)&chr(10)&"VERSION: 2.1"&chr(13)&chr(10)>
	<cfset a_str_sms_text = a_str_sms_text&"N:"&q_select_contact.surname&";"&q_select_contact.firstname&chr(13)&chr(10)>

	<cfif trim(q_select_contact.b_telephone) neq "">
		<cfset a_str_sms_text = a_str_sms_text&"TEL;Work:"&BeautifyNumber(trim(q_select_contact.b_telephone))&chr(13)&chr(10)>
	</cfif>

	<cfif trim(q_select_contact.p_telephone) neq "">
		<cfset a_str_sms_text = a_str_sms_text&"TEL;Home:"&BeautifyNumber(trim(q_select_contact.p_telephone))&chr(13)&chr(10)>
	</cfif>

	<cfif trim(q_select_contact.email_prim) neq "">
		<cfset a_str_sms_text = a_str_sms_text&"EMAIL:"&trim(q_select_contact.email_prim)&chr(13)&chr(10)>
	</cfif>	

	<!--- cellular phone --->

	<cfif trim(q_select_contact.b_mobile) neq "">
		<cfset AMobileNumber = q_select_contact.b_mobile>
	<cfelseif trim(q_select_contact.p_mobile) neq "">
		<cfset AMobileNumber = q_select_contact.p_mobile>	
	<cfelse>
		<cfset AMobileNumber = "">
	</cfif>

	<cfif AMobileNumber neq "">
		<cfset a_str_sms_text = a_str_sms_text&"TEL;CELL:"&BeautifyNumber(trim(AMobileNumber))&chr(13)&chr(10)>	
	</cfif>
	

	<cfset a_str_sms_text = a_str_sms_text&"END:VCARD">
	</cfcase>

</cfswitch>



	
<!---<cfmodule template="../../account/points/getpointspersms.cfm"
	telnr=#SendContactPerSMS.Recipient#>

<cfmodule template="../../account/points/mod_account_check_points.cfm"
	pointsneeded = #PointsForOneSMSinthisNetwork#
	userid = #request.stSecurityContext.myuserid#>

<cfif mypointsenough is false>
	<cflocation url="../../account/index.cfm?action=NotEnoughPoints&returnurl=/addressbook/" addtoken="no">
</cfif>		

<cfmodule template="../../account/points/mod_account_debit.cfm"
	points = #PointsForOneSMSinthisNetwork#
	userid = #request.stSecurityContext.myuserid#
	action = -5>

<cfset a_str_sms_to = ReplaceNoCase(a_str_sms_to, " ", "", "ALL")>
<cfset a_str_sms_to = ReplaceNocase(a_str_sms_to, "-", "", "ALL")>
<cfset a_str_sms_to = ReplaceNocase(a_str_sms_to, "/", "", "ALL")>	
<cfset a_str_sms_to = ReplaceNocase(a_str_sms_to, "+", "", "ALL")>

<cfinvoke component="/components/mobile/cmp_sms" method="sendsms" returnvariable="stReturn">
	<cfinvokeargument name="userid" value="#request.stSecurityContext.myuserid#">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
	<cfinvokeargument name="body" value="#a_str_sms_text#">
	<cfinvokeargument name="sender" value="#request.a_struct_personal_properties.mymobiletelnr#">
	<cfinvokeargument name="recipient" value="#a_str_sms_to#">
	<cfinvokeargument name="dt_send" value="#now()#">
</cfinvoke>--->

<cfinvoke component="/components/mobile/cmp_sms" method="SendSMSEx" returnvariable="stReturn_sms_send">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="body" value="#a_str_sms_text#">
	<cfinvokeargument name="sender" value="#request.a_struct_personal_properties.mymobiletelnr#">
	<cfinvokeargument name="recipient" value="#a_str_sms_to#">
	<cfinvokeargument name="dt_send" value="#Now()#">
</cfinvoke> 