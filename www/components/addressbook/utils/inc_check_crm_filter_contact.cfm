<!--- //

	Module:		Address Book
	Function:	GetAllContacts
	Description:Select all contacts
	
				Apply CRM filters in the contact item scope ...
				
	

// --->

<cfoutput>
AND
	(
	
	<cfloop from="1" to="#ArrayLen(arguments.crmfilter.contact)#" index="ii">
		
		<cfset a_struct_contact_filter = arguments.crmfilter.contact[ii] />
		
		<!--- is it a filter with list values, do we have to use an IN clause? --->
		<cfset a_bol_cfqueryparam_list = false />
		<cfset a_str_start_in_clause = '' />
		<cfset a_str_end_in_clause = '' />	
		
		<!--- check operator and so on ... --->
		
		<!--- trim compare value --->
		<cfset a_str_compare_value = Trim(a_struct_contact_filter.comparevalue) />
		
		<!--- 4 = contains ... add % before and at end of compare value ... --->
		<cfif arguments.crmfilter.contact[ii].operator IS 4>
			<!--- LIKE ... add % --->
			<cfset a_str_compare_value = '%' & a_str_compare_value & '%' />
		</cfif>
		
		<!--- begins with ... add % at the end of string ... --->
		<cfif arguments.crmfilter.contact[ii].operator IS 5>
			<!--- beginning with ... use LIKE ... add % at the end --->
			<cfset a_str_compare_value = a_str_compare_value & '%' />
		</cfif>		
				
		<!--- date/time ... and not yet converted to {ts default format --->
		<cfif (arguments.crmfilter.contact[ii].internaldatatype IS 3)>
			
			<cfset a_str_compare_value = lcase(a_str_compare_value) />
			
			<cfif FindNoCase('{ts', a_str_compare_value) IS 0>
				<cfset a_str_compare_value = CreateODBCDateTime(a_str_compare_value) />		
			</cfif>
			
		</cfif>		
		
		<!--- if IN, use list = true --->
		<cfset a_bol_cfqueryparam_list = (arguments.crmfilter.contact[ii].operator IS 6) OR
										 (arguments.crmfilter.contact[ii].operator IS -6) />
		
		<!--- if IN, use () in front of and at the end of the compare value --->
		<cfif a_bol_cfqueryparam_list>
			<cfset a_str_start_in_clause = '(' />
			<cfset a_str_end_in_clause = ')' />
		</cfif>
		
		<!--- go through the possible operators now ... --->
		<cfswitch expression="#arguments.crmfilter.contact[ii].operator#">
			<cfcase value="5">
				
				<!--- beware of NULL --->
				NOT (addressbook.#a_struct_contact_filter.internalfieldname# IS NULL)
				
			</cfcase>
			<cfcase value="6">
				
				<!--- IN comparison only ... quite difficult to handle ... --->
				(LENGTH(addressbook.#a_struct_contact_filter.internalfieldname#) > 0)
			
				AND
			
				(
					<!--- important ... use all possible ways ... single, at the end, in the middle ... and so on --->
					<cfloop list="#a_str_compare_value#" index="a_str_single_multiselect_item" delimiters=",">
					(addressbook.#a_struct_contact_filter.internalfieldname# = <cfqueryparam value="#a_str_single_multiselect_item#" cfsqltype="#GetCFDataTypeFromInternalType(arguments.crmfilter.contact[ii].internaldatatype)#">)
					OR
					(addressbook.#a_struct_contact_filter.internalfieldname# LIKE <cfqueryparam value="#a_str_single_multiselect_item#,%" cfsqltype="#GetCFDataTypeFromInternalType(arguments.crmfilter.contact[ii].internaldatatype)#">)
					OR
					(addressbook.#a_struct_contact_filter.internalfieldname# LIKE <cfqueryparam value="%,#a_str_single_multiselect_item#" cfsqltype="#GetCFDataTypeFromInternalType(arguments.crmfilter.contact[ii].internaldatatype)#">)							
					OR
					(addressbook.#a_struct_contact_filter.internalfieldname# LIKE <cfqueryparam value="%,#a_str_single_multiselect_item#,%" cfsqltype="#GetCFDataTypeFromInternalType(arguments.crmfilter.contact[ii].internaldatatype)#">)							
					OR				
					</cfloop>
				
					(1 = 0)
				)			
			</cfcase>
			<cfcase value="7">
				<!--- strict list (IN) --->
				(addressbook.#a_struct_contact_filter.internalfieldname# IN (<cfqueryparam value="#arguments.crmfilter.contact[ii].comparevalue#" cfsqltype="#GetCFDataTypeFromInternalType(arguments.crmfilter.contact[ii].internaldatatype)#" list="true">))
			</cfcase>
			<cfdefaultcase>
				<!---
				
					default method ...
					
					take internal field
					find right SQL operator
					open IN clause if necessary
					add cfqueryparam tag
					
				 --->
				(addressbook.#a_struct_contact_filter.internalfieldname# #GetSQLOperatorFromInternalOperatorNumber(arguments.crmfilter.contact[ii].operator)# #a_str_start_in_clause#<cfqueryparam cfsqltype="#GetCFDataTypeFromInternalType(arguments.crmfilter.contact[ii].internaldatatype)#" value="#a_str_compare_value#" list="#a_bol_cfqueryparam_list#">#a_str_end_in_clause#)
			</cfdefaultcase>			
		</cfswitch>
	
		<!--- goto next ... use OR or AND --->
		<cfif ii NEQ ArrayLen(arguments.crmfilter.contact)>
			
			#ReturnSQLConnectorStringByNumber(a_struct_contact_filter.connector)#	
			
		</cfif>
		
	</cfloop>
	
	)
</cfoutput>

<!--- result is filtered ... therefore set this property --->
<cfif ArrayLen(arguments.crmfilter.contact) GT 0>
	<cfset a_bol_filtered = true />
</cfif>

