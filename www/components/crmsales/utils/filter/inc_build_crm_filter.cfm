<!--- //

	Module:		cmp_crmsales
	Function.	BuildCRMFilterStruct
	Description:Build CRM filter structure
	

// --->


<!--- meta data ... workgroup, custodian ... --->
<cfquery name="q_select_filter_criteria_meta" dbtype="query">
SELECT
	*
FROM
	q_select_filter_criteria
WHERE
	area = 0
;
</cfquery>

<!--- own crm fields --->
<cfquery name="q_select_filter_criteria_crm" dbtype="query">
SELECT
	*
FROM
	q_select_filter_criteria
WHERE
	area = 1
;
</cfquery>

<!--- "real" contact data --->
<cfquery name="q_select_filter_criteria_contact" dbtype="query">
SELECT
	*
FROM
	q_select_filter_criteria
WHERE
	area = 2
;
</cfquery>

<!--- loop data --->
<cfoutput query="q_select_filter_criteria_meta">
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow] = StructNew() />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].entrykey = q_select_filter_criteria_meta.entrykey />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].internalfieldname = q_select_filter_criteria_meta.internalfieldname />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].displayname = q_select_filter_criteria_meta.displayname />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].connector = q_select_filter_criteria_meta.connector />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].operator = q_select_filter_criteria_meta.operator />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].comparevalue = q_select_filter_criteria_meta.comparevalue />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].internaldatatype = q_select_filter_criteria_meta.internaldatatype />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].area = 'metadata' />
	<cfset stReturn.metadata[q_select_filter_criteria_meta.currentrow].viewkey = arguments.viewkey />
</cfoutput>

<cfoutput query="q_select_filter_criteria_crm">
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow] = StructNew()>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].entrykey = q_select_filter_criteria_crm.entrykey>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].internalfieldname = q_select_filter_criteria_crm.internalfieldname>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].displayname = q_select_filter_criteria_crm.displayname>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].connector = q_select_filter_criteria_crm.connector>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].operator = q_select_filter_criteria_crm.operator>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].comparevalue = q_select_filter_criteria_crm.comparevalue>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].internaldatatype = q_select_filter_criteria_crm.internaldatatype>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].area = 'crm'>
	<cfset stReturn.crm[q_select_filter_criteria_crm.currentrow].viewkey = arguments.viewkey>
</cfoutput>		

<cfoutput query="q_select_filter_criteria_contact">
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow] = StructNew()>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].entrykey = q_select_filter_criteria_contact.entrykey>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].internalfieldname = q_select_filter_criteria_contact.internalfieldname>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].displayname = q_select_filter_criteria_contact.displayname>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].connector = q_select_filter_criteria_contact.connector>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].operator = q_select_filter_criteria_contact.operator>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].comparevalue = q_select_filter_criteria_contact.comparevalue>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].internaldatatype = q_select_filter_criteria_contact.internaldatatype>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].area = 'contact'>
	<cfset stReturn.contact[q_select_filter_criteria_contact.currentrow].viewkey = arguments.viewkey>
</cfoutput>			

<cfif arguments.mergecriterias>
	<!--- merge criterias ... --->
	
	<cfloop from="1" to="#ArrayLen(stReturn.metadata)#" index="ii">
		<cfset ArrayAppend(stReturn.criterias, stReturn.metadata[ii]) />
	</cfloop>
	
	<cfloop from="1" to="#ArrayLen(stReturn.crm)#" index="ii">
		<cfset ArrayAppend(stReturn.criterias, stReturn.crm[ii]) />
	</cfloop>
	
	<cfloop from="1" to="#ArrayLen(stReturn.contact)#" index="ii">
		<cfset ArrayAppend(stReturn.criterias, stReturn.contact[ii]) />
	</cfloop>			
</cfif>


