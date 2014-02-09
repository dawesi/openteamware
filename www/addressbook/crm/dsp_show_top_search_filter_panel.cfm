<!--- //

	Module:		Address Book
	Description:ShowAdvancedSearchFilterPanel
	
// --->

	
<cfparam name="url.resetallunsavedcriterias" type="boolean" default="true">
<cfparam name="url.filterviewkey" type="string" default="">
<cfparam name="url.filterdatatype" type="numeric" default="0">

<cfset url.entrykey = url.filterviewkey>

<!--- ... --->
<div style="overflow:auto;height:400px;">
	<cfinclude template="dsp_inc_advanced_search_criteria_table.cfm">
</div>