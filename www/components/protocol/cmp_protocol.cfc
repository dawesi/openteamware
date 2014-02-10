<cfcomponent output=false>
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="CreateProtocolEntry" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes" hint="context of user who has done the action">
		<cfargument name="servicekey" type="string" required="yes" hint="entrykey of service">
		<cfargument name="objectkey" type="string" required="yes" hint="entrykey of object">
		<cfargument name="message" type="string" required="no" default="" hint="custom message">
		<cfargument name="userkey" type="string" required="yes" hint="userkey of the user for which the action has been taken">
		<cfargument name="action" type="string" required="no" default="" hint="action: edit/delete/create">
		
		<cfinclude template="queries/q_insert_protocol.cfm">
		
		<cfreturn true>
	</cffunction>

</cfcomponent>