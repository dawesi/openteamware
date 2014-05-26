<!--- //

	Module:		Admintool
	Action:		resources
	Description: 
	
// --->


<cfinclude template="dsp_inc_select_company.cfm">

<h4><cfoutput>#GetLangVal('cm_wd_resources')#</cfoutput></h4>

<cfinvoke component="/components/tools/cmp_resources" method="GetResources" returnvariable="q_select_resources">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfset a_cmp_workgroups = CreateObject('component', request.a_str_component_workgroups)>

<cfsavecontent variable="a_str_content">
<table class="table_overview">
  <tr class="tbl_overview_header">
    <td><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput> (<cfoutput>#GetLangVal('cm_wd_permissions')#</cfoutput>)</td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_resources">
  <tr>
    <td>
		<img src="/images/si/wrench.png" class="si_img" /><b>#htmleditformat(q_select_resources.title)#</b>
	</td>
    <td>
		#htmleditformat(q_select_resources.description)#
	</td>
    <td>
		<ul class="ul_nopoints">
	<cfloop list="#q_select_resources.workgroupkeys#" delimiters="," index="a_str_workgroup_key">
		<li><a href="index.cfm?action=workgroupproperties&entrykey=#a_str_workgroup_key##writeurltags()#"><img src="/images/si/group.png" class="si_img" />#htmleditformat(a_cmp_workgroups.GetWorkgroupNameByEntryKey(a_str_workgroup_key))#</a></li>
	</cfloop>
		</ul>
	</td>
    <td>
	
	<!--- TODO: allow to edit resources ... --->
<!--- 	<a href="index.cfm?action=resource.edit&entrykey=#urlencodedformat(q_select_resources.entrykey)##WriteURLTags()#"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_wd_edit')#</a>
	&nbsp;&nbsp;
 --->	<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="index.cfm?action=action.resource.delete&entrykey=#urlencodedformat(q_select_resources.entrykey)##WriteURLTags()#"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('cm_wd_delete')#</a>
	
	</td>
  </tr>
  </cfoutput>
</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<cfoutput >
		<input type="button" class="btn" value="#GetLangVal('adm_ph_ressources_new')#" onclick="location.href = 'index.cfm?action=resources.new#writeurltags()#'" />
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_resources') & ' (' & q_select_resources.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>


