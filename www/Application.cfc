<!--- //
	Basic application for otw
// --->
<cfcomponent output="false" hint="Application ...">

<!--- generate unique app name --->
<cfset variables.sAppName = "app_otw_" & ReplaceNoCase(ReplaceNoCase( ListFirst( cgi.HTTP_HOST, ':') , ".", "", "ALL"), ':', '', 'ALL') />

<cfscript>
  this.name = variables.sAppName;
  this.clientmanagement= "yes";
  this.loginstorage = "session";
  this.sessionmanagement = "yes";
  this.sessiontimeout = createTimeSpan(0,0,60,0);
  this.setClientCookies = "yes";
  this.setDomainCookies = "no";
  this.datasource		= 'mycrm';
</cfscript>

<!--- application is starting ... --->
<cffunction name="onApplicationStart" returnType="boolean">
	<!--- do we have any special instance running here? ... default = empty string
	
		in ColdFusion, CGI.* will always return a value, in case it does not exist,
		an empty value, so no StructKeyExists query is necessary
		--->
	<cfset application.OTW_INSTANCE_UUID = cgi.OTW_INSTANCE_UUID />
	
	<cfreturn true />
</cffunction>

<!--- new request coming in ... --->
<cffunction name="onRequest" returnType="void">
	<cfargument name="ThePage" type="string" required="true">

	<!--- set encoding ... --->
	<cfscript> 
	setEncoding("FORM","UTF-8");
	setEncoding("URL","UTF-8");
	</cfscript> 

	<!--- force the browser to load every page every time (no caching ... )... --->
	<CFHEADER NAME="Cache-control" VALUE="no-cache">
	<CFHEADER NAME="Pragma" VALUE="no-cache">
	<CFHEADER NAME="Expires" VALUE="Thu, 01 Dec 1994 16:00:00 GMT">

	<cfinclude template="app_global.cfm">

	<cfinclude template="common/session/inc_check_session.cfm">

	<cfinclude template="#ARGUMENTS.ThePage#">
	
</cffunction>

<!--- request has been finished ... call on Request end page ... --->
<cffunction name="onRequestEnd" returnType="void">
   <cfargument type="String" name="targetPage" required="true" />
	<cfinclude template="common/app/doonrequestend.cfm">
</cffunction>

<!--- session has ended .. --->
<cffunction name="onSessionEnd" output="false">
    <cfargument name="sessionscope" type="struct" required="true" />
    <cfargument name="applicationScope" type="struct" required="true" />
	
	<cfinclude template="common/app/doonsessionend.cfm">
	
</cffunction>

<!--- an error occurred ... --->
<cffunction name="onError" output="true">
     <cfargument name="exception" required="true" />
     <cfargument name="eventName" type="String" required="true" />

	<cfinclude template="common/app/show_error_occured.cfm">
		
</cffunction>

<!--- return render component ... --->
<cffunction access="public" name="GetRenderCmp" returntype="any"
		hint="return the render component">
	<cfreturn CreateObject('component', request.a_str_component_render) />
</cffunction>

</cfcomponent>
