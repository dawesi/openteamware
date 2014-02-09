<div style="padding:8px;" align="center">
<input class="btn" type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
</div>
<cfoutput>#GetLangVal('cm_ph_workgroups_share_select_groups_description')#</cfoutput>
<br><br>

<input type="hidden" name="frm_all_workgroup_keys" value="<cfoutput>#htmleditformat(ValueList(q_select_workgroups.workgroup_key))#</cfoutput>">

<div style="line-height:20px;">
<cfoutput query="q_select_workgroups">

<cfloop from="1" to="#q_select_workgroups.workgrouplevel#" index="ii">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>

<!---<a href="?action=addworkgroup&workgroupkey=#urlencodedformat(q_select_workgroups.workgroup_key)#">Gruppe --->

<cfif ListFindNoCase(q_select_workgroups.permissions, 'write') GT 0>

	<!--- check if managepermissions is true ... --->
	<input type="checkbox" <cfif ListFindNoCase(ValueList(q_select_shares.workgroupkey),q_select_workgroups.workgroup_key) gt 0>checked</cfif>  name="frmcbworkgroups" value="#htmleditformat(q_select_workgroups.workgroup_key)#" class="noborder"><b>#htmleditformat(q_select_workgroups.workgroup_name)#</b><!---hinzuf&uuml;gen ...</a>---><br>
</cfif>

</cfoutput>
</div>

<div style="padding:4px;" align="center" class="bt">
<input class="btn" type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
</div>

<!---<cfdump var="#q_select_workgroups#">--->