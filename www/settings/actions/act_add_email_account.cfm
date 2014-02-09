<!--- add an email account --->

<cfparam name="form.ssl" type="numeric" default="0">

<cfset a_cmp = createObject( 'component', request.a_str_component_mailconnector ) />

<cfset a_check = a_cmp.ConnectToIMAPAccountAndReturnStore( server = form.server, username = form.username, password = form.password, port = form.port, useSSL = form.ssl ) />

<cfif a_check.result>

	<cfset a_bol_create = application.components.cmp_email_accounts.CreateInternalEmailAccount(
					entrykey = createUUID(),
					emailaddress = form.email,
					server = form.server,
					password = form.password,
					displayname = form.displayname,
					port = form.port,
					usessl = form.ssl,
					origin = 0,
					createconfig = 0,
					userid = request.stSecurityContext.myuserid,
					userkey = request.stSecurityContext.myuserkey ) />
					
					
	<!--- add permission management ... --->
	<cfset session.stSecurityContext = application.components.cmp_security.GetSecurityContextStructure(userkey = request.stSecurityContext.myuserkey) />
	<cfset session.stUserSettings = application.components.cmp_user.GetUsersettings(userkey = request.stSecurityContext.myuserkey) />
	<cfset session.a_struct_personal_properties = application.components.cmp_session.CreateInternalSessionVars(userkey = request.stSecurityContext.myuserkey) />
	
	<cflocation addtoken="false" url="/email/">

<cfelse>

	<cflocation addtoken="false" url="/settings/?action=AddEmailAccount&error=#a_check.error#">

</cfif>