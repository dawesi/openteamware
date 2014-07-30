<!--- //

	Module:		Framework
	Description:check login data and load session variables


// --->

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="form.frmdomain" type="string" default="#request.appsettings.properties.defaultdomain#">
<cfparam name="form.frmusername" type="string" default="">
<cfparam name="form.frmpassword" type="string" default="">
<cfparam name="form.frmpassword_md5" type="string" default="">

<cfif Len(form.frmdomain) IS 0>
	<cfset form.frmdomain = 'openTeamware.com' />
</cfif>

<!--- data provided? --->
<cfset a_bol_fields_not_providedovided = ((Len(form.frmusername) IS 0) AND (Len(form.frmpassword) IS 0)) />

<cfif a_bol_fields_not_providedovided>
	<cflocation addtoken="No" url="../help/index.cfm?action=login&error=noaccount">
</cfif>

<cfset a_str_username = form.frmUsername />
<cfset a_str_password = form.frmpassword />
<cfset a_str_password_md5 = form.frmpassword_md5 />

<!--- domain provided? if not, use default domain ... --->
<cfif FindNoCase('@', a_str_username) IS 0>
	<cfset a_str_username = a_str_username & '@' & form.frmdomain />
</cfif>

<!--- Check simple login ... --->
<cfinvoke component="#application.components.cmp_security#" method="CheckLoginData" returnvariable="stReturn">
	<cfinvokeargument name="username" value="#a_str_username#">
	<cfinvokeargument name="password_md5" value="#a_str_password_md5#">
	<cfinvokeargument name="password" value="#a_str_password#">
	<cfinvokeargument name="log_login" value="true">
</cfinvoke>

<!--- an error occured ... --->
<cfif NOT stReturn.result>

	<cfswitch expression="#stReturn.error#">
		<cfcase value="201">
			<!--- open invoices ... --->
			<cflocation addtoken="no" url="../content/pages/dunningletter/">
		</cfcase>
		<cfdefaultcase>
			<!--- other ... --->
			<cflocation addtoken="No" url="index.cfm?loginfailed=true&ibxerrorno=#stReturn.error#">
		</cfdefaultcase>
	</cfswitch>

</cfif>

<!--- query holding the user data ... --->
<cfset q_userlogin = stReturn.q_userdata />

<!--- set various session vars ... add structure to session scope ... --->
<!--- <cfset StructAppend(session, application.components.cmp_session.CreateInternalSessionVars(userkey = q_userlogin.entrykey)) />
 --->
<!--- add permission management ... --->
<cfset session.stSecurityContext = application.components.cmp_security.GetSecurityContextStructure(userkey = q_userlogin.entrykey) />
<cfset session.stUserSettings = application.components.cmp_user.GetUsersettings(userkey = q_userlogin.entrykey) />
<cfset session.a_struct_personal_properties = application.components.cmp_session.CreateInternalSessionVars(userkey = q_userlogin.entrykey) />

<!--- create session key ... --->
<cfinvoke component="#application.components.cmp_session#" method="CreateSessionEntry" returnvariable="a_struct_create_session">
	<cfinvokeargument name="userkey" value="#q_userlogin.entrykey#">
	<cfinvokeargument name="applicationname" value="#application.applicationname#">
	<cfinvokeargument name="ip" value="#cgi.REMOTE_ADDR#">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
</cfinvoke>

<!--- client variable setzen --->
<cfset client.LastLoginUsername = a_str_username />

<!--- get forwarding target ... --->
<cfset alocation = "/" />

<cfif StructKeyExists(form, 'url') AND Len(trim(form.url)) GT 0>
	<cfset ALocation = UrlDecode(form.URL) />
</cfif>

<cfset a_struct_medium_logo = application.components.cmp_customize.GetCustomStyleData(usersettings = session.stUserSettings, entryname = 'medium_logo') />

<html>
	<head>

	<meta http-equiv="refresh" content="1;URL=<cfoutput>#alocation#</cfoutput>" />

	<script type="text/javascript">
		location.href = "<cfoutput>#alocation#</cfoutput>";
	</script>
	</head>
<body>

<table width="100%" height="98%" border="0">
	<tr>
		<td align="center" valign="middle">

		<div style="width:420px;padding:10px;background-color:white; " class="b_all">

		<cfoutput>#GetLangVal('lg_ph_title')#</cfoutput>

		<table width="100%" border="0" cellpadding="4" cellspacing="0">
		    <tr>
				<td align="center">

				<cftry>
				<cfoutput>
					<a href="/"><img src="#a_struct_medium_logo.path#" width="#a_struct_medium_logo.width#" height="#a_struct_medium_logo.height#" hspace="10" vspace="10" border="0"></a>
				</cfoutput>

				<cfcatch type="any">
				</cfcatch>
				</cftry>

				</td>
			</tr>
			<tr>
				<td align="center"><b><cfoutput>#GetLangVal('lg_ph_login_success')#</cfoutput></b></td>
			</tr>
			<tr>
				<td style="padding:10px;line-height:20px;" align="center">

				<cfoutput>#request.a_str_img_tag_status_loading#</cfoutput>
				<br />
				<br />

				<cfoutput>#GetLangVal('lg_ph_login_success_2')#</cfoutput><br>

				(<a href="<cfoutput>#alocation#</cfoutput>"><cfoutput>#GetLangVal('lg_ph_login_auto_forward')#</cfoutput> ...</a>)

				</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
</table>


<cftry>

	<cfquery name="q_update_homepage_tracking">
	UPDATE
		homepage_tracking
	SET
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_username#">
	WHERE
		clientid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.URLToken#">
	;
	</cfquery>

<cfcatch type="any">

</cfcatch>
</cftry>

<!--- for google analytics ... --->
<cfcookie name="ib_returning_customer" value="true" expires="never">

</body>
</html>

