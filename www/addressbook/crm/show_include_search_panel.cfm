<!--- //

	2do: delete all criterias without saved settings ...
	
	// --->
	
<cfinclude template="/common/scripts/script_utils.cfm">
	
<cfparam name="url.resetallunsavedcriterias" type="boolean" default="true">
<cfparam name="url.filterviewkey" type="string" default="">

<cfset url.entrykey = url.filterviewkey>

<!--- ... --->
<div style="overflow:auto;height:400px;">
	<cfinclude template="dsp_inc_advanced_search_criteria_table.cfm">
</div>

