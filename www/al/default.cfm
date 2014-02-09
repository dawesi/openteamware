<!--- //



	autologin

	

	...

	

	<io>

		<in>

		<param name="key" scope="url" type="string" default="">

		<description>

		the autologin key ... created by uuid

		</description>

		</param>

		</in>

	</io>

	

	<modul>

		The key is validated against the user database and if the key

		if correct the user is logged in and forwarded to the desired targetpage

		

		default: home

	

	</modul>

	

	// --->
<cfparam name="url.key" default="" type="string">

<!--- check if the user is already logged in ... if yes, logout ... --->
<cfif IsDefined("request.stSecurityContext.myuserid")>
  <!--- end a possible session --->
  <cflock type="exclusive" scope="session" timeout="3">
    <cfset tmp = structclear(session)>
  </cflock>
</cfif>

<cfset a_str_key = trim(url.key)>

<cfif len(a_str_key) is 0>
  <!--- no key given --->
  <cflocation addtoken="no" url="/">
</cfif>


<!--- validate against the user database --->
<cfset SelectAutologinkeyRequest.key = a_str_key>
<cfinclude template="../login/queries/q_select_autologinkey.cfm">

<!--- valid? --->
<cfif a_return_bol_found is false>
  <!--- no such user found --->
  <cflocation addtoken="no" url="/">
</cfif>

<!--- set form variables now and connect --->
<cfset FORM.frmUsername = a_return_str_username>
<cfset form.frmPassword = a_return_str_password>
<!--- do login now --->
<cfinclude template="../login/act_login.cfm">