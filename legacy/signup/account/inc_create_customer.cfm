<!--- //

	create the customer & user
	
	// --->
	
<cfset a_str_pwd = CheckDataStored('password') />
<cfset a_str_customerkey = CreateUUID() />

<cfset a_str_username = lcase(CheckDataStored('username') & '@' & request.appsettings.properties.defaultdomain) />
<cfset a_str_subscriber_username = a_str_username>

<!--- business or private? --->
<cfif Len(CheckDataStored('company')) GT 0>
	<cfset a_int_customertype = 1>
	<cfset a_str_customername = CheckDataStored('company')>
<cfelse>
	<cfset a_int_customertype = 0>
	<cfset a_str_customername = CheckDataStored('firstname') & ' ' & CheckDataStored('surname')>	
</cfif>

<cfif Len(form.frmsystempartnerkey) IS 0>
	<!--- default entrykey for partner --->
	
	<!--- be aware of cobranded resellers ... --->
	
	
	<!---<cfset form.frmsystempartnerkey = '5872C37B-DC97-6EA3-E84EC482D29FC169'>--->
	
	<cfset form.frmsystempartnerkey = a_str_default_partner_key>
</cfif>

<cfinclude template="queries/q_select_http_referer.cfm">

<!--- create the customer ... --->
<cfinvoke component="#application.components.cmp_customer#" method="CreateCustomer" returnvariable="a_bol_return">
	<cfinvokeargument name="resellerkey" value="#form.frmsystempartnerkey#">
	<cfinvokeargument name="distributorkey" value="#form.frmdistributorkey#">
	<cfinvokeargument name="entrykey" value="#a_str_customerkey#">
	
	<!--- not really assigned yet --->
	<cfif Compare('5872C37B-DC97-6EA3-E84EC482D29FC169', form.frmsystempartnerkey) IS 0>
		<cfset a_str_assigned = 0>
	<cfelse>
		<cfset a_str_assigned = 1>
	</cfif>
	
	<cfinvokeargument name="assignedtoreseller" value="#a_str_assigned#">
	
	<!--- status = trial --->
	<cfinvokeargument name="status" value="1">
	<cfinvokeargument name="companyname" value="#a_str_customername#">
	<cfinvokeargument name="contactperson" value="#Trim(CheckDataStored('title') & ' ' & CheckDataStored('firstname') & ' ' & CheckDataStored('surname'))#">

	<!--- private or organisation? --->
	<cfinvokeargument name="customertype" value="#a_int_customertype#">
	<cfinvokeargument name="httpreferer" value="#q_select_http_referer.referer#">
	<cfinvokeargument name="domains" value="#request.appsettings.properties.defaultdomain#">
	<cfinvokeargument name="telephone" value="#CheckDataStored('telephone')#">
	<cfinvokeargument name="street" value="#CheckDataStored('street')#">
	<cfinvokeargument name="zipcode" value="#CheckDataStored('zipcode')#">
	<cfinvokeargument name="city" value="#CheckDataStored('city')#">
	<cfinvokeargument name="countryisocode" value="#CheckDataStored('country')#">
	<cfinvokeargument name="country" value="#CheckDataStored('country')#">
	<cfinvokeargument name="email" value="#CheckDataStored('external_email')#">
	<cfinvokeargument name="industry" value="#CheckDataStored('industry')#">
	
	<cfif CheckDataStored('source') NEQ ''>
		<cfinvokeargument name="source" value="#CheckDataStored('source')#">
	<cfelse>
		<!--- take the user paramter ... --->
		<cfinvokeargument name="source" value="#form.frmsource_2#">
	</cfif>
	
</cfinvoke>


<!--- create the user ... --->
<cfinvoke component="#application.components.cmp_user#" method="CreateUser" returnvariable="stReturn">
	<cfinvokeargument name="firstname" value="#CheckDataStored('firstname')#">
	<cfinvokeargument name="surname" value="#CheckDataStored('surname')#">
	<cfinvokeargument name="username" value="#a_str_username#">
	<cfinvokeargument name="title" value="#CheckDataStored('title')#">
	<cfinvokeargument name="position" value="#CheckDataStored('position')#">
	<cfinvokeargument name="companykey" value="#a_str_customerkey#">
	<cfinvokeargument name="password" value="#CheckDataStored('password')#">
	<cfinvokeargument name="sex" value="#val(CheckDataStored('sex'))#">
	
	<cfinvokeargument name="address1" value="#CheckDataStored('street')#">
	<cfinvokeargument name="city" value="#CheckDataStored('city')#">
	<cfinvokeargument name="country" value="#CheckDataStored('country')#">
	<cfinvokeargument name="externalemail" value="#CheckDataStored('external_email')#">
	
	<!--- default ... --->
	<cfinvokeargument name="utcdiff" value="-1">
	<cfinvokeargument name="createmailuser" value="true">
	<cfinvokeargument name="language" value="#client.langno#">
</cfinvoke>

<cfif NOT stReturn.result>

	<!--- error! --->
	<h1>An error occured while creating your user (<cfoutput>#stReturn.errormessage#</cfoutput>) - please contact Feedback@openTeamWare.com!</h1>
	
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="error on signup (could not create user)" type="html">
		<cfdump var="#stReturn#" label="stReturn vom user script">
		<cfdump var="#session#" label="session">
	</cfmail>
	
</cfif>

<cfset a_str_userkey = stReturn.entrykey>

<!--- create a customer contact --->
<cfinvoke component="#application.components.cmp_customer#" method="AddCustomerContact" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#a_str_customerkey#">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<!--- auto login ... load userdata --->
<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
	<cfinvokeargument name="entrykey" value="#a_str_userkey#">
</cfinvoke>

<!--- check default settings

	crm, bonus points, newsletter, fax ... --->
<cfinclude template="inc_check_default_settings.cfm">

<!--- create other users ... --->
<cfinclude template="inc_create_workgroup_and_other_users.cfm">

<!--- send welcome message ... --->
<cfinvoke component="#application.components.cmp_content#" method="SendWelcomeMail" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="companykey" value="#a_str_customerkey#">
</cfinvoke>

<!--- check promocode --->
<!---<cfif Len(form.frmpromocode) GT 0>
	<cfinclude template="inc_save_promocode.cfm">
</cfif>

<cfif Len(url.frmkeyword) GT 0>
	<cfinclude template="inc_save_keyword.cfm">
</cfif>--->

<!--- clear session ... --->
<cfset tmp = StructClear(session)>

<cfset session.al_key = a_struct_load_userdata.query.autologin_key>

<cflocation addtoken="no" url="show_thank_you.cfm">