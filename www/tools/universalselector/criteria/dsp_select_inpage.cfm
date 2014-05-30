<!--- //

	Module:		UniversalSelector
	Description:Select attributes ...
	

// --->

<cfset a_str_id = 'id_' & CreateUUIDJS() />

<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCriteriaTree" returnvariable="sReturn">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="options" value="allowedit">
	<cfinvokeargument name="selected_ids" value="#url.inputvalue#">
	<cfinvokeargument name="form_input_name" value="frm_criteria_ids">
	<cfinvokeargument name="tree_id" value="#a_str_id#">
</cfinvoke>

<cfset a_str_form_id = 'form_' & a_str_id />

<cfoutput>
<form name="#a_str_form_id#" id="#a_str_form_id#" class="frm_inpage" action="##" onsubmit="UniversalSelectorSetReturnValues(CollectCheckedSelectBoxesValues('#a_str_id#'),UniversalSelectorGetDisplayValuesOfCheckedElements('#a_str_id#', 'frm_attr_name_'));return false;">
</cfoutput>

<div class="div_form_btn_area">
	<input type="submit" value="<cfoutput>#GetLangVal('cm_ph_btn_action_apply')#</cfoutput>" class="btn btn-primary" />
</div>
<cfoutput>#sReturn#</cfoutput>

</form>

<cfsavecontent variable="a_str_js">
$("#<cfoutput>#a_str_id#</cfoutput>").Treeview();
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />

