<!--- //

	select avaliable product groups ...
	
	// --->

<cfquery name="q_select_product_groups">
SELECT entrykey,groupname FROM productgroups
ORDER BY displayindex;
</cfquery>