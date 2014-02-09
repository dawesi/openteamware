<!--- //

	Component:	OutlookSync Login routine
	Function:	
	Description:
	
	Header:	

// ---><?xml version="1.0" encoding="utf-8"?>

<!---<cfif cgi.REMOTE_ADDR NEQ '62.99.232.51'>
	<cfset tmp = StructClear(session)>
	<code>400</code>
	<msg>Das Sync Service steht aufgrund technischer Probleme derzeit nicht zur Verfuegung - die Technik arbeitet daran. Due to technical problems the sync service is not available now. Our staff is working on it.</msg>
	<serverutctime></serverutctime>
	<key></key>
	<urltoken></urltoken>
	
	<cfabort>
</cfif>--->

<cfsetting enablecfoutputonly="yes">
<cfparam name="form.username" type="string" default="">
<cfparam name="form.password" type="string" default="">
<cfparam name="form.install_name" type="string" default="">
<cfparam name="form.computerid" type="string" default="">
<cfparam name="form.version" type="string" default="">

<cfif IsDefined("url.username")>
	<cfset form.username = url.username />
</cfif>

<cfif IsDefined("url.password")>
	<cfset form.password = url.password />
</cfif>

<!--- add the domain if the user has forgotten it --->
<cfif FindNoCase("@", form.username) is 0>
	<cfset form.username = form.username & '@' & request.appsettings.properties.defaultdomain />
</cfif>

<!--- load user data --->
<cfinclude template="queries/q_userlogin.cfm">

<!--- get timezone information ... --->
<CFSET info = GetTimeZoneInfo() />

<!--- get UTC time --->
<cfset a_dt_utc_time = DateAdd("h", info.utcHourOffset, now()) />

<!--- format utc time --->
<cfset a_str_utc_time = DateFormat(a_dt_utc_time, "dd.mm.yyyy")&" "&TimeFormat(a_dt_utc_time, "HH:mm:ss") />

<cfsetting enablecfoutputonly="false">

<result>

<cfif (q_USERLOGIN.recordcount is 1)>

	<cfcookie name="CFID" value="#client.CFID#" expires="never">
	<cfcookie name="CFTOKEN" value="#client.CFToken#" expires="never">

	<cfinvoke component="#application.components.cmp_licence#" method="TrialPhaseExipired" returnvariable="a_bol_trial_expired">
		<cfinvokeargument name="companykey" value="#q_userlogin.companykey#">
	</cfinvoke>
	
	<cfif a_bol_trial_expired>
		<cfset tmp = StructClear(session)>
		<code>400</code>
		<msg>Ihre Testphase ist abgelaufen - bestellen Sie bitte online! Wenden Sie sich bei Fragen bitte an feedback@openTeamWare.com</msg>
		<serverutctime><cfoutput>#xmlformat(a_str_utc_time)#</cfoutput></serverutctime>
		<key></key>
		<cfabort>
	</cfif>

	<cfsilent>
		
	<cfinclude template="/login/act_internal_login.cfm">
	
	<!--- create security structures ... --->
	<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
		<cfinvokeargument name="userkey" value="#q_userlogin.entrykey#">
	</cfinvoke>
	
	<cfset session.stSecurityContext = stReturn />
	
	<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
		<cfinvokeargument name="userkey" value="#q_userlogin.entrykey#">
	</cfinvoke>
	
	<cfset session.stUserSettings = a_struct_settings />
	
	<!--- set the session key ... --->
	<cfset a_str_session_key = hash(session.URLToken) />
	
	<!--- the session cookie ... --->	
	<cfcookie name="ib_session_key" value="#a_str_session_key#">	
	
	<cfset session.a_str_sessionkey = a_str_session_key>

	<!--- open the internal session ... --->
	<cfinvoke component="#request.a_str_component_session#" method="CreateSessionEntry" returnvariable="ab">
		<cfinvokeargument name="sessionkey" value="#a_str_session_key#">
		<cfinvokeargument name="userkey" value="#session.stSecurityContext.myuserkey#">
		<cfinvokeargument name="applicationname" value="#application.applicationname#">
		<cfinvokeargument name="ip" value="#cgi.REMOTE_ADDR#">
		<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
		<!--- veeeeeeery long timeout ... --->
		<cfinvokeargument name="defaulttimeoutinminutes" value="600">
	</cfinvoke>
	
	</cfsilent>
	
	<code>200</code>
	<msg>ok</msg>
	<serverutctime><cfoutput>#xmlformat(a_str_utc_time)#</cfoutput></serverutctime>
	<key><cfoutput>#xmlformat(ib_session_key)#</cfoutput></key>
	
	<!--- da hamma das problem ... --->
	<cfset a_str_token = ''>
	<cfset a_str_token = '&CFTOKEN='&client.CFToken&'&CFID='&client.CFID>
	<urltoken><cfoutput>#xmlformat(a_str_token)#</cfoutput></urltoken>
	<!---<urltoken><cfoutput>#xmlformat(session.URLToken)#</cfoutput></urltoken>--->
	
	<cfif (len(form.computerid) gt 0) AND (len(form.install_name) gt 0)>
		<!--- update install name ... --->
		<cfinclude template="queries/q_insert_update_install_name.cfm">
	</cfif>
	
	<!--- load other setups of this user ... in case he's upgrading his computer --->
	<cfinclude template="queries/q_select_other_setups.cfm">
	<othersetups>
		<cfoutput query="q_select_other_setups">
		<othersetup>
			<othersetup_install_name>#xmlformat(q_select_other_setups.install_name)#</install_name>
			<othersetup_data_count></data_count>
			<othersetup_dt_lastsync>#xmlformat(q_select_other_setups.dt_lastmodified)#</dt_lastsync>
			<othersetup_program_id>#xmlformat(q_select_other_setups.program_id)#</othersetup_program_id>
		</othersetup>
		</cfoutput>
	</othersetups>
	
<cfelse>
	<!--- fehler --->
	<cfset tmp = StructClear(session)>
	<code>400</code>
	<msg>Ein falsches Passwort wurde eingegeben!</msg>
	<serverutctime><cfoutput>#xmlformat(a_str_utc_time)#</cfoutput></serverutctime>
	<key></key>
	<urltoken><cfoutput>#xmlformat(client.URLToken)#</cfoutput></urltoken>
</cfif>
</result>

