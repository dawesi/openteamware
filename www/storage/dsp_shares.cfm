<!--- //

	Module:		Storage
	Action:		Shares
	Description: 
	

	
	
	display list of shares ...
	
// --->
	
<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_sharedfiles')) />


<cfquery name="q_select_public_shares" datasource="#request.a_str_db_tools#">
SELECT
	publicshares.type,
	publicshares.password,
	publicshares.directorykey,
	directories.directoryname
FROM
	publicshares
LEFT JOIN directories ON (directories.entrykey = publicshares.directorykey)
WHERE
	publicshares.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>
<cfsavecontent variable="a_str_content">

<table class="table_overview">
  <tr class="tbl_overview_header">
    <td>&nbsp;</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('sto_ph_password_protected')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select_public_shares">
  <tr>
    <td>
		<img src="/images/si/folder_user.png" class="si_img" />
	</td>
    <td>
		<a href="default.cfm?action=showfiles&directorykey=#q_select_public_shares.directorykey#">#htmleditformat(q_select_public_shares.directoryname)#</a>
	</td>
    <td>
		<cfif Len(q_select_public_shares.password) GT 0>
			#GetLangVal('cm_wd_yes')#
		<cfelse>
			#GetLangVal('cm_wd_no')#
		</cfif>
	</td>
    <td>
		<a href="default.cfm?action=editfolder&entrykey=#q_select_public_shares.directorykey#&currentdir="><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_wd_edit')#</a>
	</td>
  </tr>
  </cfoutput>
</table>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('sto_ph_publicfiles') & ' (' & q_select_public_shares.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>

<br />

<cfquery name="q_select_workgroup_shares" datasource="#request.a_str_db_tools#">
SELECT
	directories.directoryname,
	directories_shareddata.directorykey,
	directories_shareddata.workgroupkey
FROM
	directories
RIGHT JOIN directories_shareddata ON (directories.entrykey = directories_shareddata.directorykey)
WHERE
	directories.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

 <cfsavecontent variable="a_str_content">
	
  <table class="table_overview">
  <tr class="tbl_overview_header">
	<td></td>
    <td><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select_workgroup_shares">
  <tr>
    <td>
	<img src="/images/si/folder_user.png" class="si_img" />
	</td>
    <td>
		<a href="default.cfm?action=showfiles&directorykey=#q_select_workgroup_shares.directorykey#">#htmleditformat(q_select_workgroup_shares.directoryname)#</a>
	</td>
    <td>
		<cfif StructKeyExists(request.stSecurityContext.A_STRUCT_WORKGROUPS, q_select_workgroup_shares.workgroupkey)>
			<a href="/workgroups/">#request.stSecurityContext.A_STRUCT_WORKGROUPS[q_select_workgroup_shares.workgroupkey]#</a>
		</cfif>
	</td>
    <td>
		<a href="default.cfm?action=editfolder&entrykey=#q_select_workgroup_shares.directorykey#&currentdir="><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_wd_edit')#</a>
	</td>
  </tr>
  </cfoutput>
</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('sto_ph_workgroup_shared_dirs'), a_str_buttons, a_str_content)#</cfoutput>

