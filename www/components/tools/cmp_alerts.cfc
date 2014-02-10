<cfcomponent output='false'>

	<!--- //
	
		alert settings
		
		// --->

	<cfinclude template="/common/app/app_global.cfm">

	<cffunction access="public" name="GetAlertSettings" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false">
		
		<cfinclude template="queries/q_select_alert_settings.cfm">
		
		<cfreturn q_select_alert_settings>
	</cffunction>
	
	<cffunction access="public" name="SaveAlertSettings" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<!--- if empty for the whole service ... --->
		<cfargument name="objectkey" type="string" required="false" default="">
		<cfargument name="actions" type="string" required="true">
		<cfargument name="notifyemail" type="numeric" default="1" required="false">
		<cfargument name="notifysms" type="numeric" default="0" required="false">
		
		<cfreturn true>
	</cffunction>

</cfcomponent>