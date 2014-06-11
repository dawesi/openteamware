<!--- //

	Component:	Projects
	Function:	Function
	Description:
	
	Header:	

// --->
<cfcomponent output=false>
	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	
	<cfset sServiceKey = '5137784B-C09F-24D5-396734F6193D879D' />
	
	<cffunction access="public" name="GetAllProjects" returntype="struct" output="true"
			hint="return all projects a user can see">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_projects = 0 />
		<cfset var sEntrykeys = '' />

		<cfinclude template="queries/q_select_projects.cfm">
		
		<cfset stReturn.q_select_projects = q_select_projects />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="GetProject" returntype="struct" output="false"
			hint="return a single project">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_project = 0 />
		<cfset var stReturn_rights = 0 />
		
		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="neededaction" value="read">
		</cfinvoke>
	 	
	 	<cfif NOT stReturn_rights.result>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<!--- securitychecks ... --->		
		<cfinclude template="queries/q_select_project.cfm">
		
		<cfif q_select_project.recordcount IS 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfset stReturn.q_select_project = q_select_project />
		
		<cfinclude template="queries/q_select_sales_project_stage_trends.cfm">
		<cfset stReturn.q_select_sales_project_stage_trends = q_select_sales_project_stage_trends>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="GetAssignedItemsMetaInformation" output="false" returntype="query"
			hint="return the connected items to a project">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="projectkey" type="string" required="true">
		
		<cfset var q_select_assigned_items_meta_information = 0 />
		
		<cfinclude template="queries/q_select_assigned_items_meta_information.cfm">
		
		<cfreturn q_select_assigned_items_meta_information />
		
	</cffunction>
	
	<cffunction access="public" name="UpdateProject" returntype="struct" output="false"
			hint="update project">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of project">
		<cfargument name="data" type="struct" required="true"
			hint="structure with data to update">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<!--- load the original project ... --->
		<cfset var a_struct_project = GetProject(securitycontext = arguments.securitycontext,
										usersettings = arguments.usersettings,
										entrykey = arguments.entrykey) />

		<cfset var a_str_history_item = '' />
		<cfset var q_select_project = 0 />
		<cfset var stReturn_db = 0 />
		<cfset var stReturn_crm_history = 0 />
		
		<!--- // TODO: check security ... --->
		
		<cfset arguments.data.entrykey = arguments.entrykey />
		<cfset q_select_project = a_struct_project.q_select_project />
		
		<!--- execute auto sql ... --->
		<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_db">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="database" value="#request.a_str_db_tools#">
			<cfinvokeargument name="table" value="projects">
			<cfinvokeargument name="primary_field" value="entrykey">
			<cfinvokeargument name="data" value="#arguments.data#">
			<cfinvokeargument name="action" value="UPDATE">
		</cfinvoke>
		
		<!--- add notice about status change of project to history ... --->
		<cfif StructKeyExists(arguments.data, 'status') AND
			  StructKeyExists(arguments.data, 'closed') AND (arguments.data.closed IS 1) AND
			  (Len(q_select_project.contactkey) GT 0)>
				  
			<!--- text for history ... --->
			<cfset a_str_history_item = GetLangVal('prj_ph_project_has_been_closed') & ': ' & q_select_project.title & ' (' & GetLangVal('crm_wd_sales_stage_' & q_select_project.stage) & ') ' & q_select_project.sales &  ' ' & q_select_project.currency />
			
			<!--- add history event ... --->			
			<cfinvoke component="#application.components.cmp_crmsales#" method="CreateHistoryItem" returnvariable="stReturn_crm_history">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
				<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
				<cfinvokeargument name="objectkey" value="#q_select_project.contactkey#">
				<cfinvokeargument name="item_type" value="0">
				<cfinvokeargument name="comment" value="#a_str_history_item#">
				<cfinvokeargument name="dt_created" value="#GetODBCUTCNow()#">
				<cfinvokeargument name="linked_servicekey" value="#sServiceKey#">
				<cfinvokeargument name="linked_objectkey" value="#arguments.entrykey#">
			</cfinvoke>
		</cfif>
		
		<cfif NOT stReturn_db.result>
			<cfreturn stReturn_db />
		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="CreateUpdateProject" returntype="struct" output="false"
			hint="autopickup function for creating a new project / updating a project ... real database operation does not take place here!">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="action_type" type="string" default="create" required="true"
			hint="create or update">
		<cfargument name="database_values" type="struct" required="true"
			hint="structure with values ...">
		<cfargument name="all_values" type="struct" required="true"
			hint="various other variables">
			
		<cfset var stReturn = GenerateReturnStruct() />
		
		<!--- load the original project ... --->
		<cfset var a_struct_project = GetProject(securitycontext = arguments.securitycontext,
										usersettings = arguments.usersettings,
										entrykey = arguments.database_values.entrykey) />
										
		<cfset var q_select_original_data = 0 />
		<cfset var tmp = false />
		
		<!--- insert into history - if something has changed only --->
		<!--- <cfif (a_struct_project.result) AND (arguments.action_type IS 'edit') AND (q_select_original_data.project_type IS 1)>
			
			<cfset q_select_original_data = a_struct_project.q_select_project />
			
			<cfinclude template="queries/q_insert_sales_project_history.cfm">
		</cfif> --->

		<!--- update activity index of contact ... --->
		<cfset application.components.cmp_crmsales.UpdateActivityCountOfContact(objectkey = arguments.database_values.contactkey,
																		itemtype = 'projects_' & arguments.database_values.project_type) />

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<!--- create a project --->
	<cffunction access="public" name="CreateProject" returntype="struct" output="false">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="categories" type="string" required="false" default="">
		<cfargument name="projecttype" type="numeric" required="true"
			hint="0 = common, 1 = sales, 2 = technical, 3 = marketing">
		<cfargument name="percentdone" type="numeric" default="0" required="false">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="parentprojectkey" type="string" required="false" default="">
		<cfargument name="priority" type="numeric" default="2" required="false">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var sEntrykey = CreateUUID() />
		
		<cfinclude template="queries/q_insert_project.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="AddOrUpdateItemConnection" returntype="boolean" output="false">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="projectkey" type="string" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="objectkey" type="string" required="false" default="">
		<cfargument name="objecttype" type="string" required="false" default="">
		
		<cfif Len(arguments.projectkey) IS 0>
			<!--- delete a connection ... --->
		</cfif>
		
		<!--- check if read permissions are given ... --->
		<cfinclude template="queries/q_select_connection_exists.cfm">
		
		<cfif q_select_connection_exists.count_id IS 0>
			<!--- insert --->
			<cfinclude template="queries/q_insert_connection.cfm">
		</cfif>
		
		<cfreturn true>
	</cffunction>	
	
	<cffunction access="public" name="RemoveProjectMember" returntype="boolean" output="false">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="projectkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="comment" type="string" required="false" default="">
		
		<cfreturn true>
	</cffunction>	
	
	<cffunction access="public" name="AddProjectMember" returntype="boolean" output="false">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="projectkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="comment" type="string" required="false" default="">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteProject" returntype="struct" output="false"
			hint="delete a project">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = StructNew() />
		<cfset var a_struct_project = StructNew() />
		<cfset var q_select_project = 0 />
		<cfset var a_bol_return_save_deleted = false />

		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="neededaction" value="delete">
		</cfinvoke>
		
		<cfif NOT stReturn_rights.result>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfset q_select_project = GetProject(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings,
										entrykey = arguments.entrykey).q_select_project />
		
		<cfinvoke component="#application.components.cmp_log#" method="SaveDeletedRecord" returnvariable="a_bol_return_save_deleted">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="datakey" value="#arguments.entrykey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="query" value="#q_select_project#">
			<cfinvokeargument name="title" value="#q_select_project.title#">
		</cfinvoke>
	 	
	 	<cfinclude template="queries/q_delete_project.cfm">
	 	
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="GetOwnerUserkey" returntype="string" output="false"
			hint="return the entrykey of the owner">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of project">
			
		<cfset var q_select_owner_userkey = 0 />
		
		<cfinclude template="queries/q_select_owner_userkey.cfm">
		
		<cfreturn q_select_owner_userkey.userkey />
	</cffunction>
</cfcomponent>
