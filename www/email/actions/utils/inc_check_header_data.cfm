<!--- //

	Module:		EMail
	Action:		ActCheckSendMailOperation
	Description:Check the desired Sendmail operation ...
	
				Do verify the headers ...
	

// --->

<cfset variables.a_arr_addheaders = ArrayNew(1)>
<cfset request.a_str_current_msg_references = ''>

<cfif FindNoCase(request.a_str_default_domain, form.mailfrom) is 0>
	<!--- add a "Sender" on external addresses --->
	
	<!--- check if user wants to surpress the sender address --->
	<cfset a_int_surpress_sender_on_external_address = GetUserPrefPerson('email', 'surpresssender.onexternaladdress', '0', '', false)>
		
	<cfif a_int_surpress_sender_on_external_address IS 0>
		<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
		<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
		<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "Sender", true)>
		<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", request.stSecurityContext.myusername, true)>
	<cfelse>
		<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
		<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
		<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "X-InBoxcc-Sender", true)>
		<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", request.stSecurityContext.myusername, true)>	
	</cfif>
	
</cfif>

<!--- references ... --->
<cfif Len(form.frmreferences) GT 0>
	<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
	<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "References", true)>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", form.frmreferences, true)>
	
	<cfset request.a_str_current_msg_references = form.frmreferences>
</cfif>

<!--- securemail operation ... --->
<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "X-SecureMailOperation", true)>
<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", form.frmsmaction, true)>


<cfif Len(form.frmcbvcard) IS 1>
	<!--- attach vcard? --->
	<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
	<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "X-Attachvcard", true)>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", 1, true)>
</cfif>

<cfif Len(form.frmjobkey) GT 0>
	<!--- signedmail jobkey --->
	<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
	<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "X-Jobkey", true)>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", form.frmjobkey, true)>
</cfif>

<cfif form.frmRequestReadConfirmation IS 1>
	<!--- request a read/open confirmation --->
	<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
	<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "Disposition-Notification-To", true)>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", request.stSecurityContext.myusername, true)>	
</cfif>

<!--- wddx data in order to keep it on forwarding ... --->
<cfwddx input="#a_arr_addheaders#" output="a_str_wddx_addheader" action="cfml2wddx">

