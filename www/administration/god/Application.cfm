<!--- //

	Module:		Administration/God
	Description: 
	
// --->
<cfapplication clientmanagement="true" name="ibx_admin" setclientcookies="true" sessionmanagement="true">

<cfinclude template="/common/app/app_global.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="form.frmusername" type="string" default="">
<cfparam name="form.frmpassword" type="string" default="">

<cfif NOT StructKeyExists(session, 'stSecurityContext')>
	
	<cfinvoke component="#application.components.cmp_security#" method="CheckSimpleLogin" returnvariable="a_bol_return">
		<cfinvokeargument name="username" value="#form.frmusername#">
		<cfinvokeargument name="password" value="#form.frmpassword#">
	</cfinvoke>

	<!--- login login, if OK, create security structure ... --->	
	<cfif a_bol_return>

		<cfset a_str_userkey = application.components.cmp_user.GetEntrykeyFromUsername(form.frmusername) />
		
		<cfset session.stSecurityContext = application.components.cmp_security.GetSecurityContextStructure(a_str_userkey) />
		<cfset session.stUserSettings = application.components.cmp_user.GetUsersettings(a_str_userkey) />

	<cfelse>
		<form action="default.cfm" method="post">
		Username: <input type="text" name="frmusername" value="@openTeamWare.com" />
		<br />
		Password: <input type="password" name="frmpassword" value="" /> 
		<br />
		<input type="submit" value="Login" /> 
		</form>
		
		<h4>Login needed.</h4>
		<cfabort>
	</cfif>
</cfif>

<cfif ListFindNoCase('D647FD1E-9A03-4838-B99FB15B6A50EA12',session.stSecurityContext.myuserkey) is 0>
	<cfabort>
</cfif>

<!--- copy data to request scope --->
<cflock scope="session" timeout="30" type="readonly">		
	<cfset tmp = CopyUserStructuresFromSession2RequestScope() />
</cflock>

