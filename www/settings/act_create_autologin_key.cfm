<!--- //

	create an autologin key now
	
	// --->
	
<!--- create and remove - --->
<cfset a_str_autologinkey = ReplaceNoCase(createuuid(), "-", "", "ALL")>

<!--- update database --->
<cfset SetAutologinKeyRequest.Autologinkey = a_str_autologinkey>
<cfset SetAutologinKeyRequest.Userid = request.stSecurityContext.myuserid>

<cfinclude template="queries/q_update_autologinkey.cfm">

<cflocation addtoken="no" url="default.cfm?action=autologin">