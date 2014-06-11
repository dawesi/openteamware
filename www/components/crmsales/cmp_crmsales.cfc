<!--- //

	Module:		CRMSALES
	Description:Central component for CRM / SALES
	

// --->

<cfcomponent output='false'>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="ReturnObjectEntrykeysForCriteriaID" output="false" returntype="string"
			hint="return list of entrykeys for the given criteria IDs">
		<cfargument name="servicekey" type="string" required="true"
			hint="service to return objects of">
		<cfargument name="criteria_ids" type="string" required="true"
			hint="list of criteria to look for">
			
		<cfset var q_select_objectkeys_by_criteria_ids = 0 />
		
		<!--- if an empty value has been provided, return empty string ... --->
		<cfif Len(arguments.criteria_ids) IS 0>
			<cfreturn '' />
		</cfif>
		
		<cfinclude template="queries/criteria/q_select_objectkeys_by_criteria_ids.cfm">

		<cfreturn ValueList(q_select_objectkeys_by_criteria_ids.objectkey) />
	</cffunction>
		
	<cffunction access="public" name="AssignCriteriaToObject" output="false" returntype="struct"
			hint="save certain criteria for an object">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true"
			hint="servicekey of object">
		<cfargument name="objectkey" type="string" required="true"
			hint="entrykey of object">
		<cfargument name="criteria_ids" type="string" required="true"
			hint="list of criteria ids">
		<cfargument name="replacedata" type="boolean" default="true"
			hint="replace all currently stored criteria (default = true)">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_int_criteria = 0 />

		<cfif arguments.replacedata>
			<!--- delete currently saved criteria for object ... --->
			<cfinclude template="queries/criteria/q_delete_current_criteria_of_object.cfm">
		</cfif>
		
		<cfloop list="#arguments.criteria_ids#" index="a_int_criteria">
			<cfinclude template="queries/criteria/q_insert_criteria_assignment.cfm">
		</cfloop>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	
	<cffunction access="public" name="GetItemActivitiesAndData" output="false" returntype="struct"
			hint="return properly formatted data/activities for item">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="type" type="string" required="true"
			hint="item type to show ...">
		<cfargument name="contactkeys" type="string" required="yes"
			hint="comma seperated list of contactkeys">
		<cfargument name="filter" type="struct" required="no" default="#StructNew()#">
		<cfargument name="managemode" type="boolean" required="no" default="false"
			hint="offer delete and so on">
		<cfargument name="format" type="string" default="html" required="false"
			hint="feature for the future: html / raw (query) / XML ... now always HTML">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_filter = StructNew() />
		<cfset stReturn.recordcount = 0 />
		<cfset stReturn.a_str_content = '' />
		
		<!--- add supported subitems ... --->
		<cfset arguments.contactkeys = LoadSubItemsAsWell(securitycontext = arguments.securitycontext,
										itemkeys = arguments.contactkeys) />
		
		<!--- what type to return ... --->
		<cfswitch expression="#arguments.type#">
			<cfcase value="followups">
				<cfinclude template="activities_data/inc_display_followups_assigned_to_contacts.cfm">
			</cfcase>
			<cfcase value="products">
			
			</cfcase>
			<cfcase value="tasks">
				<cfinclude template="activities_data/inc_display_tasks_assigned_to_contact.cfm">
			</cfcase>
			<cfcase value="projects">
				<cfinclude template="activities_data/inc_display_projects_assigned_to_contacts.cfm">
			</cfcase>
			<cfcase value="files">
			
			</cfcase>
			<cfcase value="appointments">
				<cfinclude template="activities_data/inc_display_appointments_assigned_to_contacts.cfm">
			</cfcase>
			<cfcase value="history">
			
			</cfcase>
			<cfcase value="linked_items">
				<cfinclude template="activities_data/inc_display_linked_contacts_to_contact.cfm">
			</cfcase>
		</cfswitch>

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="DeleteHistoryItem" output="false" returntype="struct"
			hint="return a single history item">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = 0 />
		
		<cfquery name="local.item">
		SELECT	servicekey,
				objectkey
		FROM	history
		WHERE	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#" />
		</cfquery>
		
		<!--- check security --->
		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#local.item.servicekey#">
			<cfinvokeargument name="object_entrykey" value="#local.item.objectkey#">
			<cfinvokeargument name="neededaction" value="delete">
		</cfinvoke>
		
		<cfif NOT stReturn_rights.result>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfquery>
		DELETE FROM history
		WHERE	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#" />
		</cfquery>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="GetHistoryItem" output="false" returntype="struct"
			hint="return a single history item">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = 0 />
		
		<cfquery name="local.item">
		SELECT	*
		FROM	history
		WHERE	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#" />
		</cfquery>
		
		<!--- not found --->
		<cfif !local.item.recordcount>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<!--- check security --->
		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#local.item.servicekey#">
			<cfinvokeargument name="object_entrykey" value="#local.item.objectkey#">
			<cfinvokeargument name="neededaction" value="edit">
		</cfinvoke>
		
		<cfif NOT stReturn_rights.result>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfset stReturn.stReturn_rights = stReturn_rights />
		<cfset stReturn.q_select_history_item = local.item />

		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="GetHistoryItemsOfContact" output="false" returntype="struct"
			hint="get history items of contact / lead / account">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="yes"
			hint="service key of object">
		<cfargument name="objectkeys" type="string" required="yes"
			hint="entrykey of objects">
		<cfargument name="filter" type="struct" required="no" default="#StructNew()#"
			hint="various filter">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_history_items = 0 />
		
		<cfinclude template="queries/history/q_select_history_items.cfm">
		
		<cfset stReturn.q_select_history_items = q_select_history_items />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="CreateHistoryItem" output="false" returntype="struct"
		hint="create a new history item">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="yes"
			hint="entrykey of service">
		<cfargument name="objectkey" type="string" required="yes"
			hint="entrykey of object this item is connected to">
		<cfargument name="projectkey" type="string" required="no" default=""
			hint="entrykey of project this item is associated with">
		<cfargument name="subject" type="string" default="" required="no">
		<cfargument name="comment" type="string" default="" required="no">
		<cfargument name="categories" type="string" required="false" default=""
			hint="categories applying to this item">
		<cfargument name="dt_created" type="date" required="no" default="#Now()#"
			hint="date which should appear as create date">
		<cfargument name="item_type" type="numeric" default="0" required="no"
			hint="type of item (event, call, email ...)">
		<cfargument name="linked_servicekey" type="string" required="no" default=""
			hint="the associated item, e.g. a file from storage or an email">
		<cfargument name="linked_objectkey" type="string" required="no" default=""
			hint="objectkey of the associated item">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var sReturn_entryky = CreateUUID() />
		<cfset var a_str_hash_id = Hash(arguments.servicekey & arguments.objectkey & arguments.linked_servicekey & arguments.linked_objectkey) />
		
		<cfif (Len(arguments.servicekey) IS 0) OR (Len(arguments.objectkey) IS 0)>
			<cfreturn SetReturnStructErrorCode(stReturn, 5400) />
		</cfif>
		
		<!--- if it is a linked item, check if it already exists ... --->
		<cfif Len(arguments.linked_objectkey) GT 0>
		
			<cfif CheckIfHistoryItemExistsByHashId(a_str_hash_id)>
				<cfreturn SetReturnStructErrorCode(stReturn, 7001) />
			</cfif>
			
		</cfif>
		
		<cfinclude template="queries/history/q_insert_history_item.cfm">	
		
		<cfset stReturn.entrykey = sReturn_entryky />
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="CheckIfHistoryItemExistsByHashId" output="false" returntype="boolean">
		<cfargument name="hashid" type="string" required="true"
			hint="the unique hash id (servicekey, objectkey ...)">
		
		<cfset var q_select_history_linked_item_exists = 0 />
	
		<cfinclude template="queries/history/q_select_history_linked_item_exists.cfm">
			
		<cfreturn (q_select_history_linked_item_exists.count_id) GT 0 />
		
	</cffunction>
	
	<cffunction access="public" name="CheckIfHistoryItemsExistForLinkedObject" output="false" returntype="boolean"
			hint="return true if an item with the given linked objectkey/servicekey">
		<cfargument name="servicekey" type="string" required="true"
			hint="servicekey of object to check for if an item exists">
		<cfargument name="objectkey" type="string" required="true"
			hint="entrykey of object to check if an history item exists for">
		<cfargument name="linked_servicekey" type="string" required="true"
			hint="entrykey of linked service">
		<cfargument name="linked_objectkey" type="string" required="true"
			hint="entrykey of linked object">
			
		<cfset var a_bol_return = false />
		
		<cfset var a_str_hash_id = Hash(arguments.servicekey & arguments.objectkey & arguments.linked_servicekey & arguments.linked_objectkey) />
		
		<cfreturn CheckIfHistoryItemExistsByHashId(a_str_hash_id) />

	</cffunction>
	
	<cffunction access="private" name="LoadSubItemsAsWell" output="false" returntype="string"
			hint="return list of sub items if just one item has been given">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="itemkeys" type="string" required="true">
		
		<cfset var sReturn = arguments.itemkeys />
		<cfset var q_select_all_items = 0 />
		
		<!--- more than one item? return list without any modifications ... --->
		<cfif ListLen(sReturn) GT 1>
			<cfreturn sReturn />
		</cfif>
		
		<cfset q_select_all_items = application.components.cmp_addressbook.ReturnSubItemsWithGivenPermissions(securitycontext = arguments.securitycontext,
										entrykey = sReturn) />
										
		<cfset sReturn = ListAppend(ValueList(q_select_all_items.entrykey), sReturn) />
		
		<cfreturn sReturn />

	</cffunction>
	
	<cffunction access="public" name="CreateItemConnectionToContact" output="false" returntype="struct">
		<cfargument name="contactkey" type="string" required="yes" hint="entrykey of contact">
		<cfargument name="objectkey" type="string" required="yes" hint="entrykey of object">
		<cfargument name="servicekey" type="string" required="yes" hint="servicekey of objectitem">
	
		<cfset var stReturn = StructNew()>
		
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
				<!--- task ... --->
				<cfinclude template="queries/q_insert_connection_task.cfm">
			</cfcase>
		</cfswitch>
		
		<cfreturn stReturn>	
	</cffunction>
	
	<cffunction access="public" name="CreateNewFilesAttachedToUserDirectory" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes">
		<cfargument name="parentdirectorykey" type="string" required="yes">
		<cfargument name="directoryname" type="string" required="yes">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_struct_binding = GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey) />
		
		<cfset stReturn.result = false />
		
		<cfif Len(a_struct_binding.USERKEY_DATA) GT 0>
			<cfinclude template="utils/storage/inc_create_new_directory_for_files_attached_to_user.cfm">
		</cfif>
		
		<cfset stReturn.result = true />
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="DeleteFileAttachedToUser" output="false" returntype="boolean" hint="delete a file assigned to a crm contact">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes">
		<cfargument name="directorykey" type="string" required="yes">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of file">
		
		<cfset var a_struct_binding = GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey) />
		
		<cfif Len(a_struct_binding.USERKEY_DATA) GT 0>
			<cfinclude template="utils/storage/inc_delete_file_attached_to_contact.cfm">
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="AddFileAttachedToUser" output="false" returntype="struct"
			hint="add a file to an user">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes">
		<cfargument name="directorykey" type="string" required="yes">
		<cfargument name="filename" type="string" required="yes">
		<cfargument name="file_on_disk" type="string" required="yes">
		<cfargument name="contenttype" type="string" required="yes">
		<cfargument name="filesize" type="numeric" required="yes">
		
		<cfset var stReturn = StructNew() />
		
		<!--- upload file to the specified directory ... using the securitycontext of the "userdata" user --->
		<cfset var a_struct_binding = GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey)>
		
		<cfset stReturn.result = false />
		
		<cfif Len(a_struct_binding.USERKEY_DATA) GT 0>
			<cfinclude template="utils/storage/inc_upload_file_attached_to_contact.cfm">
		</cfif>
		
		<cfset stReturn.result = true />
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="DisplayFilesAttachedToUser" output="false" returntype="string" hint="display the files attached to a certain user">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes" hint="entrykey of contact">
		<cfargument name="directorykey" type="string" required="yes" hint="entrykey of directory, empty if root directory">
		<cfargument name="divname" type="string" required="yes" hint="name of div containing the output (for further calls ...)">
		<cfargument name="managemode" type="boolean" required="no" default="false" hint="in manage mode or display only?">
		
		<cfset var sReturn = ''>
		<cfset var a_struct_binding = GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey) />
		<cfset var a_bol_data_user_exists = Len( application.components.cmp_user.GetUsernamebyentrykey( a_struct_binding.USERKEY_DATA )) GT 0 />
		
		<cfif Len(a_struct_binding.USERKEY_DATA) GT 0 AND a_bol_data_user_exists>
			<cfinclude template="utils/storage/inc_display_user_files.cfm">
		</cfif>
		
		<cfreturn sReturn />
	</cffunction>
	
	<cffunction access="public" name="GetCriteriaCount" output="false" returntype="numeric"
			hint="return the number of criteria of a company">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfset var q_select_criteria_count = 0 />
		
		<cfinclude template="queries/criteria/q_select_criteria_count.cfm">
		
		<cfreturn Val(q_select_criteria_count.count_id) />
	</cffunction>
	
	<cffunction access="public" name="DeleteCriteria" output="false" returntype="boolean"
			hint="delete a criteria">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="id" type="numeric" default="0" required="yes">
		
		<!--- has this criteria sub criterias? --->
		<cfinclude template="queries/criteria/q_select_has_criteria_to_delete_sub_criterias.cfm">
		
		<cfif q_select_has_criteria_to_delete_sub_criterias.count_id GT 0>
			<cfreturn false />
		</cfif>
		
		<cfinclude template="queries/criteria/q_delete_criteria.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="BuildCriteriaTree" output="false" returntype="string"
			hint="build the criteria tree and return a string containing html">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="options" type="string" required="no" default="" hint="various options">
		<cfargument name="url_tags_to_add" type="string" required="no" default="" hint="url tags to add to links (important for admintool)">
		<cfargument name="selected_ids" type="string" required="no" default="" hint="ids to select">
		<cfargument name="form_input_name" type="string" required="no" default="frm_criteria_id" hint="name of input field">
		<cfargument name="tree_id" type="string" default="tree_default" required="false"
			hint="id of tree (dom)">
		
		<cfset var sReturn = '' />
		
		<cfif (ListFindNoCase(arguments.options, 'display_selected') GT 0) AND
			  (ListFindNoCase(arguments.options, 'allowedit') IS 0)>
			  <!--- display only ... --->
			  <cfinclude template="criteria/inc_build_display_only_criteria.cfm">
		<cfelse>
			<!--- build ordenary tree ... --->
			<cfinclude template="criteria/inc_build_criteria_tree.cfm">
		</cfif>
		
		<cfreturn sReturn />		
	</cffunction>
	
	<cffunction access="public" name="GetFullCriteriaQuery" output="false" returntype="query">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="filter_ids" type="string" required="false" default=""
			hint="possible list of IDs to filter ...">
		
		<cfset var q_select_criteria = 0 />

		<cfinclude template="queries/criteria/q_select_criteria.cfm">
		
		<cfreturn q_select_criteria />
	</cffunction>
	
	<cffunction access="public" name="GetCriteriaNamesByIDs" returntype="string" output="false"
			hint="return the criteria names by it's IDs">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="ids" type="string" required="true">
		
		<cfset var sReturn = '' />
		<cfset var q_select_criteria = GetFullCriteriaQuery(companykey = arguments.securitycontext.mycompanykey,
										filter_ids = arguments.ids) />
										
		<cfset sReturn = ValueList(q_select_criteria.criterianame, ', ') />
		
		<cfreturn sReturn />
	</cffunction>
	
	<cffunction access="public" name="SetCRMSalesBinding" output="false"
			returntype="boolean">
		<cfargument name="companykey" type="string" required="yes" hint="entrykey of company">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="databasekey" type="string" required="yes" hint="entrykey of database">
		<cfargument name="additionaldata_tablekey" type="string" required="yes" hint="activities">
		<<cfargument name="userkey_data" type="string" required="yes" hint="userkey of user holding data (e.g. storage)">
		
		<!--- delete old binding ... --->
		<cfinclude template="queries/q_delete_crm_sales_binding.cfm">
		
		<!--- insert new binding ... --->
		<cfinclude template="queries/q_insert_crm_sales_binding.cfm">
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction access="public" name="GetVariousCRMSetting" output="false" returntype="string" hint="load a various setting addressed by arguments.key">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="key" type="string" required="yes">
		<cfargument name="default" type="string" required="no" default="">
		
		<cfinclude template="queries/q_select_various_crm_setting.cfm">
		
		<cfif q_select_various_crm_setting.recordcount IS 0>
			<cfreturn arguments.default>
		<cfelse>
			<cfreturn q_select_various_crm_setting.setting_value>
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="UpdateVariousCRMSettings" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="createdbyuserkey" type="string" required="yes">
		<cfargument name="key" type="string" required="yes">
		<cfargument name="value" type="string" required="yes">
		
		<!--- update or insert setting ... --->
		<cfinclude template="queries/q_update_insert_various_crm_setting.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetCRMSalesBinding" output="false" returntype="struct">
		<cfargument name="companykey" type="string" required="yes" hint="entrykey of company">
		
		<cfset var stReturn = StructNew()>
		
		<!--- cache setting in request scope ... --->
		<cfset var sEntrykey_cache_request = 'q_select_crm_sales_binding_' & hash(arguments.companykey) />
		
		<cfset var q_select_crm_sales_binding = 0 />
		
		<cfif StructKeyExists(request, sEntrykey_cache_request)>
			<cfset q_select_crm_sales_binding = request[sEntrykey_cache_request]>
		<cfelse>
			<cfinclude template="queries/q_select_crm_sales_binding.cfm">
			<cfset request[sEntrykey_cache_request] = q_select_crm_sales_binding>
		</cfif>
		
		<!--- database key of crm tables ... --->
		<cfset stReturn.databasekey = q_select_crm_sales_binding.databasekey>
		
		<!--- additional data --->
		<cfset stReturn.additionaldata_tablekey = q_select_crm_sales_binding.additionaldata_tablekey>
	
		<!--- userkey holding all additional data ... --->
		<cfset stReturn.userkey_data = q_select_crm_sales_binding.userkey_data>
	
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="GetContactActitivitesData" output="false" returntype="struct"
			hint="return the requested activities">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="false" default="52227624-9DAA-05E9-0892A27198268072"
			hint="entrykey of service of object, default = address book">
		<cfargument name="entrykeys" type="string" hint="entrykeys of contact">
		<cfargument name="area" type="string" default="all" required="no"
			hint="area (email,tasks,opportunities,activities,telephonecalls ...">
		<cfargument name="days" type="numeric" default="90" required="no" hint="go back how many days?">
		<cfargument name="load_sub_conctacts_data" type="boolean" required="no" default="false" hint="load data of sub contacts as well?">
		<cfargument name="managemode" type="boolean" default="false" required="no"
			hint="in edit mode?">
		<cfargument name="rights" type="string" default="read" required="no"
			hint="permissions of user">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_crmsales_bindings = GetCRMSalesBinding(arguments.securitycontext.mycompanykey) />
		<cfset var a_str_output = '' />
		<cfset var a_struct_filter = StructNew() />
		<cfset var a_struct_history = StructNew() />
		<cfset var q_select_history_items = 0 />
		<cfset var a_bol_is_pda = false />
		<cfset var a_str_td_id = '' />
		<cfset var a_int_len_text = '' />
		<cfset var a_str_new_wddx = '' />
		<cfset var a_str_old_wddx = '' />
		<cfset var a_str_col_name = '' />
		<cfset var q_select_old = 0 />
		<cfset var q_select_new = 0 />
		<cfset var a_struct_call_history = 0 />
		<cfset var a_struct_filter_calendar = StructNew() />
		<cfset var a_struct_filter_tasks = StructNew()>
		<cfset var a_struct_filter_followups = StructNew() />
		
		<cfset stReturn.output = '' />
		<cfset stReturn.recordcount = 0 />
		
		<!--- // first check if user is allowed to view contact --->
		<cfinclude template="utils/output_activities/inc_generate_output.cfm">
		
		<cfif stReturn.recordcount IS 0>
			<cfset stReturn.output = GetLangVal('cm_ph_no_appropriate_data_found') />
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />	
	</cffunction>
	
	<cffunction access="public" name="CreateViewFilter" output="false" returntype="struct" hint="create a new filter view">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="description" type="string" required="no" default="">
		<cfargument name="include_empty_items" type="boolean" required="yes" default="true" hint="include all items which are not bind to a filter">
		
		<cfset var stReturn = StructNew()>
		<cfset var sEntrykey = CreateUUID()>
		
		<cfset stReturn.result = false>
		<cfset stReturn.errormessage = ''>
		
		<cfset stReturn.entrykey = sEntrykey>
		
		<cfinclude template="queries/q_insert_view_filter.cfm">
		
		<cfif arguments.include_empty_items>
			<cfinclude template="queries/update_empty_view_filter_items.cfm">
		</cfif>
		
		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="GetListOfViewFilters" output="false" returntype="query" hint="return all stored filters">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<cfinclude template="queries/q_select_filter_view_list.cfm">
		
		<cfreturn q_select_filter_view_list>		
	</cffunction>
	
	<cffunction access="public" name="GetFilterCriteriaQuery" output="false" returntype="query"
			hint="return the raw criteria query holding the filter">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="viewkey" type="string" default="" required="no">
		<cfargument name="itemttype" type="numeric" default="0">
		
		<cfset var q_select_filter_criteria = 0 />
		
		<cfinclude template="queries/filter/q_select_filter_criteria.cfm">
		
		<cfreturn q_select_filter_criteria />

	</cffunction>
	
	<cffunction access="public" name="GetViewFilters" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="viewkey" type="string" default="" required="no">
		<cfargument name="itemttype" type="numeric" default="0">
		
		<cfset var a_str_hash_data = 'q_select_criteria' & Hash(arguments.securitycontext.myuserkey & arguments.viewkey & arguments.itemttype) />
		<cfset var q_select_criteria = 0 />
		
		<!--- simple dummy cache ... --->
		<cfif StructKeyExists(request, a_str_hash_data)>
			<cfreturn a_str_hash_data />
		</cfif>
		
		<!--- really load data ... --->
		<cfset q_select_criteria = GetFilterCriteriaQuery(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, viewkey = arguments.viewkey,
						itemtype = arguments.itemttype) />
		
		<cfset request[a_str_hash_data] = q_select_criteria />
		
		<cfreturn q_select_criteria />
	</cffunction>
		
	<cffunction access="public" name="AddTempCRMFilterStructureCriteria" output="false" returntype="struct"
			hint="add a filter criteria without really editing the stored definition (useful for reports, lookups and so on)">
		<cfargument name="CRMFilterStructure" type="struct" required="no" default="#StructNew()#"
			hint="the structure to add the new filter criteria too ... if not provided, returns a brand new structure">
		<cfargument name="area" type="numeric" required="no" default="2"
			hint="area the filter to apply ... 0 = meta; 1 = custom database; 2 = contact">
		<cfargument name="connector" type="numeric" default="0" required="no"
			hint="0 = AND; 1 = OR">
		<cfargument name="operator" type="numeric" required="yes"
			hint="0 = is; 1 = is not; 3 = greater; 4 = smaller; 5 = contains">
		<cfargument name="internalfieldname" type="string" required="no" default=""
			hint="The internal field name (real database fieldname)">
		<cfargument name="comparevalue" type="string" required="yes"
			hint="what to compare with / search for?">
		<cfargument name="internaldatatype" type="numeric" required="no" default="0"
			hint="0 = string; 1 = integer; 3 = date; 4 = ?; default = string">
		
		<cfset var stReturn = Duplicate(arguments.CRMFilterStructure) />
		<cfset var a_struct_new_criteria = StructNew() />
		
		<!--- set filter properties ... --->
		<cfset a_struct_new_criteria.area = arguments.area />
		<cfset a_struct_new_criteria.internaldatatype = arguments.internaldatatype />
		<cfset a_struct_new_criteria.comparevalue = arguments.comparevalue />
		<cfset a_struct_new_criteria.operator = arguments.operator />
		<cfset a_struct_new_criteria.internalfieldname = arguments.internalfieldname />
		<cfset a_struct_new_criteria.connector = arguments.connector />
		
		<cfif NOT StructKeyExists(stReturn, 'metadata')>
			<cfset stReturn.metadata = ArrayNew(1) />
		</cfif>
		
		<cfif NOT StructKeyExists(stReturn, 'contact')>
			<cfset stReturn.contact = ArrayNew(1) />
		</cfif>
		
		<cfif NOT StructKeyExists(stReturn, 'crm')>
			<cfset stReturn.crm = ArrayNew(1) />
		</cfif>
				
		<cfswitch expression="#arguments.area#">
			<cfcase value="0">
				<!--- meta --->
				<cfset stReturn.metadata[ArrayLen(stReturn.metadata) + 1] = a_struct_new_criteria />
			</cfcase>
			<cfcase value="1">
				<!--- database --->
				<cfset stReturn.crm[ArrayLen(stReturn.crm) + 1] = a_struct_new_criteria />
			</cfcase>
			<cfcase value="2">
				<!--- contact --->
				<cfset stReturn.contact[ArrayLen(stReturn.contact)+1] = a_struct_new_criteria />
			</cfcase>
		</cfswitch>
		
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="BuildCRMFilterStruct" output="false" returntype="struct"
			hint="return a structure full of the crm filter criterias">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="itemttype" type="numeric" default="0"
			hint="itemtype for filter ... 0 = contacts, 1 = accounts">
		<cfargument name="viewkey" type="string" default="" required="no">
		<cfargument name="mergecriterias" type="boolean" required="no" default="false">
		<cfargument name="IgnoreIfEmptyViewKey" type="boolean" default="false" required="no"
			hint="if true, do not return criterias if viewkey is empty">
		
		<cfset var stReturn = StructNew() />
		<cfset var q_select_filter_criteria = 0 />
		
		<!--- metadata --->
		<cfset stReturn.metadata = ArrayNew(1) />
		<!--- custom tables ... --->
		<cfset stReturn.crm = ArrayNew(1) />
		<!--- contact search --->
		<cfset stReturn.contact = ArrayNew(1) />
		
		<cfif arguments.mergecriterias>
			<!--- merge criterias later ... --->
			<cfset stReturn.criterias = ArrayNew(1) />		
		</cfif>
		
		<!--- if viewkey is empty and we should not return any criterias for empty viewkeys ... return --->
		<cfif arguments.IgnoreIfEmptyViewKey AND Len(url.viewkey) IS 0>
			<cfreturn stReturn />
		</cfif>
		
		<!--- load filter and return the corresponding entrykeys --->
		<cfset q_select_filter_criteria =  GetFilterCriteriaQuery(securitycontext = arguments.securitycontext,
						usersettings = arguments.usersettings,
						viewkey = arguments.viewkey,
						itemtype = arguments.itemttype) />
			
		<!--- build filter structure --->
		<cfinclude template="utils/filter/inc_build_crm_filter.cfm">
		
		<cfreturn stReturn />

	</cffunction>
	
	<cffunction access="public" name="ClearFilterCriterias" output="false" returntype="boolean" hint="clear criterias + and/or delete filter">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="viewkey" type="string" required="no" default="">
		<cfargument name="delete_filter_too" type="boolean" required="yes" default="false">
		
		<cfinclude template="queries/q_delete_filter_criterias.cfm">
		
		<cfif Len(arguments.viewkey) GT 0 AND arguments.delete_filter_too>
			<cfinclude template="queries/q_delete_view_filter.cfm">
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="AddFilterSearchCriteria" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="area" type="numeric" hint="0 = meta; 1 = database; 2 = contact" required="yes">
		<cfargument name="displayname" type="string" required="yes">
		<cfargument name="viewkey" type="string" required="no" default="">
		<cfargument name="connector" hint="0 = AND; 1 = OR" type="numeric" default="0" required="no">
		<cfargument name="operator" type="numeric" required="yes" hint="0 = is; 1 = is not; 3 = greater; 4 = smaller; 5 = contains">
		<cfargument name="internalfieldname" type="string" required="no" default="">
		<cfargument name="comparevalue" type="string" required="yes">
		<cfargument name="internaldatatype" type="numeric" hint="0 = string; 1 = integer; 3 = date; 4 = ?" required="yes">

		<cfinclude template="queries/filter/q_insert_filtersearch_criteria.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="GetAvailableViews" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="no" default="">
		
		
	</cffunction>
	
	<cffunction access="public" name="AddContactToSalesProject" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="salesprojectkey" type="string" required="yes">
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="role" type="numeric" required="no" default="0">
		<cfargument name="type" type="numeric" required="no" default="0">
		<cfargument name="contact_entrykey" type="string" required="yes" hint="entrykey of user or contact">
		<cfargument name="internal_user" type="numeric" default="0" hint="0= no, 1 = yes">
		
		<cfinclude template="queries/q_insert_assigned_contact_to_salesproject.cfm">
		
		<cfreturn true />		
	</cffunction>
	
	<!--- delete a criteria --->
	<cffunction access="public" name="DeleteFilterCriteria" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="viewkey" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		
		<cfinclude template="queries/q_delete_filter_criteria.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="UpdateActivityCountOfContact" output="false" returntype="struct"
			hint="update the activity count index of a contact, and if available, of the account as well">
		<cfargument name="objectkey" type="string" required="true"
			hint="entrykey of account or contact">
		<cfargument name="servicekey" type="string" required="false" default="52227624-9DAA-05E9-0892A27198268072"
			hint="servicekey of object, default = addressbook">
		<cfargument name="itemtype" type="string" required="true"
			hint="which item should we update? followups, appointments, tasks or salesprojects?">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_int_number_followups = 0 />
		
		<cfinclude template="utils/activities/inc_update_activity_count.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="CreateUpdateHistoryItem" output="false" returntype="struct"
			hint="autopickup function for create / update history item ...">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="action_type" type="string" default="create" required="true"
			hint="create or update">
		<cfargument name="database_values" type="struct" required="true"
			hint="structure with values ...">
		<cfargument name="all_values" type="struct" required="true"
			hint="various other variables">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_create = StructNew() />
		<cfset var a_history_item = 0 />
		
		<!--- create or update? ... --->
		<cfif arguments.action_type IS 'create'>
			
			<!--- commented out projectkey = arguments.database_values.projectkey, ... --->
		
			<cfset stReturn_create = CreateHistoryItem(securitycontext = arguments.securitycontext,
												usersettings = arguments.usersettings,
												servicekey = arguments.database_values.servicekey,
												objectkey = arguments.database_values.objectkey,
												subject = arguments.database_values.subject,
												comment = arguments.database_values.comment,
												dt_created = arguments.database_values.dt_created,
												item_type = arguments.database_values.item_type,
												linked_servicekey = arguments.database_values.linked_servicekey,
												linked_objectkey = arguments.database_values.linked_objectkey) />
				
		<cfelse>
		
			<!--- update the item --->
			<cfquery>
			UPDATE	history
			SET		subject		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.subject#" />,
					comment		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.comment#" />,
					item_type	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.database_values.item_type#" />
			WHERE	entrykey 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#" />
			</cfquery>
		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="BuildFullCriteriaChainFromIDs" output="false" returntype="string"
			hint="return the whole chain to level 0 from the given ID">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="ids" type="string" required="true"
			hint="the ID to test for ...">
			
		<cfset var sReturn = '' />
		<cfset var a_int_id = 0 />
		<cfset var q_select_criteria = GetFullCriteriaQuery(companykey = arguments.securitycontext.mycompanykey) />

		<cfloop list="#arguments.ids#" index="a_int_id">
			<cfset sReturn = GetAllCriteriaParentElements(id = a_int_id, string_already = sReturn, query_all = q_select_criteria) />
		</cfloop>
		
		<cfreturn ListDeleteDuplicates(sReturn) />
	</cffunction>
	
	<cffunction access="private" name="GetAllCriteriaParentElements" output="false" returntype="string"
			hint="add parent ID ...">
		<cfargument name="id" type="numeric" required="yes">
		<cfargument name="string_already" type="string" required="no" default="" hint="">
		<cfargument name="query_all" type="query" required="yes">
		
		<cfset var sReturn = ListAppend(arguments.string_already, arguments.id) />
		<cfset var q_select_has_parent = 0 />
		
		<cfquery name="q_select_has_parent" dbtype="query">
		SELECT
			parent_id
		FROM
			arguments.query_all
		WHERE
			id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		;
		</cfquery> 
		
		<cfif (val(q_select_has_parent.parent_id) GT 0) AND (ListFindNoCase(sReturn, q_select_has_parent.parent_id) IS 0)>
			<cfset sReturn = trim(GetAllCriteriaParentElements(id = q_select_has_parent.parent_id, string_already = sReturn, query_all = arguments.query_all)) />
		</cfif>
		
		<cfreturn sReturn />
	</cffunction>
	
	<!--- check if a directory has been created for this user ... if not, do so now --->
	<cffunction access="public" name="CheckAndCreateDirectoryForContactInStorage" output="false" returntype="boolean"
			hint="check if a the directory to a contact exists in the storage">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes" hint="entrykey of contact">
		
		<cfset var stSecurityContext_display_files = 0 />
		<cfset var stUserSettings_display_files = 0 />
		<cfset var a_str_contactkey = arguments.contactkey />
		<cfset var a_str_root_directory = '' />
		<cfset var q_select_directory_exists = 0 />
		
		<cfset var a_struct_binding = GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey) />
		
		<cfinclude template="utils/storage/inc_check_create_storage_directory_for_contact.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<!--- return the entrykey of the directory assigned to the contact --->
	<cffunction access="public" name="GetStorageDirectoryKeyOfContact" output="false" returntype="string">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes" hint="entrykey of contact">
		
		<cfset var a_str_current_directory_entrykey = '' />		
		<cfinclude template="utils/storage/inc_get_storage_root_directory_for_contact.cfm">		
		<cfreturn a_str_current_directory_entrykey />
	
	</cffunction>
	
</cfcomponent>

