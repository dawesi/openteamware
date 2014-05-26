<!--- //

	Module:		AddressBook
	Action:		doPostBackgroundAction
	Description:Load a contact, create an account and update contact with new parentkey
	
// --->

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_object">
	<cfinvokeargument name="entrykey" value="#a_struct_parse.data.contactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadmetainformations" value="true">
</cfinvoke>

<cfif a_struct_object.result>

	<cfset q_select_contact = a_struct_object.q_select_contact />
	
	<cfif Len(q_select_contact.company) IS 0>
		<script type="text/javascript">
			OpenErrorMessagePopup('1100');
		</script>
		
		<cfexit method="exittemplate">
	</cfif>
	
	<!--- create an account ... --->
	<cfset sEntrykey_account = CreateUUID() />
	
	<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="stReturn_create_account">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="contacttype" value="1">
		<cfinvokeargument name="company" value="#q_select_contact.company#">
		<cfinvokeargument name="department" value="#q_select_contact.department#">
		<cfinvokeargument name="email_prim" value="#q_select_contact.email_prim#">
		<cfinvokeargument name="categories" value="#q_select_contact.categories#">
		<cfinvokeargument name="criteria" value="#q_select_contact.criteria#">
		<cfinvokeargument name="nace_code" value="#q_select_contact.nace_code#">
		<cfinvokeargument name="b_street" value="#q_select_contact.b_street#">
		<cfinvokeargument name="b_city" value="#q_select_contact.b_city#">
		<cfinvokeargument name="b_zipcode" value="#q_select_contact.b_zipcode#">
		<cfinvokeargument name="b_country" value="#q_select_contact.b_country#">
		<cfinvokeargument name="b_telephone" value="#q_select_contact.b_telephone#">
		<cfinvokeargument name="b_telephone_2" value="#q_select_contact.b_telephone_2#">
		<cfinvokeargument name="b_fax" value="#q_select_contact.b_fax#">
		<cfinvokeargument name="b_url" value="#q_select_contact.b_url#">
		<cfinvokeargument name="notice" value="#q_select_contact.notice#">
		<cfinvokeargument name="language" value="#q_select_contact.lang#">
	</cfinvoke>
	
	<cfset sEntrykey_account = stReturn_create_account.entrykey />
	
	<!--- update old one ... --->
	<cfset stUpdate = StructNew() />
	<cfset stUpdate.parentcontactkey = sEntrykey_account />
			
	<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#a_struct_parse.data.contactkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="newvalues" value="#stUpdate#">
		<cfinvokeargument name="updatelastmodified" value="false">
	</cfinvoke>
	
	<script type="text/javascript">
	GotoLocHref('index.cfm?action=ShowItem&entrykey=<cfoutput>#urlencodedformat(sEntrykey_account)#</cfoutput>');
	</script>
</cfif>