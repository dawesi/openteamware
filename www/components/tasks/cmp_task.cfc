<cfcomponent output=false hint="Tasks">

<!--- //
	tasks
	// --->

	<cfset sServiceKey = "52230718-D5B0-0538-D2D90BB6450697D1">
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- take over ownership ...
	
		call the UPDATETASK method
		
		managepermissions is neccessary for this operation!!!!
		
		 --->
	<cffunction access="public" name="TransferOwnership" output="false" returntype="boolean">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- userkey ... --->
		<cfargument name="newuserkey" type="string" default="">
		
		<cfset a_struct = StructNew()>
		<cfset a_struct.userkey = arguments.newuserkey>
		
		<cfinvoke component="cmp_task" method="UpdateTask" returnvariable="a_bol_return">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="newvalues" value="#a_struct#">
		</cfinvoke>
		
		
		<cfreturn a_bol_return>	
	</cffunction>
	
	<!--- update a task ... --->
	<cffunction access="public" name="UpdateTask" output="false" returntype="boolean" hint="Update a task item">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of task">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- new values ... --->
		<!--- a structure full of items to edit ... --->	
		<cfargument name="newvalues" type="struct" required="true" hint="structure holding the new desired new values (field names same as in CreateTask)">		
		
		<!--- is this user the owner of this item ... then he can do what he wants to do ... --->
		<cfif GetOwnerUserkey(arguments.entrykey) IS arguments.securitycontext.myuserkey>
			<!--- this user is the owner ... --->
			<cfset stReturn_rights = StructNew()>
			<cfset stReturn_rights.edit = true>
			<cfset stReturn_rights.write = true>
			<cfset stReturn_rights.managepermissions = true>
			
		<cfelse>
		
			<!--- check if the user has the permission to do that ... --->
			<cfset a_str_workgroup_keys = GetWorkgroupsOfTaskItem(arguments.entrykey, arguments.securitycontext.myuserkey)>		
		
			
			<!--- check security ... --->
			<cfinvoke component="#application.components.cmp_security#" method="GetPermissionsForObject" returnvariable="stReturn_rights">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			</cfinvoke>
				  			
		</cfif>

		 <!--- update now ... --->
		 <cfif stReturn_rights.edit is true>
		 
		 	<!--- save original version ... --->
			<cfinclude template="queries/q_select_task_raw.cfm">
			
			<cfinvoke component="#request.a_str_component_logs#" method="SaveEditedRecordOldVersion" returnvariable="a_bol_return_save_deleted">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="datakey" value="#arguments.entrykey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="query" value="#q_select_task_raw#">
				<cfinvokeargument name="title" value="#q_select_task_raw.title#">
			</cfinvoke>	
		 	
		 	<!--- call update function ... --->
			<cfinclude template="queries/q_update_task.cfm">
			
			<!--- update outlook meta data ... --->
			<cfinclude template="queries/q_update_outlook_meta_data.cfm">
						
			<!--- return true ... --->
			<cfset a_bol_return = true>
			<cfset a_int_failed = 0>
		 <cfelse>
		 	<!--- no right to update ... --->
			<cfset a_bol_return = false>
			<cfset a_int_failed = 1>			
		 </cfif>
		 
		 <cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="performedaction" value="edit">
			<cfinvokeargument name="failed" value="#a_int_failed#">
		</cfinvoke>
		
		<cfif StructKeyExists(arguments.newvalues, 'userkey') AND Len(arguments.newvalues.userkey) GT 0>
			 <cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
				<cfinvokeargument name="performedaction" value="takeoverownership">
				<cfinvokeargument name="failed" value="#a_int_failed#">
			</cfinvoke>				
		</cfif>

		<cfreturn a_bol_return>
	</cffunction>
	
	<cffunction access="public" name="UrgeTask" output="false" returntype="boolean">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings --->
		<cfargument name="usersettings" type="struct" required="yes">
		
		<!--- send a reminder to the responsible people --->
		<cfset a_struct_load_task = GetTask(entrykey = arguments.entrykey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings)>
		
		<cfif StructKeyExists(a_struct_load_task, 'q_select_task')>
			<!--- ok, task exists --->			
			<cfloop list="#a_struct_load_task.q_select_task.assignedtouserkeys#" index="a_str_userkey" delimiters=",">
				<cfset SendAlertAboutNewAssignedTask(taskkey = arguments.entrykey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, urge = true, userkey = a_str_userkey)>
			</cfloop>
			
			 <cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
				<cfinvokeargument name="performedaction" value="urge">
				<cfinvokeargument name="failed" value="0">
			</cfinvoke>					
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<!--- update the status only ... --->
	<cffunction access="public" name="UpdateStatus" output="false" returntype="boolean">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- status --->
		<cfargument name="status" type="numeric" default="0">
		
		<!--- call now the internal edit operation ... just edit the status and maybe the dt_done property, nothing else --->
		
		<cfreturn true>
	</cffunction>
	
	<!--- delete a task ... --->
	<cffunction access="public" name="DeleteTask" output="false" returntype="boolean" hint="delete a task item">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings ... --->
		<cfargument name="usersettings" type="struct" required="true">
		<!--- delete outlook sync information too? --->
		<cfargument name="clearoutlooksyncmetadata" type="boolean" required="false" default="true" hint="clear out various meta data tables">
		
		<!--- did the operation fail? default is yes ... --->
		<cfset a_int_failed = 1>
				
		<!--- is this user the owner of this item ... then he can do what he wants to do ... --->
		<cfif GetOwnerUserkey(arguments.entrykey) IS arguments.securitycontext.myuserkey>
			<!--- this user is the owner ... --->
			<cfset stReturn_rights.delete = true>
			
		<cfelse>
		
			<!--- check if the user has the permission to do that ... --->
			<cfinvoke component="#application.components.cmp_security#" method="GetPermissionsForObject" returnvariable="stReturn_rights">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			  </cfinvoke>
		</cfif>
		
		<cfset a_Str_title = "">
		
		<!--- check if we can now really delete the task ... --->
		<cfif stReturn_rights.delete is true>
			<!--- operation is ok! --->
			<cfinclude template="queries/q_select_task_raw.cfm">
						
			<cfinvoke component="#request.a_str_component_logs#" method="SaveDeletedRecord" returnvariable="a_bol_return_save_deleted">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="datakey" value="#arguments.entrykey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="query" value="#q_select_task_raw#">
				<cfinvokeargument name="title" value="#q_select_task_raw.title#">
			</cfinvoke>			
			
			<!--- call delete now ... --->
			<cfinclude template="queries/q_delete_task.cfm">
			<cfinclude template="queries/q_delete_shareddata.cfm">
			
			<cfif arguments.clearoutlooksyncmetadata is true>
				<!--- clear outlook sync information for all users ... --->
				<cfinclude template="queries/q_delete_outlook_meta_data.cfm">
			</cfif>

			<!--- operation is ok! --->
			<cfset a_int_failed = 0>
		</cfif>
		
		<cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="performedaction" value="delete">
			<cfinvokeargument name="failed" value="#a_int_failed#">
			<cfinvokeargument name="additionalinformation" value="#a_Str_title#">
		</cfinvoke>	

		<!--- return the result ... --->
		<cfif a_int_failed is 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<!--- create a task ... --->
	<!--- edited: securitycontext/usersettings ... --->
	<cffunction access="public" name="CreateTask" output="false" returntype="boolean" hint="create a new task">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey">
		<!---<cfargument name="userkey" type="string" required="true" hint="userkey of owner (securitycontext.myuserkey)">--->
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="title" type="string" required="true" hint="title">
		<cfargument name="notice" type="string" default="" required="true" hint="further text">
		<cfargument name="priority" type="numeric" default="2" hint="priority (default = 2); 1 = low; 3 = high">
		<cfargument name="percentdone" type="numeric" default="0" required="false" hint="% done">
		<cfargument name="status" type="numeric" default="1" hint="0 = done; 1 = not started yet (default); 2 = in progres; 3 = deferred">
		<cfargument name="projectkeys" type="string" default="" hint="n/a, leave empty">
		<cfargument name="actualwork" type="numeric" default="0" hint="minutes of actual work">
		<cfargument name="totalwork" type="numeric" default="0" hint="minutes of total work">
		<cfargument name="categories" type="string" default="" hint="categories">
		<cfargument name="due" type="date" required="false" hint="due (date in ts{... format)">
		<cfargument name="linked_contacts" type="string" default="" hint="n/a">
		<cfargument name="linked_files" type="string" default="" hint="n/a">
		<cfargument name="assignedtouserkeys" type="string" default="" required="false" hint="assigned to other users (leave empty by default)">
		<cfargument name="private" type="numeric" default="0" required="false" hint="private">
		<cfargument name="dt_start" type="date" required="no" hint="start date of task">
		
		<!--- insert the task now ... --->
		<cfinclude template="queries/q_insert_task.cfm">
			
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetTask" output="false" returntype="struct"
			hint="return the task">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the task">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = StructNew() />
		
		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="neededaction" value="read">
		</cfinvoke>
		
		<cfset stReturn.rights = stReturn_rights />
		
		<!--- reading permitted? ... --->
		<cfif NOT stReturn_rights.result>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<!--- return the item ... --->
		<cfinclude template="queries/q_select_task.cfm">
		<cfset stReturn.q_select_task = q_select_task />
		
		<!--- try to load crm connections ... --->
		<cfinclude template="queries/q_select_contact_connections.cfm">
		
		<cfset stReturn.q_select_contact_connections = q_select_contact_connections />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	
	</cffunction>
	
	
	<!--- get all possible tasks ... --->
	<cffunction access="public" name="GetTasks" output="false" returntype="struct" hint="load tasks">
		<!--- security-context ...--->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- filteroptions ... --->
		<cfargument name="filter" type="struct" required="false" default="#StructNew()#" hint="filter">
		<!--- search for something ... --->
		<cfargument name="search" type="string" default="" required="false" hint="search for something">
		<!--- order by xy ... --->
		<cfargument name="orderby" type="string" default="dt_lastmodified" required="false" hint="order by fieldname">
		<!--- desc? --->
		<cfargument name="orderbydesc" type="boolean" required="false" default="false">
		<!--- load notice (body)? --->
		<cfargument name="loadnotice" type="boolean" required="false" default="true" hint="load notices as well">
		<!--- get category list? --->
		<cfargument name="createcategorylist" type="boolean" required="false" default="true" hint="create and return a list of distinct categories">
		<!--- load options ... --->
		
		<!--- load the following tasks:
		
			a) private entries
			b) entries from workgroups where the user has at least read permissions
			
			--->
		<cfinvoke component="#application.components.cmp_security#" method="LoadPossibleWorkgroupsForAction" returnvariable="q_select_workgroups">
			<cfinvokeargument name="q_workgroup_permissions" value="#arguments.securitycontext.q_select_workgroup_permissions#">
			<cfinvokeargument name="desiredactions" value="read">
		</cfinvoke>
		
		<cfif IsDefined("arguments.filteroptions") AND isStruct(arguments.filteroptions)>
			<!--- set filter ... --->
		</cfif>
		
		<cfinclude template="queries/q_select_tasks.cfm">
		
		<cfset stReturn = StructNew()>
		
		<cfset stReturn.q_select_tasks = q_select_tasks>
		<cfset stReturn.struct_categories = a_struct_categories>
		
		<cfreturn stReturn>
	</cffunction>
	
	<!--- return a comma delimitered list of corresponding workgroups ...
		if the result is '', the object is private ... --->
	<cffunction access="public" name="GetWorkgroupsOfTaskItem" returntype="string" output="false">
		<!--- the desired object --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- the userkey ... --->
		<cfargument name="userkey" type="string" required="true">
		
		<cfreturn "">
	
	</cffunction>
	
	<!--- get the users which are assigned to a task ... --->
	<cffunction access="public" name="GetAssignedUsersOfTask" returntype="query" output="false">
		<cfargument name="taskkey" type="string" required="true">
		
		<cfreturn QueryNew('qwe')>
	</cffunction>
	
	<cffunction access="public" name="IsAssignedUserOfTask" returntype="boolean" output="false">
		<cfargument name="taskkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_is_assigned_user.cfm">
		
		<cfif q_select_is_assigned_user.count_id IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="AddAssignedUserToTask" returntype="struct" output="false">
		<cfargument name="taskkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset stReturn = StructNew()>
		
		<!--- load task ... --->
		<cfinvoke component="cmp_task" method="GetTask" returnvariable="a_struct_load_task">
			<cfinvokeargument name="entrykey" value="#arguments.taskkey#">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
		</cfinvoke>
		
		<cfif a_struct_load_task.rights.delegate IS TRUE>
			<!--- insert user ... --->
			<cfinclude template="queries/q_select_check_already_assigned.cfm">
			
			<cfif q_select_check_already_assigned.count_id IS 0>
				<cfinclude template="queries/q_insert_assigned_user.cfm">
				<cfset stReturn.a_bol_newlyassigned = true>				
			<cfelse>
				<!--- already assiged --->
				<cfset stReturn.a_bol_newlyassigned = false>
			</cfif>

			<!--- the result ... --->
			<cfset stReturn.result = true>
		<cfelse>
			<cfset stReturn.result = false>
		</cfif> 
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="DeleteAllAssignedusersOfTask" returntype="boolean" output="false">
		<cfargument name="taskkey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		
		<cfreturn true>
	</cffunction>
	
	<!--- send an email ... --->
	<cffunction access="public" name="SendAlertAboutNewAssignedTask" returntype="boolean" output="false">
		<cfargument name="taskkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="urge" type="boolean" required="no" default="false">
		
		<!--- check if user is interested in such mails ... --->
		<cfinvoke component="#application.components.cmp_user#" method="GetAlertOnNewItemsSettings" returnvariable="a_str_reminder_methods">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
		</cfinvoke>
		
		<cfif Len(a_str_reminder_methods) IS 0>
			<cfreturn true>
		</cfif>
		
		<cfset a_struct_load_task = GetTask(entrykey = arguments.taskkey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings)>

		<cfset q_select_task = a_struct_load_task.q_select_task>
		<cfset q_select_contact_connections = a_struct_load_task.q_select_contact_connections>
		
		<cfif ListFindNoCase(a_str_reminder_methods, 'email') GT 0>
			<cfinclude template="utils/inc_send_mail.cfm">
		</cfif>				
		
		<cfif ListFindNoCase(a_str_reminder_methods, 'sms') GT 0>
			<cfinclude template="utils/inc_send_sms.cfm">
		</cfif>				
		
		<cfreturn true>
	</cffunction>
	
	<!--- return the userkey (=owner) of the task --->
	<cffunction access="public" name="GetOwnerUserkey" returntype="string" output="false">
		<!--- the desired object --->
		<cfargument name="entrykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_owner_userkey.cfm">
		
		<cfreturn q_select_owner_userkey.userkey>	
	</cffunction>
	
	<!--- return the total number of own records ... --->
	<cffunction access="public" name="GetOwnRecordsRecordcount" output="false" returntype="numeric">
		<cfargument name="userkey" type="string" required="true">

		<cfinclude template="queries/q_select_own_tasks_recordcount.cfm">

		<cfreturn VAL(q_select_own_tasks_recordcount.count_id)>
	</cffunction>	

</cfcomponent>