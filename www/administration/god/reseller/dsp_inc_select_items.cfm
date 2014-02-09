<cfparam name="attributes.entrykey" type="string" default="">
<cfparam name="attributes.level" type="numeric" default="0">

<cfquery name="q_select_items" dbtype="query">
SELECT
	*
FROM
	request.q_select_reseller
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrykey#">
;
</cfquery>


<div style="padding-left:<cfoutput>#(attributes.level*20)#</cfoutput>px;">
<cfloop query="q_select_items">
	<cfoutput>
	<h4 style="margin-bottom:3px;">#q_select_items.companyname#
	
	<cfif q_select_items.contractingparty IS 1>
		<font color="green">[VP]</font>
	</cfif>
	(
	<cfif q_select_items.isdistributor IS 1>
		Distributor
	</cfif>
	<cfif q_select_items.issystempartner IS 1>
		Systempartner
	</cfif>	
	<cfif q_select_items.isprojectpartner IS 1>
		Projektpartner
	</cfif>		
	)
	
	 <a href="default.cfm?action=editreseller&entrykey=#urlencodedformat(q_select_items.entrykey)#">Eigenschaften</a>
	 &nbsp;
	 <a href="default.cfm?action=resellerusers&resellerkey=#urlencodedformat(q_select_items.entrykey)#">User</a>
	 &nbsp;
	 <a href="default.cfm?action=deletereseller&entrykey=#urlencodedformat(q_select_items.entrykey)#">delete</a>
	 </h4>

	#q_select_items.zipcode# #q_select_items.city#<br>
	#q_select_items.street# #q_select_items.telephone# #q_select_items.emailadr#
	
	<cfif q_select_items.partnertype IS 0>
	<br>#ucase(q_select_items.country)# PLZ #q_select_items.assignedzipcodes#
	</cfif>
	</cfoutput>
	<cfmodule template="dsp_inc_select_items.cfm" entrykey=#q_select_items.entrykey# level=#(attributes.level+1)#>
</cfloop>
</div>