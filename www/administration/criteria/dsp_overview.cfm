<!--- //

	Module:		admintool
	Action:		criteria
	Description:display existing criteria
	
// --->

<cfset a_str_id = 'id_' & CreateUUIDJS() />

<cfsavecontent variable="a_str_content">
<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCriteriaTree" returnvariable="sReturn">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="options" value="allow_add_admin_tool">
	<cfinvokeargument name="url_tags_to_add" value="#WriteURLTags()#">
	<cfinvokeargument name="tree_id" value="#a_str_id#">
</cfinvoke>

<cfoutput>#sReturn#</cfoutput>


<div style="padding:10px;">
<img src="/images/si/add.png" class="si_img" /> = <cfoutput>#GetLangVal('adm_wd_add')#</cfoutput>
<img src="/images/si/delete.png" class="si_img" /> = <cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput>
</div>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<cfoutput >
	<input type="button" value="#GetLangVal('adm_ph_add_new_top_level_criteria')#" onclick="GotoLocHref('index.cfm?action=criteria&subaction=AddCriteria#WriteUrlTags()#');" class="btn" />
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('adrb_ph_contact_data'), a_str_buttons, a_str_content)#</cfoutput>


