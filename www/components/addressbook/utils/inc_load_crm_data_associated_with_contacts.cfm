<!--- //

	Module:		Address Book
	Function:	GetContacts
	Description: 
	

// --->

<cfset a_cmp_lang = application.components.cmp_lang />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<cfset stReturn.a_struct_crmsales_bindings = a_struct_crmsales_bindings />
				<!--- 
<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
		
	<!--- load fields and set in return structure --->
	<cfinvoke
		component = "#application.components.cmp_own_db#"   
		method = "GetTableFields"   
		returnVariable = "q_table_fields"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#">
	</cfinvoke>
	
	<!--- select only basic columns ... --->
	<cfquery name="q_table_fields" dbtype="query">
	SELECT
		fieldname,showname,fieldtype,fielddescription
	FROM
		q_table_fields
	;
	</cfquery>
	
	<!--- add own fields ... --->
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_telephone', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_telephone', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>
	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_fax', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_fax', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>
		

	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'cm_wd_mobile', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_mobile', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>
				
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'cm_wd_categories', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'categories', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>
								
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_surname', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'surname', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_title', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'title', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
		
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_firstname', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'firstname', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', 'EMail', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'email_prim', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_company', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'company', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_department', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'department', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	

	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_position', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'aposition', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
		
		
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_country', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_country', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', 'Letztkontakt', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'dt_lastcontact', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', 'Betreuer', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'custodians', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_city', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_city', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_zipcode', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_zipcode', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>		
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'adrb_wd_country', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'b_country', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>		
	
	<cfset QueryAddRow(q_table_fields, 1)>
	<cfset QuerySetCell(q_table_fields, 'showname', a_cmp_lang.GetLangValExt(entryid = 'cm_wd_created', langno = arguments.usersettings.language), q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldname', 'dt_created', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fieldtype', '0', q_table_fields.recordcount)>
	<cfset QuerySetCell(q_table_fields, 'fielddescription', '', q_table_fields.recordcount)>		
			
	<cfset stReturn.q_select_table_fields = q_table_fields>
	
	<!--- check if the addressbook field exists --->
	<cfquery name="q_select_addressbook_field" dbtype="query">
	SELECT
		fieldname
	FROM
		q_table_fields
	WHERE
		showname = 'addressbookkey'
	;
	</cfquery>
	
	<cfif q_select_addressbook_field.recordcount IS 0>
		<cfexit method="exittemplate">
	</cfif>
	
	<!--- load data --->
	<cfinvoke
		component = "#application.components.cmp_own_db#"   
		method = "GetTableData"   
		returnVariable = "a_struct_tabledata"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#"
		filterfieldname="addressbookkey"
		filtervalue="#ValueList(q_select_contacts.entrykey)#">
	</cfinvoke>
	
	<cfset q_select_crm_data = a_struct_tabledata.origquery />
	
	<cfset a_str_cols = q_select_crm_data.columnList />
	
	<!--- remove internal fields --->
	
	<!---<cfset a_str_cols = ListSetAt(a_str_cols, ListFindNoCase(a_str_cols, 'entrykey'), 'entrykey AS db_entrykey')>--->
	<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, 'entrykey')) />
	<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, 'dt_created')) />
	<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, 'dt_created_int')) />
	<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, 'dt_lastmodified')) />
	<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, 'userentrykey_created')) />
	<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, 'userentrykey_lastmodified')) />
	
	<!--- remote fields containing files ... --->
	<cfquery name="q_table_invalid_fields" dbtype="query">
	SELECT
		fieldname,showname
	FROM
		q_table_fields
	WHERE
		fieldtype IN (6)
	;
	</cfquery>
	
	<cfloop query="q_table_invalid_fields">
		<cfset a_str_cols = ListDeleteAt(a_str_cols, ListFindNoCase(a_str_cols, q_table_invalid_fields.fieldname)) />
	</cfloop>
		
	<!--- now, select all data EXCEPT internal and file fields (see above) --->
	<cfquery name="q_select_crm_data" dbtype="query">
	SELECT
		#a_str_cols#
	FROM
		q_select_crm_data
	;
	</cfquery>
	
	<!--- prepare JOIN ... make sure that for every contact at least a dummy record exists in the crm table --->
	<cfset sEntrykeys_of_contact_query = ValueList(q_select_contacts.entrykey) />
	<cfset sEntrykeys_of_own_database = ArrayToList(q_select_crm_data[q_select_addressbook_field.fieldname]) />
	
	<cfloop list="#sEntrykeys_of_contact_query#" index="a_str_key">
		<cfif ListFindNoCase(sEntrykeys_of_own_database, a_str_key) IS 0>
			<!--- contact has NO crm data, therefore add dummy row ... --->
			<cfset QueryAddRow(q_select_crm_data, 1)>
			<cfset QuerySetCell(q_select_crm_data, q_select_addressbook_field.fieldname, a_str_key, q_select_crm_data.recordcount)>
		</cfif>
	</cfloop>
	

	
	<cftry>
	<cfquery name="q_select_crm_data_new" dbtype="query">
	SELECT
	
		<!--- select the fields if there are in the fieldlist or if we have to load _all_ fields --->
		<cfset a_str_col_list = q_select_contacts.columnlist />
		
		<cfif ListFindNoCase(a_str_col_list, 'language') GT 0>
			<cfset a_str_col_list = ListDeleteAt(a_str_col_list, ListFindNoCase(a_str_col_list, 'language')) />
		</cfif>
		
		<cfloop list="#a_str_col_list#" delimiters="," index="a_str_colname">
		
			<cfset a_str_colname = lcase(a_str_colname) />
		
			<cfif (ListFindNoCase(arguments.fieldlist, a_str_colname) GT 0) OR arguments.loadfulldata>
				q_select_contacts.#a_str_colname#,
			</cfif>
		</cfloop>
		
		<cfloop list="#q_select_crm_data.columnlist#" delimiters="," index="a_str_colname">
		
			<cfset a_str_colname = lcase(a_str_colname) />

			<cfif (ListFindNoCase(arguments.fieldlist, 'db_' & a_str_colname) GT 0) OR arguments.loadfulldata>
				q_select_crm_data.#a_str_colname# AS db_#a_str_colname#,
			</cfif>
			
		</cfloop>
		
		'' AS custodians
	FROM
		 q_select_contacts, q_select_crm_data
	WHERE
		 (q_select_contacts.entrykey = q_select_crm_data.#q_select_addressbook_field.fieldname#)
	;
	</cfquery>	
	
	
	<!---<cfset stReturn.q_select_crm_data = q_select_crm_data>--->
	
	<cfset q_select_contacts = q_select_crm_data_new />
	
	<cfcatch type="any">
	
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_str_sql" type="html">
			<cfdump var="#cfcatch#">
		
			<cfdump var="#q_select_contacts#" label="q_select_contacts">
			<cfdump var="#q_select_crm_data#" label="q_select_crm_data">
			<cfdump var="#arguments#" label="arguments">
		</cfmail>
	</cfcatch>
	</cftry>
	
</cfif>	 --->


