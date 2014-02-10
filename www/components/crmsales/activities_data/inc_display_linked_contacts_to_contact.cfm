<!--- //

	Module:		CRMSales
	Function:	GetItemActivitiesAndData
	Description:Display links between contacts
	

// --->

<cfinvoke component="#application.components.cmp_tools#" method="GetElementLinksFromTo" returnvariable="q_select_links">
	<cfinvokeargument name="entrykey" value="#arguments.contactkeys#">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
</cfinvoke>

<cfset stReturn.recordcount = q_select_links.recordcount />

<cfif q_select_links.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfsavecontent variable="sReturn">
<table class="table_overview" cellspacing="0">
	<cfoutput>
	  <tr class="tbl_overview_header">
		<td width="50%">
			#GetLangVal('cm_wd_type')#
		</td>
		<td width="50%">
			#GetLangVal('cm_wd_contact')#/#GetLangVal('cm_wd_comment')#
		</td>
	  </tr>
	  </cfoutput>
	  
	  <cfoutput query="q_select_links">
	  <tr>
	  	<td>
			<cfif q_select_links.source_entrykey NEQ arguments.contactkeys>
				<a href="default.cfm?action=ShowItem&entrykey=#q_select_links.source_entrykey#">#htmleditformat(q_select_links.source_name)#</a>
			</cfif>

			#htmleditformat(q_select_links.connection_type)#
		</td>
		<td>
			<a href="default.cfm?action=ShowItem&entrykey=#q_select_links.dest_entrykey#">#htmleditformat(q_select_links.dest_name)#</a>

			<cfif Len(q_select_links.comment) GT 0>
				(#htmleditformat(q_select_links.comment)#)
			</cfif>
		</td>
	  </tr> 
	  </cfoutput> 
	  </table>
	  
</cfsavecontent>

<cfset stReturn.a_str_content = sReturn />

