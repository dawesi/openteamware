<!--- //

	Component:	Assignments
	Description:Manage contacts to items like address book items or storage files
	

// --->

<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="AddAssignment" output="false" returntype="struct"
			hint="add a new assignment ...">
 		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="createdbyuserkey" type="string" required="yes">
		
		<cfset var stReturn = GenerateReturnStruct() />

		<cfinclude template="queries/q_insert_assignment.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="GetAssignments" output="false" returntype="query"
			hint="return assignments">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkeys" type="string" required="yes">
		
		<cfinclude template="queries/q_select_assignments.cfm">
		
		<cfinclude template="utils/inc_beautify_assignment_informations.cfm">
		
		<cfreturn q_select_assignments />		
	</cffunction>
	
	<cffunction access="public" name="DeleteAssignment" output="false" returntype="boolean">
 		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="userkey" type="string" required="yes">
		
		<cfinclude template="queries/q_delete_assignment.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="UpdateAssignment" output="false" returntype="boolean">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="createdbyuserkey" type="string" required="yes">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="RemoveAllAssignments" output="false" returntype="struct"
			hint="remove all assignments from an object">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = 0 />
		
		<!--- check permissions ... --->
		<cfinvoke component="#application.components.cmp_security#" method="GetPermissionsForObject" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#arguments.servicekey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.objectkey#">
		  </cfinvoke>
		  
		<cfif NOT stReturn_rights.edit>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<!--- ok, here we go ... --->
		<cfinclude template="queries/q_delete_all_assignments_to_object.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

</cfcomponent>
