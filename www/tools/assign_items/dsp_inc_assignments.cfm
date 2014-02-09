<cfparam name="attributes.servicekey" type="string" default="">
<cfparam name="attributes.objectkey" type="string" default="">
<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.editright" type="boolean" default="true">

<cfinclude template="/common/app/app_global.cfm">

<cfinvoke component="#request.a_str_component_assigned_items#" method="GetAssignments" returnvariable="q_select_assignments">
	<cfinvokeargument name="servicekey" value="#attributes.servicekey#">
	<cfinvokeargument name="objectkeys" value="#attributes.objectkey#">
</cfinvoke>

<cfset a_str_assigned_foreign_users = ValueList(q_select_assignments.userkey)>

<div style="padding-left:0px; ">
<cfif q_select_assignments.recordcount IS 0>
	<font class="addinfotext">Keine Zuordnungen vorhanden</font>
	<cfif attributes.editright>
		<br><br>
		<a href="javascript:OpenAssignWindow('<cfoutput>#jsstringformat(attributes.servicekey)#</cfoutput>', '<cfoutput>#jsstringformat(attributes.objectkey)#</cfoutput>', '<cfoutput>#jsstringformat(attributes.title)#</cfoutput>');"><cfoutput>#GetLangVal('crm_ph_edit_assignment')#</cfoutput></a>
	</cfif>
<cfelse>
	<cfset variables.a_cmp_show_username = application.components.cmp_user>
		
	<table width="100%"  border="0" cellspacing="0" cellpadding="4">
	  <cfoutput query="q_select_assignments">
	  <tr>
		<td nowrap>
			 #variables.a_cmp_show_username.GetUsernamebyentrykey(q_select_assignments.userkey)#
			<cfif Len(q_select_assignments.comment) GT 0>
				<br>
				<span class="addinfotext">#htmleditformat(q_select_assignments.comment)#</span>
			</cfif>
		</td>
	  </tr>
	  </cfoutput>
	</table>
	
	<cfif attributes.editright>
		<a href="javascript:OpenAssignWindow('<cfoutput>#jsstringformat(attributes.servicekey)#</cfoutput>', '<cfoutput>#jsstringformat(attributes.objectkey)#</cfoutput>', '<cfoutput>#jsstringformat(attributes.title)#</cfoutput>');"><!---<img src="/images/img_person_small.gif" align="absmiddle" border="0" vspace="2" hspace="2"> ---><cfoutput>#GetLangVal('crm_ph_edit_assignment')#</cfoutput></a>
	</cfif>	
</cfif>

</div>