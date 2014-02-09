<cfcomponent output=false>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="../../scripts/scripts_ws.cfm">
	
	<cffunction access="remote" name="CreateFollowupJob" returntype="string" output="false" hint="create a follow up job (wiedervorlage)">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="The entrykey of the application">
		<cfargument name="objectkey" type="string" required="yes" hint="entrykey of object">
		<cfargument name="service" type="string" required="yes" hint="name of service">
		<cfargument name="type" type="numeric" required="yes" hint="type of follow up job">

		<cfreturn ''>
	</cffunction>
	
</cfcomponent>	