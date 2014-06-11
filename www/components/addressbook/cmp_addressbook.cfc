<!--- //

	Component:	Address Book
	Description:Address Book Component
	

// --->
<cfcomponent output='false'>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfset sServiceKey = "52227624-9DAA-05E9-0892A27198268072" />
	
	<cffunction access="public" name="GetOwnContactCardEntrykey" output="false" returntype="string"
			hint="return the entrykey of the own address book item">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of user">
			
		<cfset var sEntrykey = '' />
		
		<cfinclude template="queries/ownvcard/q_select_own_vcard_entrykey.cfm">
		
		<cfreturn sEntrykey />

	</cffunction>
	
	<cffunction access="public" name="GetContactDisplayNameData" output="false" returntype="string"
			hint="quick name display ... without security permission check">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="query_holding_data" type="query" required="false"
			hint="the query maybe already holding the data">

		<cfset var sReturn = '' />
		<cfset var q_select_contact_quick_display_data = 0 />
		<cfset var a_str_hash_cache_name = 'sReturn_contact_display_name_cached' & Hash(arguments.entrykey) />
		
		<cfif StructKeyExists(request, a_str_hash_cache_name)>
			<cfreturn request[a_str_hash_cache_name] />
		</cfif>

		<cfif StructKeyExists(arguments, 'query_holding_data') AND arguments.query_holding_data.recordcount IS 1>
			<cfset q_select_contact_quick_display_data = arguments.query_holding_data />
		<cfelse>
			<cfinclude template="queries/q_select_contact_quick_display_data.cfm">
		</cfif>		
		
		<cfinclude template="utils/inc_return_quick_name_display.cfm">
		
		<cfset request[a_str_hash_cache_name] = sReturn />
		
		<cfreturn sReturn />
	</cffunction>
	
	<cffunction access="public" name="ReturnSubItemsWithGivenPermissions" output="false" returntype="query"
			hint="return all sub items where use is allowed the given action">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of account/contact to look for ...">
		<cfargument name="neededaction" type="string" required="false" default="read"
			hint="the desired action">
		<cfargument name="securitycontext" type="struct" required="true">
		
		<cfset var q_select_sub_items = ReturnSubItems(entrykey = arguments.entrykey) />
		<cfset var a_struct_permissions = 0 />
		<cfset var tmp = QueryAddColumn(q_select_sub_items, 'allowed', 'Integer', ArrayNew(1)) />
		
		<cfloop query="q_select_sub_items">
			<cfset a_struct_permissions = application.components.cmp_security.CheckIfActionIsAllowed(servicekey = sServiceKey,
										securitycontext = arguments.securitycontext,
										object_entrykey = q_select_sub_items.entrykey,
										neededaction = arguments.neededaction) />
										
			<cfset QuerySetCell(q_select_sub_items, 'allowed', ReturnZeroOneOnTrueFalse(a_struct_permissions.result), q_select_sub_items.currentrow) />
		</cfloop>
		
		<!--- select now all allowed items ... --->
		<cfquery name="q_select_sub_items" dbtype="query">
		SELECT
			*
		FROM
			q_select_sub_items
		WHERE
			allowed = 1
		;
		</cfquery>
		
		<cfreturn q_select_sub_items />
	</cffunction>
	
	<cffunction access="private" name="ReturnSubItems" output="false" returntype="query"
			hint="return the sub items">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of account/contact to look for ...">
			
		<cfset var q_select_sub_items = 0 />
			
		<cfinclude template="queries/q_select_sub_items.cfm">
		
		<cfreturn q_select_sub_items />

	</cffunction>
	
	<cffunction access="public" name="GetContact" output="false" returntype="struct"
			hint="try to read a contact and return to calling function">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the contact / account / lead / ...">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="loadcrmdata" type="boolean" default="false" required="no"
			hint="load the crm data (own query in the return strucutre)">
		<cfargument name="create_exclusive_default_lock" type="boolean" default="false" required="false"
			hint="Create an exclusive lock (in case of edit operation)">
		<cfargument name="loadmetainformations" type="boolean" default="false" required="false"
			hint="load meta information (assigned users, workgroupshareinformation)">
		<cfargument name="options" type="string" default="" required="false"
			hint="various options passed as comma separated list">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = StructNew() />
		<cfset var q_select_contact = 0 />
		<cfset var q_select_parent_contact = 0 />
		<cfset var a_struct_lock = 0 />
		
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

		<!--- load item ... --->
		<cfinclude template="queries/q_select_contact.cfm">
			
		<cfif q_select_contact.recordcount IS 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfset stReturn.q_select_contact = q_select_contact />
		<cfset stReturn.q_select_parent_contact = q_select_parent_contact />
		
		<cfif arguments.loadmetainformations>
			
			<!--- load assigned employees --->
			<cfset stReturn.q_select_assigned_contacts = application.components.cmp_assigned_items.GetAssignments(servicekey = sServiceKey,
																	objectkeys = arguments.entrykey) />
			
			<!--- load wg share information ...--->
			<cfset stReturn.q_select_workgroup_shares = application.components.cmp_security.GetWorkgroupSharesForObject(servicekey = sServiceKey,
																	entrykey = arguments.entrykey,
																	securitycontext = arguments.securitycontext) />
																	
		</cfif>
		
		<!--- generate various display information ... --->
		<cfinclude template="utils/inc_set_displayvalue_data.cfm">
		
		<!--- load sub items (if not disabled by option) ... --->
		<cfif ListFindNoCase(arguments.options, 'DoNotLoadSubItems') IS 0>
			
			<cfset stReturn.q_select_sub_items = ReturnSubItems(arguments.entrykey) />
		</cfif>
		
		<cfif arguments.loadcrmdata>
			<cfinclude template="utils/inc_load_crm_data_associated_with_contact.cfm">
		</cfif>
		
		<cfif stReturn.rights.edit AND arguments.create_exclusive_default_lock>
			<!--- create lock ... --->
			<cfinvoke component="#application.components.cmp_locks#" method="CreateExclusiveLock" returnvariable="a_struct_lock">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
			</cfinvoke>
			
			<!--- was not possible to create an exclusive lock ... --->
			<cfif NOT a_struct_lock.result>
				
				<cfset stReturn.lock_information = a_struct_lock />
				
				<cfreturn SetReturnStructErrorCode(stReturn, 5300) />
				
			</cfif>
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<!--- load all contacts and return them to the user ... --->
	<cffunction access="public" name="GetAllContacts" output="false" returntype="struct"
			hint="load contacts based on filter/criteria">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="orderby" type="string" default="surname" required="false"
			hint="order by certain field, default = surname">
		<cfargument name="loadoptions" type="struct" required="false" default="#StructNew()#"
			hint="various loading options">
		<cfargument name="filterdatatypes" type="string" default="0" required="false"
			hint="which data types to return (0 = contact, 1 = account, 2 = lead, 3 = archive/pool">
		<cfargument name="fieldlist" type="string" required="false" default="firstname,surname,email_prim,entrykey"
			hint="field list to load">
		<cfargument name="filter" type="struct" required="false" default="#StructNew()#"
			hint="filter/search items">
		<cfargument name="loadfulldata" type="boolean" required="false" default="false"
			hint="load all available fields (especially for outlookSync)">
		<cfargument name="loaddistinctcategories" type="boolean" required="false" default="false"
			hint="create a structure holding the distinct categories">
		<cfargument name="convert_lastcontact_utc" type="boolean" required="no" default="true"
			hint="return user timezone based timestamps instead of UTC">
		<cfargument name="crmfilter" type="struct" required="no" default="#StructNew()#"
			hint="crm filters">
		<cfargument name="loadowndatafields" type="boolean" default="false" required="no"
			hint="load data from own database associated with this contact?">
		<cfargument name="CacheLookupData" type="boolean" default="true" required="false"
			hint="Cache IDs of data which are loaded using the current filter settings?">
		
		<!--- the return data struct ... --->
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var begin = GetTickCount() />
		<cfset var a_str_jobkey = CreateUUID() />
		<cfset var q_select_contacts = 0 />
		<cfset var a_str_param_string = '' />
		<cfset var sOrderBy = '' />
		<cfset var ii = 0 />
		<cfset var a_int_ids_from_entrykeys = 0 />
		<cfset var a_str_crm_filter_entrykeys = '' />
		<cfset var a_bol_use_cached_ids = false />
		<cfset var a_int_list_entrykeys_workgroup = '' />
		<cfset var a_bol_private_only = (StructKeyExists(arguments.filter, 'workgroupkey') AND (CompareNoCase(arguments.filter.workgroupkey, 'private') IS 0)) />
		<cfset var a_bol_workgroups_available = false />
		<cfset var a_bol_filtered = false />
		<cfset var a_struct_contact_ids = StructNew() />
		<cfset var a_str_cols = '' />
		<cfset var a_str_col_list = '' />
		<cfset var q_table_fields = 0 />
		<cfset var q_select_addressbook_field = 0 />
		<cfset var q_select_additional_data = 0 />
		<cfset var a_struct_crmsales_bindings = 0 />
		<cfset var a_int_start_loop = 0 />
		<cfset var a_int_maxrows_loop = 0 />
		<cfset var a_arr_ids_to_load = ArrayNew(1) />
		<cfset var a_int_recordcount = 0 />
		<cfset var a_str_list_of_ids_to_load = '' />
		<cfset var sIDList = '' />
		<cfset var a_str_original_id_list = '' />
		<cfset var a_int_totalcount = 0 />
		<cfset var a_struct_categories = 0 />
		<cfset var sIDList_for_loading_categories = 0 />
		<cfset var a_str_category = '' />
		<!--- additional data read? ... --->
		<cfset var a_bol_own_db_additional_data_found = false />
		<cfset var q_select_ids_from_entrkeys = 0 />
		<cfset var q_select_workgroup_entrykeys = 0 />
		<cfset var q_select_own_entrykeys = 0 />
		<cfset var q_select_ids_sorted = 0 />
		<cfset var sEntrykeys_lastshown_contacts = '' />
		<cfset var a_struct_new_filter = 0 />
		<cfset var q_select_cached_ids_available = 0 />
		<cfset var q_select_workgroups = 0 />
		
		<!--- returned meta data (f.e. the followup items (entrykeys of these items) that match the filter ... --->
		<cfset stReturn.crm_filter_returned_meta_data = StructNew() />
		
		<!--- set default maxrows to 500 --->
		<cfif NOT StructKeyExists(arguments.loadoptions, 'maxrows')>
			<cfset arguments.loadoptions.maxrows = 2000 />
		</cfif>		
				
		<!--- load now workgroups with the read permission ... --->
		<cfinvoke component="#application.components.cmp_security#" method="LoadPossibleWorkgroupsForAction" returnvariable="q_select_workgroups">
			<cfinvokeargument name="q_workgroup_permissions" value="#arguments.securitycontext.q_select_workgroup_permissions#">
			<cfinvokeargument name="desiredactions" value="read">
		</cfinvoke>
		
		<cfset a_bol_workgroups_available = ((a_bol_private_only IS FALSE) AND (q_select_workgroups.recordcount GT 0)) />
		
		<!--- some reserved orderby parameters maybe ... we need to do a lookup! --->
		<cfinclude template="utils/inc_lookup_special_orderby_parameters.cfm">
		
		<cfif StructCount(arguments.crmfilter) GT 0>
			<cfinclude template="utils/inc_check_crm_filter.cfm">
		</cfif>
				
		<!--- really execute query ... --->
		<cfinclude template="queries/q_select_contacts.cfm">
		
		<cfset stReturn.duration = GetTickCount() - begin />
		
		<!--- sum of contacts which are active using the search criteria ... --->
		<cfset stReturn.a_int_recordcount = a_int_recordcount />
		
		<cfif arguments.loaddistinctcategories>
			<cfset stReturn.categories = a_struct_categories />
		</cfif>
		
		<!--- <cfif arguments.loadowndatafields>
			<!--- load CRM data associated with these accounts? --->
			<cfinclude template="utils/inc_load_crm_data_associated_with_contacts.cfm">
		</cfif> --->
				
		<cfif StructKeyExists(arguments.loadoptions, 'load_sub_contacts') AND arguments.loadoptions.load_sub_contacts>
			<!--- load sub contacts ... --->
			<cfinclude template="queries/q_select_sub_contacts.cfm">
			
			<cfset stReturn.q_select_sub_contacts = q_select_sub_contacts />
			
			<cfset stReturn.a_struct_accounts = a_struct_accounts />
		</cfif>
		
		<cfset stReturn.q_select_contacts = q_select_contacts />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
		
	<cffunction access="public" name="CreateContact" output="false" returntype="struct"
			hint="insert a new contact">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="firstname" type="string" required="false" default=""
			hint="First name">
		<cfargument name="surname" type="string" required="false" default=""
			hint="Surname">
		<cfargument name="company" type="string" required="false" default=""
			hint="Name of company">
		<cfargument name="department" type="string" required="false" default=""
			hint="Name of department in company">
		<cfargument name="position" type="string" required="false" default=""
			hint="Position in company">
		<cfargument name="title" type="string" required="false" default=""
			hint="Title">
		<cfargument name="sex" type="numeric" required="false" default="-1"
			hint="0 = male; 1 = female; -1 = unknown (default)">
		<cfargument name="email_prim" type="string" required="false" default=""
			hint="Primary e-amil address">
		<cfargument name="email_adr" type="string" required="false" default=""
			hint="Further email addresses">
		<cfargument name="birthday" type="string" required="false" default="" hint="birthday (in ts{...} format)">
		<cfargument name="categories" type="string" required="false" default=""
			hint="cateogires (separated by comma)">
		<cfargument name="criteria" type="string" required="no" default=""
			hint="applying criteria IDs">
		<cfargument name="nace_code" type="string" default="0" required="false"
			hint="NACE code">
		
		<cfargument name="b_street" type="string" required="false" default="">
		<cfargument name="b_city" type="string" required="false" default="">
		<cfargument name="b_zipcode" type="string" required="false" default="">
		<cfargument name="b_country" type="string" required="false" default="">
		<cfargument name="b_telephone" type="string" required="false" default="">
		<cfargument name="b_telephone_2" type="string" required="false" default="">
		<cfargument name="b_fax" type="string" required="false" default="">
		<cfargument name="b_mobile" type="string" required="false" default="">
		<cfargument name="b_url" type="string" required="false" default="">		
		
		<cfargument name="p_street" type="string" required="false" default="">
		<cfargument name="p_city" type="string" required="false" default="">
		<cfargument name="p_zipcode" type="string" required="false" default="">
		<cfargument name="p_country" type="string" required="false" default="">
		<cfargument name="p_telephone" type="string" required="false" default="">
		<cfargument name="p_fax" type="string" required="false" default="">
		<cfargument name="p_mobile" type="string" required="false" default="">
		<cfargument name="p_url" type="string" required="false" default="">		
		
		<cfargument name="ownfield1" type="string" required="false" default="">				
		<cfargument name="ownfield2" type="string" required="false" default="">				
		<cfargument name="ownfield3" type="string" required="false" default="">				
		<cfargument name="ownfield4" type="string" required="false" default="">						
		
		<cfargument name="skypeusername" type="string" required="false" default=""
			hint="skype username of contact">
		<cfargument name="language" type="string" required="no" default=""
			hint="language of contact (iso code like de, en, sk ...)">
		<cfargument name="employees" type="string" default="" required="false"
			hint="number of employees">
		
		<cfargument name="notice" type="string" required="false" default="">
		
		<cfargument name="sender" type="string" default="user" required="no"
			hint="sender of item (internal use only) ... f.e. SyncML, webservice, ...">
		<cfargument name="contacttype" type="numeric" default="0" required="no"
			hint="0 = contact (default); 1 = account (organisation)">
		<cfargument name="parentcontactkey" type="string" default="" required="no"
			hint="entrykey of account">
		<cfargument name="superiorcontactkey" type="string" default="" required="false"
			hint="entrykey of the superior contact">
		<cfargument name="options" type="string" default="" required="no" hint="various options">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var sEntrykey = CreateUUID() />
		<cfset var tmp = 0 />
		<cfset var a_struct_crmsales_bindings = 0 />
		<cfset var stReturn_assign_criteria = 0 />
		<cfset var q_insert_contact = 0 />
		
		<cfset stReturn.entrykey = sEntrykey />
		
		<!--- let the component build the full criteria chain correctly ... --->
		<cfset arguments.criteria = application.components.cmp_crmsales.BuildFullCriteriaChainFromIDs(securitycontext = arguments.securitycontext,
										ids = arguments.criteria) />
		
		<cfif ListFindNoCase(arguments.options, 'lookupParentData') GT 0>
			<cfif Len(arguments.parentcontactkey) GT 0>
				<!--- load data of parent and insert contact with this data if possible --->
				<cfinclude template="utils/inc_load_parent_contact_data_on_create_contact.cfm">
				
				<!--- use crm data of parent contact? --->
				<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
					<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
				</cfinvoke>
				
				<!--- additional table exists ... load data of parent contact and save it to table ... --->
				<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
				
				</cfif>
	
				
			</cfif>
		</cfif>
		
		<!--- check the provided NACE code --->
		<cfif Len(arguments.nace_code) GT 0>
			<cfset arguments.nace_code = CheckNearestAvailableNACECode(arguments.nace_code) />
		</cfif>
		
		<!--- call insert query --->
		<cfinclude template="queries/q_insert_contact.cfm">
		
		<cfif Len(arguments.criteria) GT 0>
			
			<cfinvoke component="#application.components.cmp_crmsales#" method="AssignCriteriaToObject" returnvariable="stReturn_assign_criteria">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="objectkey" value="#sEntrykey#">
				<cfinvokeargument name="criteria_ids" value="#arguments.criteria#">
			</cfinvoke>
			
		</cfif>
		
		<cfset ClearCachedIDsForCompany(arguments.securitycontext) />		
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="private" name="CheckNearestAvailableNACECode" output="false" returntype="string"
			hint="Check the nearest available NACE code for the given code (might be longer than the codes available in the system)">
		<cfargument name="nace_code" type="string" required="true"
			hint="the current code">
			
		<cfset var sReturn = arguments.nace_code />
		<!--- load all nace codes --->
		<cfset var q_select_nace_codes = ReturnAllNaceCodes(language = 0) />
		<cfset var a_str_tmp_check = 0 />
		<cfset var q_select_code_is_valid = 0 />
		<cfset var bHit = false />
		
		<cflog application="false" file="ib_nace_lookup" text="--- lookup of: #sReturn#" type="information">
		
		<cfif (Len(sReturn) IS 0) OR (arguments.nace_code IS '0')>
			<cfreturn '' />
		</cfif>
		
		<!--- always remove one char from the right in order to find the correct code --->
		<cfloop condition="Len(sReturn) GT 0">
			
			<cflog application="false" file="ib_nace_lookup" text="next try: #val(sReturn)#" type="information">
			
			<cfquery name="q_select_code_is_valid" dbtype="query">
			SELECT
				code
			FROM
				q_select_nace_codes
			WHERE
				code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sReturn#">
			;
			</cfquery>
			
			<!--- we have a hit! --->
			<cfif q_select_code_is_valid.recordcount IS 1>
				<cfset bHit = true />
				<cfbreak>
			</cfif>
		
			<!--- if we are already at one char only, then exit (no hit) --->
			<cfif Len(sReturn) IS 1>
				<cflog application="false" file="ib_nace_lookup" text="no hit for #val(sReturn)#" type="information">
				<cfset bHit = false />
				<cfbreak>
			</cfif>
			
			<!--- if we can still find a smaller number ... try it ... --->
			<cfset sReturn = Left(sReturn, (Len(sReturn) - 1)) />
			
		</cfloop>
		
		<cfif NOT bHit>
			<cfset sReturn = '' />
		</cfif>
		
		<cflog application="false" file="ib_nace_lookup" text="return: #sReturn#" type="information">
		
		<cfreturn sReturn />
	</cffunction>
	
	<cffunction access="public" name="UpdateContact" output="false" returntype="struct"
			hint="update an account orcontact">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of item">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">	
		<cfargument name="newvalues" type="struct" required="true"
			hint="structure holding the data to update ... field names are the same as in createContact">
		<cfargument name="updatelastmodified" type="boolean" required="false" default="true"
			hint="update the lastmodified property">
		<cfargument name="sender" type="string" default="user" required="no"
			hint="sender of this operation">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stReturn_rights = StructNew() />
		<cfset var q_select_sub_contacts = 0 />
		<cfset var a_struct_get_contact = 0 />
		<cfset var stUpdate_sub = 0 />
		<cfset var a_struct_lock = 0 />
		<cfset var tmp = 0 />
		<cfset var a_bol_event_insert = false />
		<cfset var a_bol_return_save_edited = false />
		<cfset var stReturn_assign_criteria = 0 />
		<cfset var a_str_fields_check_sub_update = 'b_city,b_country,b_zipcode,b_telephone,b_street,department,company,aposition,b_url,b_mobile,lang,nace_code,categories' />
		
		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="neededaction" value="edit">
		</cfinvoke>
		 
		 <cfif NOT stReturn_rights.edit>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<!--- create exclusive lock ... --->
		<cfinvoke component="#application.components.cmp_locks#" method="CreateExclusiveLock" returnvariable="a_struct_lock">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
		</cfinvoke>
		
		<cfif NOT a_struct_lock.result>
			<cfreturn a_struct_lock />
		</cfif>
				  
		<!--- in case criteria are provided, calculate the whole chain ... --->
		<cfif StructKeyExists(arguments.newvalues, 'criteria')>
			<cfset arguments.newvalues.criteria = application.components.cmp_crmsales.BuildFullCriteriaChainFromIDs(securitycontext = arguments.securitycontext,
													ids = arguments.newvalues.criteria) />
		</cfif>
		
		<!--- update now ... --->
		<cfinclude template="queries/q_select_contact_raw.cfm">
		 
		<cfinvoke component="#application.components.cmp_log#" method="SaveEditedRecordOldVersion" returnvariable="a_bol_return_save_edited">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="datakey" value="#arguments.entrykey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="query" value="#q_select_contact_raw#">
			<cfinvokeargument name="title" value="#q_select_contact_raw.surname# #q_select_contact_raw.firstname#">
			<cfinvokeargument name="newvalues" value="#arguments.newvalues#">
		</cfinvoke>
			
		<!--- update sub contacts --->
		<cfset q_select_sub_contacts = ReturnSubItems(arguments.entrykey) />
		
		<cfif q_select_sub_contacts.recordcount GT 0>
			<cfinclude template="utils/inc_update_sub_contacts.cfm">
		</cfif>
	 
	 	<!--- call update function ... --->
		<cfinclude template="queries/q_update_contact.cfm">
		
		<!---  AND Len(arguments.newvalues.criteria) GT 0 --->
		<cfif StructKeyExists(arguments.newvalues, 'criteria')>
			
			<cfinvoke component="#application.components.cmp_crmsales#" method="AssignCriteriaToObject" returnvariable="stReturn_assign_criteria">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
				<cfinvokeargument name="criteria_ids" value="#arguments.newvalues.criteria#">
			</cfinvoke>
			
		</cfif>
			
		<cfif arguments.updatelastmodified>
			<!--- call outlook meta update --->
			<cfinclude template="queries/q_update_outlook_meta_data.cfm">
		</cfif>
					
		<cfif StructKeyExists(arguments.newvalues, 'userkey') AND Len(arguments.newvalues.userkey) GT 0>
		
			 <cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
				<cfinvokeargument name="performedaction" value="takeoverownership">
				<cfinvokeargument name="failed" value="#a_int_failed#">
			</cfinvoke>				
			
		</cfif>
		
		<!--- remove lock now ... --->
		<cfinvoke component="#application.components.cmp_locks#" method="RemoveExclusiveLock" returnvariable="a_struct_lock">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
		</cfinvoke>
		
		<cfset a_bol_event_insert = application.components.cmp_events.LogEvent(servicekey = sServiceKey,
										objectkey = arguments.entrykey,
										action = 'edit',
										sender = arguments.sender,
										securitycontext = arguments.securitycontext) />
			
		<cfset ClearCachedIDsForCompany(arguments.securitycontext) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
			
	</cffunction>
		
	<cffunction access="public" name="DeleteContact" output="false" returntype="struct"
			hint="Delete a contact ... returns true if successfully deleted">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of item">
		<cfargument name="usersettings" type="struct" required="true">
		<!--- load contact and check security ... --->
		<!--- delete outlook sync information too? --->
		<cfargument name="clearoutlooksyncmetadata" type="boolean" required="false" default="true" hint="clear meta data too (default = true)">		
		<cfargument name="sender" type="string" default="user" required="no" hint="sender of this operation (f.e. syncml, outlooksync, ...)">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_int_failed = 1 />
		<cfset var stReturn_rights = StructNew() />
		<cfset var a_str_title = "" />
		<cfset var q_select_contact_raw = 0 />
		<cfset var a_orm = 0 />
		<cfset var tmp = 0 />
		<cfset var a_bol_event_insert = false />
		<cfset var a_bol_remove_share = false />
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
		
		<!--- check if we can now really delete the contact ... --->
		<cfinclude template="queries/q_select_contact_raw.cfm">
			
		<cfinvoke component="#application.components.cmp_log#" method="SaveDeletedRecord" returnvariable="a_bol_return_save_deleted">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="datakey" value="#arguments.entrykey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="query" value="#q_select_contact_raw#">
			<cfinvokeargument name="title" value="#q_select_contact_raw.surname# #q_select_contact_raw.firstname#">
		</cfinvoke>
		
		
		<cfset RemoveContactPhoto(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykey = arguments.entrykey) />
			
		<cfset a_str_title = q_select_contact_raw.surname />
			
		<!--- call delete now ... --->
		<cfquery>
		DELETE FROM addressbook
		WHERE		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#" />
		</cfquery>
		
		<!--- set parentcontactkey to empty string for items where this
			entrykey is the parent ... TODO: Testing --->
		<cfinclude template="queries/q_update_set_parentcontactkey_empty_on_delete.cfm">
		
		<cfif arguments.clearoutlooksyncmetadata>
			<!--- clear outlook sync information for all users ... --->
			<cfinclude template="queries/q_delete_outlook_meta_data.cfm">
		</cfif>
		
		<!--- clear cache --->
		<cfset ClearCachedIDsForCompany(arguments.securitycontext) />		

		<!--- return the result ... --->
		<cfset a_bol_event_insert = application.components.cmp_events.LogEvent(servicekey = sServiceKey,
											objectkey = arguments.entrykey,
											action = 'delete',
											sender = arguments.sender,
											securitycontext = arguments.securitycontext) />
											
		<!--- remove all wg shares ... --->
		<cfset a_bol_remove_share = application.components.cmp_security.RemoveAllWorkgroupShares(entrykey = arguments.entrykey,
											servicekey = sServiceKey,
											securitycontext = arguments.securitycontext) />
	
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<!--- return the total number of own records ... --->
	<cffunction access="public" name="GetOwnContactsRecordcount" output="false" returntype="numeric" hint="Return the number of contacts of a certain user">
		<cfargument name="userkey" type="string" required="true">
		
		<cfset var q_select_own_contacts_recordcount = 0 />

		<cfinclude template="queries/q_select_own_contacts_recordcount.cfm">

		<cfreturn Val(q_select_own_contacts_recordcount.count_id) />
	</cffunction>
	
	<!--- get the owner userkey of an object --->
	<cffunction access="public" name="GetOwnerUserkey" output="false" returntype="string"
			hint="return the userkey of the owner of a contact">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var q_select_owner_userkey = 0 />
		<cfinclude template="queries/q_select_owner_userkey.cfm">
		<cfreturn q_select_owner_userkey.userkey />
	</cffunction>
	
	<cffunction access="public" name="RemoveContactPhoto" output="false" returntype="struct"
			hint="remove a photo assigned to a contact">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of contact">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var sFilename = GetPhotoDefaultFilename(arguments.entrykey) />
		<cfset var stUpdate = StructNew() />
		<cfset var stReturn_update = 0 />
		
		<!--- call update and try to set field to zero = does not exist ... --->
		<cfset stUpdate.photoavailable = 0 />
		
		<cfset stReturn_update = UpdateContact(entrykey = arguments.entrykey,
					securitycontext = arguments.securitycontext,
					usersettings = arguments.usersettings,
					newvalues = stUpdate) />
					
		<cfif NOT stReturn_update.result>
			<cfreturn stReturn_update />
		</cfif>
				
		<cfif FileExists(sFilename)>
			<cftry>
			<cffile action="delete" file="#sFilename#">
			<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="StoreContactPhoto" output="false" returntype="struct"
			hint="save a new photo">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		<cfargument name="contenttype" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var sFilename = GetPhotoDefaultFilename(arguments.entrykey) />
		<cfset var stUpdate = StructNew() />
		<cfset var stReturn_update = 0 />
		
		<!--- call update and try to set field to one = does exist ... --->
		<cfset stUpdate.photoavailable = 1 />
		
		<cfif NOT FileExists(arguments.filename)>
			<cfreturn SetReturnStructErrorCode(stReturn, 600) />
		</cfif>
		
		<cfset stReturn_update = UpdateContact(entrykey = arguments.entrykey,
					securitycontext = arguments.securitycontext,
					usersettings = arguments.usersettings,
					newvalues = stUpdate) />
					
		<cfif NOT stReturn_update.result>
			<cfreturn stReturn_update />
		</cfif>
		
		<cfif FileExists(sFilename)>
			<cffile action="delete" file="#sFilename#">
		</cfif>
		
		<cffile action="copy" source="#arguments.filename#" destination="#sFilename#">
			
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="GetPhotoDefaultFilename" output="false" returntype="string">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of contact">
			
		<cfset var sDirectory = request.a_str_storage_directory & request.a_str_dir_separator & 'contact_photos' & request.a_str_dir_separator & Mid(arguments.entrykey, 1, 4) />
		<cfset var sFilename = sDirectory & request.a_str_dir_separator & arguments.entrykey />
		
		<cfif NOT DirectoryExists(sDirectory)>
			<cfdirectory action="create" directory="#sDirectory#">
		</cfif>
		
		<cfreturn sFilename />
		
	</cffunction>
	
	<!--- return the vcard string --->
	<cffunction name="CreateVCard" access="public" output="false" returntype="string">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var sVcard = '' />
		<cfset var a_struct_load_contact = GetContact(entrykey = arguments.entrykey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings) />
		<cfset var q_select_contact = 0 />
		<cfset var a_str_request_scope_cache_item = 'sVcard_' & Hash(arguments.entrykey) />
		
		<!--- cache if more than one request ... --->
		<cfif StructKeyExists(request, a_str_request_scope_cache_item)>
			<cfreturn request[a_str_request_scope_cache_item]>
		</cfif>
		
		
		<cfif NOT StructKeyExists(a_struct_load_contact, 'q_select_contact')>
			<cfreturn ''>
		</cfif>
		
		<cfset q_select_contact = a_struct_load_contact.q_select_contact />
		
		<cfinclude template="utils/inc_create_vcard.cfm">
		
		<cfset request[a_str_request_scope_cache_item] = sVcard />
		
		<cfreturn sVcard />
	
	</cffunction>
	
	<!--- clear cached ids so that they are reloaded ... --->
	<cffunction access="public" name="ClearCachedIDsForCompany" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" hint="securitycontext" required="yes">
		
		<cfinclude template="queries/q_delete_cached_ids_of_company.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="ReturnAllNaceCodes" output="false" returntype="query"
			hint="Return all available NACE codes for one language">
		<cfargument name="language" type="numeric" default="0" required="false"
			hint="lang id">
	
		<cfset var a_str_hash_id = 'q_select_nace_code_data_cached_lang_' & arguments.language />
		<cfset var a_struct_cached_nace_query = application.components.cmp_cache.CheckAndReturnStoredCacheElement(a_str_hash_id) />
		<cfset var q_select_nace_all_nace_codes = 0 />
		<cfset var tmp = 0 />
		
		<!--- if cached version exists, fine ... --->		
		<cfif a_struct_cached_nace_query.result>
			<cfset q_select_nace_all_nace_codes = a_struct_cached_nace_query.data />
		<cfelse>
			<cfinclude template="queries/q_select_nace_all_nace_codes.cfm">
			<cfset application.components.cmp_cache.AddOrUpdateInCacheStore(hashid = a_str_hash_id, datatostore = q_select_nace_all_nace_codes) />
		</cfif>
		
		<cfreturn q_select_nace_all_nace_codes />		
	</cffunction>
	
	<cffunction name="ReturnIndustryNameByNACECode" output="false" returntype="string"
			hint="return the name of the industry by code">
		<cfargument name="nace_code" type="string" default="0" required="true"
			hint="the nace code">
		<cfargument name="language" type="numeric" default="0" required="false"
			hint="lang id">
			
		<cfset var q_select_name = 0 />
		<cfset var q_select_nace_all_nace_codes = ReturnAllNaceCodes(arguments.language) />
		
		<cfquery name="q_select_name" dbtype="query">
		SELECT
			industry_name
		FROM
			q_select_nace_all_nace_codes
		WHERE
			code = '#arguments.nace_code#'
		;
		</cfquery>
		
		<cfreturn q_select_name.industry_name />
	</cffunction>
	
</cfcomponent>