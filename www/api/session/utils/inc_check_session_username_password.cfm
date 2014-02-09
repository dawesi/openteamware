<!--- //

	check username/password combination
	
	// --->

<cfset ii = FindNoCase(':', arguments.clientkey)>

<cfset a_str_username = Mid(arguments.clientkey, 1, (ii - 1))>

<cfset a_str_password = Mid(arguments.clientkey, (ii + 1), Len(arguments.clientkey))>

<cflog text="a_str_username: #a_str_username#" type="Information" log="Application" file="ib_ws">
<cflog text="a_str_password: #a_str_password#" type="Information" log="Application" file="ib_ws">

<!--- check if this app owner is allowed to manage this customer in such a way ... --->



<cflog text="checking login" type="Information" log="Application" file="ib_ws">

<!--- check now simple login ... --->
<cfinvoke component="#application.components.cmp_security#" method="CheckSimpleLogin" returnvariable="a_bol_check_login">
	<cfinvokeargument name="username" value="#a_str_username#">
	<cfinvokeargument name="password" value="">
	<cfinvokeargument name="password_md5" value="#a_str_password#">
</cfinvoke>


<cfif NOT a_bol_check_login>
	<cflog text="login failed!" type="Information" log="Application" file="ib_ws">
	<cfset tmp = SetErrorMessageByNumberAndReturnXMLResponse(100, stReturn)>
</cfif>

<cflog text="a_bol_check_login: #a_bol_check_login#" type="Information" log="Application" file="ib_ws">

<cfset a_str_userkey = application.components.cmp_user.GetEntrykeyFromUsername(a_str_username)>

<!--- set clientkey for further operations to the hashkey ...
	easier because password might contain invalid chars for a structure element (e.g. a point) --->
<cfset arguments.clientkey = a_str_hash_clientkey>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stSecurityContext">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>
		
<cfset application.directaccess.securitycontext[a_str_hash_clientkey] = stSecurityContext>
		
<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stUserSettings">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>
		
<cfset application.directaccess.usersettings[a_str_hash_clientkey] = stUserSettings>		