<!--- //

	Module:		Address Book
	Function:	GetAllContacts
	Description:Select all contacts
	
				Select own plus workgroups
				apply the desired filters
				
	

// --->
	
<cfif FindNoCase('backup', cgi.SCRIPT_NAME) GT 0>
	<cfsetting requesttimeout="20000">
<cfelse>
	<cfsetting requesttimeout="600">
</cfif>

<!--- generate parameter string in form of &param=value ...

	This string is compared to the string stored in the database and if no changed are detected,
	the same data is used again and no full load is done ... --->
	
<cfif arguments.CacheLookupData>
	<cfinclude template="utils/inc_set_cached_ids.cfm">
</cfif>

<!--- compose the order by sector ... we're using a special thing now
	... compose all columns which are used for sorting in one
	column and sort everything using this values --->

<cfloop list="#arguments.orderby#" index="sOrderBy_item" delimiters=",">
	
	<cfif ListFindNoCase('surname,firstname,b_city,company,b_zipcode,dt_lastmodified,-dt_lastmodified,dt_created,-dt_created', sOrderBy_item) GT 0>
		
		<!--- order descending? if  "-" is given, yes --->
		<cfset sOrderBy_desc = '' />
		
		<cfif FindNoCase('-', sOrderBy_item) IS 1>
			<cfset sOrderBy_item = Mid(sOrderBy_item, 2, Len(sOrderBy_item)) />
			<!---
			
				TODO: REPAIR
				
				<cfset sOrderBy_item = sOrderBy_item & ' DESC'>
				
				--->
		</cfif>
		
		
		<cfset sOrderBy = ListAppend(sOrderBy, 'addressbook.' & sOrderBy_item, ',') />
	</cfif>
</cfloop>

<!--- default order ... by surname ... --->
<cfif Len(sOrderBy) IS 0>
	<cfset sOrderBy = 'addressbook.surname' />
</cfif>

<cfif ListFindNoCase(sOrderBy, 'addressbook.dt_created') GT 0>
	<!--- using the creation date ... --->
	<cfset ii = ListFindNoCase(sOrderBy, 'addressbook.dt_created') />
	<cfset sOrderBy = ListDeleteAt(sOrderBy, ii) />
	<cfset sOrderBy = ListPrepend(sOrderBy, 'DATE_FORMAT(addressbook.dt_created,''%Y%m%d'')') />
</cfif>

<!--- caching of lookup data enabled? ... --->
<cfif arguments.CacheLookupData>
	<!--- add to parameter string (used for saving cached IDs later) ... --->
	<cfset a_str_param_string = AddParamStringItem(a_str_param_string, 'orderby', sOrderBy) />
	
	<!--- check if a cached version with all the needed IDs is available ... --->
	<cfinclude template="q_select_cached_ids_available.cfm">
	
	<cfset a_bol_use_cached_ids = (q_select_cached_ids_available.recordcount IS 1) />
	
	<cfif a_bol_use_cached_ids>
		<!--- hit ... --->
		<cfinclude template="utils/inc_load_cached_ids.cfm">
	</cfif>
</cfif>

<cfif NOT a_bol_use_cached_ids>

	<!--- try to load IDs first ... --->
	<cfif StructKeyExists(arguments.filter, 'entrykeys') AND
		  Len(arguments.filter.entrykeys) GT 0>
		
		<cfquery name="q_select_ids_from_entrkeys" datasource="#GetDSName()#">
		SELECT	id
		FROM	addressbook
		WHERE	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykeys#" list="yes">)
		;
		</cfquery>
		
		<cfset a_int_ids_from_entrykeys = ValueList(q_select_ids_from_entrkeys.id) />
		
		<cfif Len(a_int_ids_from_entrykeys) IS 0>
			<cfset a_int_ids_from_entrykeys = 0 />
		</cfif>
		
	</cfif>

	<!--- are workgroups available? --->
	<cfif a_bol_workgroups_available>
		
		<cfquery name="q_select_workgroup_entrykeys" datasource="#GetDSName()#">
		SELECT
			addressbook.id,			
			UCASE(LEFT(CONCAT(#PreserveSingleQuotes(sOrderBy)#, ' '), 30)) AS str_sort,
			shareddata.addressbookkey,
			shareddata.workgroupkey
			
			<cfif arguments.loaddistinctcategories>
				,addressbook.categories
			</cfif>
		FROM
			shareddata
		LEFT JOIN
			addressbook ON (addressbook.entrykey = shareddata.addressbookkey)
		WHERE
		
		<cfif StructKeyExists(arguments.filter, 'workgroupkey') AND Len(arguments.filter.workgroupkey) GT 0>
		
			(workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.workgroupkey#">)
		
		<cfelse>
		
			(shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(q_select_workgroups.workgroup_key)#">))
		
		</cfif>
		
			AND
			(addressbook.id > 0)
			
		<!--- entrykeys --->
		<cfif StructKeyExists(arguments.filter, 'entrykeys') AND Len(arguments.filter.entrykeys) GT 0>
			AND
			(addressbook.id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_ids_from_entrykeys#" list="yes">))
		</cfif>
		
		<cfif StructKeyExists(arguments.crmfilter, 'contact') AND (ArrayLen(arguments.crmfilter.contact) GT 0)>
			/* apply CRM filters */
			<cfinclude template="../utils/inc_check_crm_filter_contact.cfm">
		</cfif>
		
		<cfinclude template="inc_select_contacts_search_filter.cfm">
		
		GROUP BY
			shareddata.addressbookkey
		;
		</cfquery>
		
		
		
		<!--- make list --->
		<cfset a_int_list_entrykeys_workgroup = valuelist(q_select_workgroup_entrykeys.id) />
	
	</cfif>

	<!--- select now PERSONAL items ... --->
	<cfquery name="q_select_own_entrykeys" datasource="#GetDSName()#">
	SELECT
		addressbook.id,
		<!--- 2do: include all sorting columns ... --->
		UCASE(LEFT(CONCAT(#PreserveSingleQuotes(sOrderBy)#, ' '), 30)) AS str_sort
		
		<cfif arguments.loaddistinctcategories>
			,addressbook.categories
		</cfif>
	FROM
		addressbook
	WHERE

	<cfif StructKeyExists(arguments.filter, 'workgroupkey') AND Len(arguments.filter.workgroupkey) GT 0>
		
		<cfif arguments.filter.workgroupkey IS 'private'>
			(userkey = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.securitycontext.myuserkey#">)
		<cfelse>
			<!--- load no private data ... --->
			(1 = 0)
		</cfif>
	
	<cfelse>
		(userkey = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.securitycontext.myuserkey#">)

		<cfif a_bol_workgroups_available AND Len(a_int_list_entrykeys_workgroup) GT 0>
			<!--- do not load items which are already loaded --->
			AND
			id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_list_entrykeys_workgroup#" list="yes">)
		</cfif>
		
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'entrykeys') AND Len(arguments.filter.entrykeys) GT 0>
		AND
		(addressbook.id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_ids_from_entrykeys#" list="yes">))
	</cfif>
	
	<cfif StructKeyExists(arguments.crmfilter, 'contact') AND (ArrayLen(arguments.crmfilter.contact) GT 0)>
		<cfinclude template="../utils/inc_check_crm_filter_contact.cfm">
	</cfif>
	
	<cfinclude template="inc_select_contacts_search_filter.cfm">

	;
	</cfquery>

	<!--- brand new way of getting the contact ids ... --->
	<cfset a_tc_start = GetTickCount() />

	<!--- do some q of q ... using UNION to join the two queries ... --->
	<cfquery name="q_select_ids_sorted" dbtype="query">
	SELECT
		id,
		str_sort
	FROM
		q_select_own_entrykeys
		
		<cfif a_bol_workgroups_available>
			<!--- if workgroups are available ... --->
			UNION	
			SELECT
				id,
				str_sort
			FROM
				q_select_workgroup_entrykeys
			
		</cfif>
		
	;
	</cfquery>

	<!--- use the new sort algoryhtm --->
	<cfquery name="q_select_ids_sorted" dbtype="query">
	SELECT
		*
	FROM
		q_select_ids_sorted
	ORDER BY
		str_sort
	;
	</cfquery>

</cfif>

<!--- check if we use the cached version or the "live" version ... --->
<cfif a_bol_use_cached_ids>
	<cfset a_int_sorted_ids_recordcount = q_select_cached_ids_available.items_count />
<cfelse>
	<cfset a_int_sorted_ids_recordcount = q_select_ids_sorted.RecordCount />
</cfif>

<cfif arguments.loadoptions.maxrows GT 0>
	<!--- maxrows definied ... --->
	<cfset a_int_start_loop = 1>
	<cfset a_int_maxrows_loop = arguments.loadoptions.maxrows>
	
	<cfif a_int_maxrows_loop GT a_int_sorted_ids_recordcount>
		<cfset a_int_maxrows_loop = a_int_sorted_ids_recordcount>
	</cfif>
	
<cfelseif StructKeyExists(arguments.loadoptions, 'startrow') AND StructKeyExists(arguments.loadoptions, 'rowsperpage')>
	<!--- start/endrow definied ... --->
	<cfset a_int_start_loop = arguments.loadoptions.startrow>
	<cfset a_int_maxrows_loop = a_int_start_loop + arguments.loadoptions.rowsperpage - 1>
	
	<!--- check if maxrows is greather than recordcount ... --->
	<cfif a_int_maxrows_loop GT a_int_sorted_ids_recordcount>
		<cfset a_int_maxrows_loop = a_int_sorted_ids_recordcount>
	</cfif>
<cfelse>
	<!--- load all ... --->
	<cfset a_int_start_loop = 1>
	<cfset a_int_maxrows_loop = a_int_sorted_ids_recordcount>
</cfif>

<!--- use ListGetAt or query[x] ... depends on "live" or "cached"

	also set the number of contacts (recordcount) --->
<cfif a_bol_use_cached_ids>
	<cfscript>
	for (x = a_int_start_loop; x LTE a_int_maxrows_loop; x=x+1) {
		a_arr_ids_to_load[ArrayLen(a_arr_ids_to_load) + 1] = ListGetAt(q_select_cached_ids_available.ids, x);
		}
	</cfscript>
	
	<cfset a_int_recordcount = q_select_cached_ids_available.items_count>
<cfelse>
	<cfscript>
	for (x = a_int_start_loop; x LTE a_int_maxrows_loop; x=x+1) {
		a_arr_ids_to_load[ArrayLen(a_arr_ids_to_load) + 1] = q_select_ids_sorted.id[x] ;
		}
	</cfscript>
	
	<cfset a_int_recordcount = q_select_ids_sorted.recordcount>
</cfif>

<!--- this list now contains the items we have to load ... --->
<cfset a_str_list_of_ids_to_load = ArrayToList(a_arr_ids_to_load)>

<!--- check now if there are special entries which this user is not allowed to read ...
	remove them from the entrykey list ... to implement --->



<!--- ok, here we proceed ... set the ID list to the items to load --->
<cfset sIDList = a_str_list_of_ids_to_load />

<cfif Len(sIDList) IS 0>
	<cfset sIDList = 0 />
</cfif>

<cfset a_str_original_id_list = Duplicate(sIDList) />

<cfif Len(sIDList) IS 0>
	<cfset sIDList = 0 />
</cfif>
		
<!--- // build the sql select statement // --->
<cfsavecontent variable="a_str_sql_select_fields">
	
	<cfif StructKeyExists(arguments.loadoptions, 'fieldstoselect') AND
		Len(arguments.loadoptions.fieldstoselect) GT 0>
		<!--- new: specify the fields that have to be loaded --->

		<cfoutput>
		#arguments.loadoptions.fieldstoselect#,
		UCASE(LEFT(CONCAT(#sOrderBy#, ' '), 30)) AS str_sort,
		'' AS workgroupkeys,
		addressbook.id
		</cfoutput>
		
	<cfelse>
		
		<!--- the ordenary way --->
		<cfoutput>
		addressbook.firstname,
		addressbook.surname,
		addressbook.company,
		addressbook.department,
		addressbook.aposition,
		addressbook.userkey,
		addressbook.entrykey,
		addressbook.contacttype,
		DATE_FORMAT(addressbook.birthday, "%Y-%m-%d %T") AS birthday,
		addressbook.archiveentry,
		addressbook.b_zipcode,
		addressbook.b_city,
		
		<cfif arguments.convert_lastcontact_utc>
			DATE_ADD(addressbook.dt_lastcontact, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_lastcontact,
			DATE_ADD(addressbook.dt_lastsmssent, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_lastsmssent,
			DATE_ADD(addressbook.dt_created, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_created,
			DATE_ADD(addressbook.dt_lastmodified, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS dt_lastmodified,	
		<cfelse>
			addressbook.dt_lastcontact,dt_created,dt_lastsmssent,dt_lastmodified,
		</cfif>
		addressbook.categories,
		addressbook.email_prim,
		addressbook.email_adr,
		addressbook.b_telephone,
		addressbook.b_mobile,
		addressbook.p_telephone,
		addressbook.p_mobile,
		addressbook.b_fax,
		addressbook.p_fax,
		addressbook.privatecontact,
		'' AS workgroupkeys,
		addressbook.skypeusername,
		addressbook.parentcontactkey,
		addressbook.employees,
		addressbook.activity_count_followups,
		addressbook.activity_count_appointments,
		addressbook.activity_count_tasks,
		addressbook.activity_count_salesprojects,
		addressbook.criteria,
		
		<cfif StructKeyExists(arguments.loadoptions, 'ucase_firstchar_surname') AND arguments.loadoptions.ucase_firstchar_surname>
			UPPER(LEFT(addressbook.surname, 1)) AS ucase_firstchar_surname,
		</cfif>
		
		<!--- shall we display the lately displayed contacts of the user?
			In this case sort by the given list index ... --->
		<cfif arguments.orderby IS 'lastdisplayed'>
		FIND_IN_SET(addressbook.entrykey, "#sEntrykeys_lastshown_contacts#") AS index_entrykey,
		</cfif>
		
		UCASE(LEFT(CONCAT(#sOrderBy#, " "), 30)) AS str_sort
		
		<cfif arguments.loadfulldata>
			,addressbook.b_street,
			addressbook.b_country,
			addressbook.p_city,
			addressbook.p_zipcode,
			addressbook.p_street,
			addressbook.p_country,
			addressbook.b_url,
			addressbook.p_url,
			addressbook.notice,
			addressbook.sex,
			addressbook.lang,
			addressbook.title
		</cfif>
		
		<!--- include own data fields? ... old version removed --->
	
		
		</cfoutput>
	
	</cfif>
	
</cfsavecontent>
		
<!--- now we've got a list of ids to load!! --->
<cfquery name="q_select_contacts" datasource="#GetDSName()#">
SELECT
	#a_str_sql_select_fields#			
FROM
	addressbook
WHERE
	<!--- load the entrykeys ... --->
	addressbook.id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#sIDList#" list="yes">)
ORDER BY

	<!--- order by which type ... default = use sort string, otherwise, check index_entrykey ... --->	
	<cfswitch expression="#arguments.orderby#">
		<cfcase value="lastdisplayed">
			index_entrykey
		</cfcase>
		<cfdefaultcase>
			str_sort
		</cfdefaultcase>>
	</cfswitch>
	
;
</cfquery>

<!--- return custom db fields ... --->
<cfif a_bol_own_db_additional_data_found>
	<cfset stReturn.q_select_table_fields = q_table_fields />
</cfif>

<cfset a_int_totalcount = q_select_contacts.recordcount />

<!--- load categories from scratch if not cached ... --->
<cfif NOT a_bol_use_cached_ids>
	
	<cfset a_struct_categories = StructNew() />

	<!--- get distinct categories if needed --->
	<cfif arguments.loaddistinctcategories>
	
		<cfset sIDList_for_loading_categories = valuelist(q_select_ids_sorted.id)>
		
		<cfif ListLen(sIDList_for_loading_categories) IS 0>
			<cfset sIDList_for_loading_categories = 0>
		</cfif>
		
		<cfquery name="q_select_all_categories" dbtype="query">
		SELECT
			categories
		FROM
			q_select_own_entrykeys
			
			<cfif a_bol_workgroups_available>
				<!--- if workgroups are available ... --->
				UNION	
				SELECT
					categories
				FROM
					q_select_workgroup_entrykeys			
			</cfif>
		;
		</cfquery>
		
		<cfloop query="q_select_all_categories">
		
			<cfif Len(q_select_all_categories.categories) GT 0>
		
				<cfloop list="#q_select_all_categories.categories#" delimiters="," index="a_str_category">
					<cfset a_str_category = trim(a_str_category)>
					
					<cfif NOT StructKeyExists(a_struct_categories, a_str_category)>
						<cfset a_struct_categories[a_str_category] = 1>
					<cfelse>
						<cfset a_struct_categories[a_str_category] = a_struct_categories[a_str_category] + 1>
					</cfif>
				</cfloop>
			
			</cfif>
		
		</cfloop>
	
	</cfif>

</cfif>

<!--- <cflog text="categories done: #(GetTickCount() - begin)#" type="Information" log="" file="ib_crm_load_contacts">
	 --->	
<!--- create workgroup information from scratch (if desired)

	otherwise do nothing or use the cached version ... --->
<cfset stWGInfo = StructNew()>

<cfif NOT a_bol_use_cached_ids>
	<!--- check if we've got to load the workgroup information (which contact is shared by which group --->
	<cfset a_bol_load_workgroups_information = a_bol_workgroups_available>
	
	<cfif a_bol_load_workgroups_information AND StructKeyExists(arguments.loadoptions, 'loadworkgroupmetainformation')
		  AND NOT arguments.loadoptions.loadworkgroupmetainformation>
		<cfset a_bol_load_workgroups_information = false>
	</cfif>
	
	<cfif a_bol_load_workgroups_information>
	
		<cfset sEntrykeys_workgroups_to_load = ValueList(q_select_contacts.entrykey)>
		
		<cfif Len(sEntrykeys_workgroups_to_load) IS 0>
			<cfset sEntrykeys_workgroups_to_load = 'dummy123'>
		</cfif>
	
		<!--- select only the selected entrykeys --->
		<cfquery name="q_select_workgroup_entrykeys" dbtype="query">
		SELECT
			addressbookkey,
			workgroupkey
		FROM
			q_select_workgroup_entrykeys
		WHERE
			addressbookkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys_workgroups_to_load#" list="yes">)
		;
		</cfquery>
	
		<cfloop query="q_select_workgroup_entrykeys">
			
			<cfif StructKeyExists(stWGInfo, q_select_workgroup_entrykeys.addressbookkey)>	
				<cfset stWGInfo[q_select_workgroup_entrykeys.addressbookkey] = ListAppend(stWGInfo[q_select_workgroup_entrykeys.addressbookkey], q_select_workgroup_entrykeys.workgroupkey) />
			<cfelse>
				<cfset stWGInfo[q_select_workgroup_entrykeys.addressbookkey] = q_select_workgroup_entrykeys.workgroupkey />
			</cfif>
		
		</cfloop>
	</cfif>
	
	<cfloop query="q_select_contacts">
	
		<cfif StructKeyExists(stWGInfo,q_select_contacts.entrykey)>
			<cfset QuerySetCell(q_select_contacts, 'workgroupkeys', stWGInfo[q_select_contacts.entrykey], q_select_contacts.currentrow)>
		</cfif>
	
	</cfloop>
</cfif>

<!--- save ids with the used parameters in a cached template table --->
<cfif arguments.CacheLookupData>
	<cfif NOT a_bol_use_cached_ids>
		<cfinclude template="q_insert_cached_ids.cfm">
	</cfif>
</cfif>

