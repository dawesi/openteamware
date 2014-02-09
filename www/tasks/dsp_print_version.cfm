<cfparam name="url.entrykeys" type="string" default="">
<h2>Aufgaben</h2>
<table width="4" border="0" cellspacing="0" cellpadding="6" width="100%">
<cfloop list="#url.entrykeys#" index="sEntrykey">
	<cfinvoke component="#application.components.cmp_tasks#" method="GetTask" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="entrykey" value="#sEntrykey#">
	</cfinvoke>
	
	<cfset q_select_task = stReturn.q_select_task>
	
	<tr>
		<td colspan="2" class="mischeader bb">Aufgabe <b><cfoutput>#htmleditformat(q_select_task.title)#</cfoutput></b></td>
	</tr>

	
	
	<cfinclude template="dsp_inc_display_task.cfm">
</cfloop>

</table>
