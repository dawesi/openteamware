<!--- //



	add virtual query

	

	// --->

	

<cfparam name="AddSelectQuery.Query" type="query">

<cfparam name="AddSelectQuery.level" type="numeric" default="1">

<cfparam name="AddSelectQuery.delegaterights" type="numeric" default="0">



<cfif AddSelectQuery.Query.recordcount is 0>

	<cfexit method="exittemplate">

</cfif>



<cfset ii = q_select_reseller.recordcount>



<cfset tmp = QueryAddRow(q_select_reseller, 1)>



<cfset ii = q_select_reseller.recordcount>



<cfif request.a_str_reseller_entry_key is '5872C37B-DC97-6EA3-E84EC482D29FC169'>

	<!--- main admin --- god --->

	<cfset AddSelectQuery.delegaterights = 1>

</cfif>





<cfset tmp = QuerySetCell(q_select_reseller, "companyname", AddSelectQuery.Query.companyname, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "entrykey", AddSelectQuery.Query.entrykey, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "parentkey", AddSelectQuery.Query.parentkey, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "delegaterights", AddSelectQuery.delegaterights, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "resellerlevel", AddSelectQuery.level, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "domains", AddSelectQuery.query.domains, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "emailadr", AddSelectQuery.query.emailadr, ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "isdistributor", val(AddSelectQuery.query.isdistributor), ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "isprojectpartner", val(AddSelectQuery.query.isprojectpartner), ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "issystempartner", val(AddSelectQuery.query.issystempartner), ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "contractingparty", val(AddSelectQuery.query.contractingparty), ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "default_settlement_type", val(AddSelectQuery.query.default_settlement_type), ii)>

<cfset tmp = QuerySetCell(q_select_reseller, "allow_modify_settlement_type", val(AddSelectQuery.query.allow_modify_settlement_type), ii)>