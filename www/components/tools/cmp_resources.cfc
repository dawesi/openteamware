<!--- //

	Module:		Resources
	Description:Manage resources for calendar
	

// --->

<cfcomponent output="false">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="CreateResource" output="false" returntype="struct"
					hint="create a new resource">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" default="" required="false">
		<cfargument name="workgroupkeys" type="string" default="" required="false"
					hint="entrykeys of workgroups allowed to use this resource">
		<cfargument name="createdbyuserkey" type="string" default="" required="false">
		<cfargument name="exclusive" type="boolean" default="true" required="false"
					hint="always true, resources are exclusive alltogether">
		<cfargument name="companykey" type="string" required="true"
					hint="entrykey of company for which the resource is created">
		<cfargument name="location" type="string" required="false" default="">
		
		<cfset var stReturn = GenerateReturnStruct()>
		<cfset var sEntrykey = CreateUUID()>
		
		<cfif Len(arguments.title) IS 0>
			<cfreturn stReturn>
		</cfif>
		
		<cfinclude template="queries/resources/q_insert_resource.cfm">
		
		<cfreturn stReturn>
		
	</cffunction>
	
	<cffunction access="public" name="GetAvailableResources" output="false" returntype="query"
			hint="return the list of available resources">
		<cfargument name="securitycontext" type="struct" required="true">
		
		<cfset var a_str_workgroupkeys = ValueList(arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)>
		
		<!--- not member in a single workgroup? --->
		<cfif Len(a_str_workgroupkeys) IS 0>
			<cfset a_str_workgroupkeys = 'thiskeydoesnotexist'>
		</cfif>
		
		<!--- return resources for this companykey and these workgroups ... --->
		<cfreturn GetResources(companykey = arguments.securitycontext.mycompanykey, workgroupkeys = a_str_workgroupkeys)>
	</cffunction>
	
	
	<cffunction access="public" name="GetResourcesByEntrykeys" output="false" returntype="query">
		<cfargument name="entrykeys" type="string" required="true" hint="list if entrykeys of the resources we want to select">
		
		<cfset var q_select_resources = 0 />
		
		<cfinclude template="queries/resources/q_select_resources.cfm">
		<cfreturn q_select_resources />
	</cffunction>
	
	
	<cffunction access="public" name="GetResources" output="false" returntype="query">
		<!--- companykey ... --->
		<cfargument name="companykey" type="string" required="true"
					hint="entrykey of company for which the resources are needed">
		<cfargument name="workgroupkeys" type="string" required="false" default=""
					hint="list of workgroupkeys for which to return the resources ... if blank, return data for all workgroupkeys">
		
		<cfset var q_select_resources = 0 />
		
		<cfinclude template="queries/resources/q_select_resources.cfm">
		
		<cfreturn q_select_resources />
	</cffunction>
	
	<cffunction access="public" name="DeleteResource" output="false" returntype="struct"
			hint="delete a resource">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of resource">
			
		<cfset var stReturn = GenerateReturnStruct() />

		<cfinclude template="queries/resources/q_delete_resource.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="EditResource" output="false" returntype="struct"
					hint="update a resource">
		<cfargument name="companykey" type="string" required="true"
					hint="entrykey of company for which the resources are needed">
		<cfargument name="entrykey" type="string" required="true"
					hint="entrykey of resource">
		<cfargument name="newvalues" required="true" type="struct"
					hint="structure with new values ...">
					
		<cfset var stReturn = GenerateReturnStruct()>
		
		<!--- TODO: call update SQL ... --->
		
		<cfreturn stReturn>
	</cffunction>	
	
	<cffunction access="public" name="DoesResourceExists" output="false" returntype="boolean"
			hint="return true if a resource exists ...">
		<cfargument name="securitycontext" type="struct" required="true"
			hint="sec context">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of resource">
	
		<cfset var a_bol_return = false />
		<cfset var q_select_resource_exists = 0 />
		
		<cfinclude template="queries/resources/q_select_resource_exists.cfm">
		
		<cfset a_bol_return = (q_select_resource_exists.count_id IS 1) />
		
		<cfreturn a_bol_return />
	
	</cffunction>

	<cffunction access="public" name="GetRessourcesAvailableforuser" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="true">
		
		<!--- load ressources --->
		
		<cfreturn QueryNew('test')>
	</cffunction>
</cfcomponent>

