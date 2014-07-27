<cfcomponent>
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="LogEvent" output="false" returntype="boolean">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="action" type="string" required="yes">
		<cfargument name="sender" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">

		<cfreturn true>
	</cffunction>

</cfcomponent>