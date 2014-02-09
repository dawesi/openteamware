<!--- //

	select avaliable product groups ...
	
	// --->

<cfquery name="q_select_product_groups" datasource="#request.a_str_db_users#">
SELECT entrykey,groupname FROM productgroups
ORDER BY displayindex;
</cfquery>