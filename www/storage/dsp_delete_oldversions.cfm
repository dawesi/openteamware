<cfparam name="url.frm_entrykey" type="string">
<cfparam name="url.frm_parentdirectorykey" type="string">
<cfset sFilenames="">

<cfloop index="sEntrykey" list="#url.frm_entrykey#" >
	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetFileInformation"   
		returnVariable = "a_struct_file_info"   
		entrykey = "#sEntrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		 >
	</cfinvoke>	
	
	
<cfset q_query_file = a_struct_file_info.q_select_file_info />
		 
	<cfset sFilenames=sFilenames & q_query_file.filename & ", ">
</cfloop>

<cfset sFilenames=Left(sFilenames,len(sFilenames)-2)>

<table width="100%" border="0" cellspacing="0" cellpadding="2" class="bb">
	<tr>
		<td>
			<font class="PageBanner"><cfoutput>#getlangval('sto_ph_deleteversions')#</cfoutput></font>
		</td>
		<td align="right">
			&nbsp;
		</td>
	</tr>
</table>
<br>


<cfoutput>
	<b>
		#replace(getlangval('sto_ph_reallydeleteversions'),"%filename%",sFilenames)#
	</b>
	<br>
	<br>
	<a href="default.cfm?action=delete_oldversions&entrykey=#urlencodedformat(url.frm_entrykey)#&confirmed=1&redirectdir=0&parentdirectorykey=#url.frm_parentdirectorykey#">#getlangval('sto_ph_reallydelete')#</a>
	<br>
	<br>
	<a href="default.cfm?action=ShowFiles&directorykey=#url.frm_parentdirectorykey#">#getlangval('sto_ph_noabort')#</a>
</cfoutput>





