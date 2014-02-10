<!--- //

	Module:        Tools
	Description:   Return database fields of a certain service. Can include own database fields
	

// --->

<cfswitch expression="#arguments.servicekey#">

	<cfcase value="52227624-9DAA-05E9-0892A27198268072">
		<!--- address book --->
		<!--- datatype: 0 = varchar; 1 = datetime; 2 = text --->
		
		<cfset a_str_business_data = ' (' & GetLangVal('adrb_ph_business_data') & ')' />
		<cfset a_str_private_data = ' (' & GetLangVal('adrb_ph_private_data') & ')' />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'sex', GetLangVal('adrb_wd_sex'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'firstname', GetLangVal('adrb_wd_firstname'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'surname', GetLangVal('adrb_wd_surname'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'company', GetLangVal('adrb_wd_company'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'department', GetLangVal('adrb_wd_department'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'position', GetLangVal('adrb_wd_position'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'title', GetLangVal('adrb_wd_title'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'email_prim', GetLangVal('adrb_ph_email_prim'), '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'birthday', GetLangVal('adrb_wd_birthday'), '', 1) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'categories', GetLangVal('adrb_wd_categories'), '', 0, 255) />
		<!---<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'lastemailcontact', 'Last email contact', '', 1)>
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'dt_created', 'Date created', '', 1)>--->
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_street', GetLangVal('adrb_wd_street') & a_str_business_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_zipcode', GetLangVal('adrb_wd_zipcode') & a_str_business_data, '', 0, 50) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_city', GetLangVal('adrb_wd_city') & a_str_business_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_telephone', GetLangVal('adrb_wd_telephone') & a_str_business_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_telephone_2', GetLangVal('adrb_wd_telephone') & a_str_business_data & ' 2', '', 0, 255) />		
		
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_fax', GetLangVal('adrb_wd_fax') & a_str_business_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_country', GetLangVal('adrb_wd_country') & a_str_business_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_mobile', GetLangVal('cm_wd_mobile') & a_str_business_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_url', GetLangVal('cm_wd_homepage') & a_str_business_data, '', 0, 255) />
		<!---<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'b_iptelephone', 'Business IP telephone', '', 0, 255)>--->
		
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'email_adr', GetLangVal('adrb_ph_email_further'), '', 3, 65535) />
		
		
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_city', GetLangVal('adrb_wd_city') & a_str_private_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_street', GetLangVal('adrb_wd_street') & a_str_private_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_zipcode', GetLangVal('adrb_wd_zipcode') & a_str_private_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_country', GetLangVal('adrb_wd_country') & a_str_private_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_telephone', GetLangVal('adrb_wd_telephone') & a_str_private_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_fax', GetLangVal('adrb_wd_fax') & a_str_private_data, '', 0, 255) />
		<!--- <cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_iptelephone', 'Private iptelephone', '', 0, 255)> --->
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'p_mobile', GetLangVal('cm_wd_mobile') & a_str_private_data, '', 0, 255) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'notice', GetLangVal('adrb_wd_notices'), '', 0, 65000) />
		<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, 'nace_code', GetLangVal('crm_ph_nace_code'), '', 0, 255) />
		
		<!--- load custom fields? ... --->
			
			<cfset a_struct_crmsales_bindings = application.components.cmp_crmsales.GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey) />

			<!--- <cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
			
				<cfset q_select_own_db_fields = application.components.cmp_own_db.GetTableFields(securitycontext = arguments.securitycontext,
								usersettings = arguments.usersettings,
								table_entrykey = a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) />
								
				<!--- add own fields ... --->
				<cfloop query="q_select_own_db_fields">
					<cfset q_select_fields = AddDatabaseFieldsInformationRecord(q_select_fields, q_select_own_db_fields.fieldname, q_select_own_db_fields.showname, '', 0, 255) />
				</cfloop>
				
			</cfif> --->

	</cfcase>

</cfswitch>


