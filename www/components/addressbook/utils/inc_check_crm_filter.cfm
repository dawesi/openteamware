<!--- //

	Module:	Address Book
	Function: GetAllContacts
	Description: Check given CRM filters ...
	

	
	
	we have to return which entrykeys should be used in our query! 
	
	The user says for example, return all contacts where a followup for mr john doe has been set ... such filters
	are handled in here
	
// --->


<!--- hold all entrykeys that are received by checking followups ... needed for later filtering ... 

	that way we do not have to apply all filters again when outputting a report
	
	IMPORTANT: this variable holds the ENTRYKEYS of the followup jobs NOT the entryky of the object !!!!!
	
--->

<cfset a_str_crm_filter_entrykeys_followups = '' />
<cfset a_str_crm_filter_entrykeys_assignedto = '' />
<cfset a_str_crm_filter_entrykeys_database = '' />

<!--- structure holding the entrykeys of the followup jobs and the number of occurances ... --->
<cfset a_struct_crm_filter_entrykeys_followups = StructNew() />

<!--- number of queries against the followup items ... --->
<cfset a_int_crm_filter_followup_checks = 0 />

<!--- do any filters apply?? --->
<cfset a_bol_any_crm_filter_applied = false />
	
<!--- //

	Apply filters where the elements are stored in external tables, e.g. followup jobs 
	
	// --->
<cfif StructKeyExists(arguments.crmfilter, 'metadata') AND (ArrayLen(arguments.crmfilter.metadata) GT 0)>
	<!--- filtering meta data --->
	
	<cfset a_bol_any_crm_filter_applied = true />

	<!--- loop through the array --->
	
	<cfloop from="1" to="#ArrayLen(arguments.crmfilter.metadata)#" index="ii">
		
		<cfset a_struct_filter_element = arguments.crmfilter.metadata[ii]>
		
		<!--- elements: datatype and parameter1, parameter2, comparemethod --->
		<cfswitch expression="#a_struct_filter_element.internalfieldname#">
			
			<cfcase value="followup_userkey,followup_type,followup_status,followup_dt_due">
				
				<!--- followup elements ... --->
				<cfinclude template="queries/q_select_follow_ups_items.cfm">
				
				<cfif ListLen(a_str_crm_filter_entrykeys) IS 0>
					<cfset a_str_crm_filter_entrykeys = valuelist(q_select_follow_ups_items.objectkey) />
				<cfelse>
					<cfset a_str_crm_filter_entrykeys = ListSameItems(a_str_crm_filter_entrykeys, valuelist(q_select_follow_ups_items.objectkey)) />
				</cfif>
			</cfcase>
			
			<cfcase value="custodian">
				
				<!--- parameter1 = userkey --->
				<cfinclude template="queries/q_select_assigned_items.cfm">
				
				<cfif ListLen(a_str_crm_filter_entrykeys) IS 0>
					<cfset a_str_crm_filter_entrykeys = valuelist(q_select_assigned_items.objectkey) />
				<cfelse>
					<cfset a_str_crm_filter_entrykeys = ListSameItems(a_str_crm_filter_entrykeys, valuelist(q_select_assigned_items.objectkey)) />
				</cfif>				
				
			</cfcase>
			
			<cfcase value="workgroup">
				
				<!--- select the contactkeys assignd to the certain workgroup ... --->
				<cfinclude template="queries/q_select_workgroup_items.cfm">
				
				<cfif ListLen(a_str_crm_filter_entrykeys) IS 0>
					<cfset a_str_crm_filter_entrykeys = valuelist(q_select_workgroup_items.addressbookkey) />
				<cfelse>
					<cfset a_str_crm_filter_entrykeys = ListSameItems(a_str_crm_filter_entrykeys, valuelist(q_select_workgroup_items.addressbookkey)) />
				</cfif>	
				
			
			</cfcase>
			<cfcase value="criteria">
			
				<cfset sEntrykeys_criteria = application.components.cmp_crmsales.ReturnObjectEntrykeysForCriteriaID(servicekey = '52227624-9DAA-05E9-0892A27198268072',
											criteria_ids = a_struct_filter_element.comparevalue) />
		
				<cfif ListLen(sEntrykeys_criteria) IS 0>
					<cfset 'thisitemdoesnotexist' />
				</cfif>
				
				<cfif a_struct_filter_element.operator IS 6>
					
					<!--- IS IN ... set the entrykeys to the list of returned entrykeys --->					
					<cfset a_str_crm_filter_entrykeys = sEntrykeys_criteria />
					
				<cfelse>
					<!--- IS NOT ... --->
					
					
					<!--- TODO hp: FINISH ... --->
					<cfset arguments.crmfilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = arguments.crmfilter,
								area = 2,
								connector = 0,
								operator = -6,
								internalfieldname = 'entrykey',
								comparevalue = sEntrykeys_criteria,
								internaldatatype = 0) />
					
				</cfif>
			
			</cfcase>
		</cfswitch>
		
	</cfloop>

</cfif>

<!--- //

	apply filters stored in the own database ...
	
	// --->
<!--- <cfif StructKeyExists(arguments.crmfilter, 'crm') AND (ArrayLen(arguments.crmfilter.crm) GT 0)>
	<!--- crm/own database data --->
	<cfset a_bol_any_crm_filter_applied = true />

	<cfinclude template="inc_check_crm_filter_database.cfm">
	
	<cfif ListLen(a_str_crm_filter_entrykeys_database) IS 0>
		<cfset a_str_crm_filter_entrykeys_database = 'nohitduringdatabasesearch' />
	</cfif>
	
	<cfif ListLen(a_str_crm_filter_entrykeys_database) GT 0>
		<!---<cfset a_str_crm_filter_entrykeys = a_str_crm_filter_entrykeys_database>
	<cfelse>--->
		<cfset a_str_crm_filter_entrykeys = a_str_crm_filter_entrykeys & ',' & a_str_crm_filter_entrykeys_database />
	</cfif>	

</cfif> --->

<!--- //

	apply filters to contacts ... NOT HERE ...
	
	// --->
<cfif StructKeyExists(arguments.crmfilter, 'contact') AND (ArrayLen(arguments.crmfilter.contact) GT 0)>
	<!--- contact data ... these filters are handled in the real address book query --->
</cfif>

<!--- here the wrong items are set ... --->

<cfif a_bol_any_crm_filter_applied>
	<cfset arguments.filter.entrykeys = a_str_crm_filter_entrykeys />
</cfif>

<!--- return the entrykeys of the followup items ... --->
<cfset a_str_crm_filter_entrykeys_followups = '' />

<!--- go through list and check the items with the maximum number of occurencies .. only these items are the right
	items because they exist in EVERY followup items query ... --->
<cfloop list="#StructKeyList(a_struct_crm_filter_entrykeys_followups)#" index="a_str_key">
	<cfif Compare(a_struct_crm_filter_entrykeys_followups[a_str_key], a_int_crm_filter_followup_checks) IS 0>
		<cfset a_str_crm_filter_entrykeys_followups = ListAppend(a_str_crm_filter_entrykeys_followups, a_str_key) />
	</cfif>
</cfloop>

<cfset stReturn.crm_filter_returned_meta_data.entrykeys_followup_items = a_str_crm_filter_entrykeys_followups />

