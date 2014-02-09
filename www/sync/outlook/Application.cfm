<!--- //

	Component:	OutlookSync
	Function:	Application.cfm file
	Description:
	
	Header:	

// ---><cfapplication name="ib_ol_sync_new" clientmanagement="yes" sessionmanagement="yes" setclientcookies="no" setdomaincookies="yes" sessiontimeout="#createtimespan(0,10,0,0)#">
<cfsetting requesttimeout="2000000" showdebugoutput="no">

<cfset tmp = SetLocale("German (Austrian)")>

<cfset request.a_str_request_entrykey = CreateUUID()>
<cfset request.a_tick_start = GetTickCount()>

<cferror type="exception" template="sendexception.cfm">

<!--- disable debug output ... would break this program ... --->
<cfsetting enablecfoutputonly="no">
<cfinclude template="/common/app/app_global.cfm">

<cftry>
<cfinclude template="queries/q_insert_log.cfm">
<cfcatch type="any">

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="ol sync log" type="html"><cfdump var="#cfcatch#"></cfmail>
</cfcatch></cftry>

<cfscript>
	SetEncoding('URL', 'ISO-8859-1');
	SetEncoding('FORM', 'ISO-8859-1');	
</cfscript>

<!--- check if the session cookie exists and the user is logged in ... --->

<cfif NOT StructKeyExists(session, 'stSecurityContext') AND StructKeyExists(url, 'IB_SESSION_KEY')>

	<!--- re-establish the securitycontext and usersettings ... --->
	<cfinvoke component="#request.a_str_component_session#" method="IsSessionOpen" returnvariable="a_bol_session_open">
		<cfinvokeargument name="sessionkey" value="#url.IB_SESSION_KEY#">
		<cfinvokeargument name="applicationname" value="#application.applicationname#">
		<cfinvokeargument name="ip" value="#cgi.REMOTE_ADDR#">
	</cfinvoke> 
	
	<cfif a_bol_session_open>
		
		<!--- load data ... --->
		<cfset a_struct_session_data = CreateObject('component', request.a_str_component_session).GetSessionStructData(sessionkey = #url.IB_SESSION_KEY#)>
		
		<cfloop list="#StructKeyList(a_struct_session_data)#" delimiters="," index="a_str_item">
			<cfset session[a_str_item] = a_struct_session_data[a_str_item]>
		</cfloop>
		
		<cfquery name="q_select_username" datasource="#request.a_str_db_users#">
		SELECT
			username
		FROM
			users
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">
		;
		</cfquery>
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="olSync session has been re-established" type="html">
		<cfdump var="#session#">
		</cfmail>		
	
	</cfif>
	
</cfif>




<cfif (CompareNoCase(cgi.SCRIPT_NAME, '/outlook/re/enable.cfm') NEQ 0) AND
	  (CompareNoCase(cgi.SCRIPT_NAME, '/outlook/re/action.cfm') NEQ 0)>
<cfcontent type="text/xml; charset=ISO-8859-1">
</cfif>

<!--- set temp directory for outlooksync --->
<cfset request.a_str_temp_dir_outlooksync = request.a_str_temp_directory&"outlooksync/">
<cfset request.a_str_temp_dir_outlooksync_settings = request.a_str_temp_directory&"outlooksync/settings/">

