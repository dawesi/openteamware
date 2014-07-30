<!--- //



	select the sub resellers ...

	

	// --->

	

<cfquery name="q_select_reseller">
SELECT
	companyname,entrykey,delegaterights,parentkey,domains,emailadr,
	isdistributor,issystempartner,isprojectpartner,contractingparty,
	default_settlement_type,allow_modify_settlement_type
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_reseller_entry_key#">
;
</cfquery>



<cfset a_arr_tmp = ArrayNew(1)>

<cfset a_arr_tmp[1] = 0>



<cfset QueryAddColumn(q_select_reseller, "resellerlevel", a_arr_tmp)>

<cfset QuerySetCell(q_select_reseller, "delegaterights", 0, 1)>