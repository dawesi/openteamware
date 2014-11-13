<!--- //

	Module:		Session component
	Description:




	TODO hp: check Session functions for Update with newer version!

// --->


<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
+
	<cffunction access="public" name="CreateInternalSessionVars" output="false" returntype="struct"
			hint="return struct for internal session vars ...">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of user">

		<cfset var stReturn = StructNew() />
		<cfset var q_select_user = application.components.cmp_user.GetUserData(arguments.userkey) />

		<!--- return empty struct? ... --->
		<cfif q_select_user.recordcount IS 0>
			<cfreturn stReturn />
		</cfif>

		<cfinclude template="utils/session/inc_set_internal_session_vars.cfm">

		<cfreturn stReturn />

	</cffunction>

</cfcomponent>


