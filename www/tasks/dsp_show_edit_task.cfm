

<!---

	edit a task ...
	
	--->
	
<cfinvoke component="/components/tasks/cmp_task" method="GetTask" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<!---<cfdump var="#stReturn#">--->

<cfif stReturn.rights.write is false>
	<h4>no permissions</h4>
	<cfexit method="exittemplate">
</cfif>

<cfset NewOrEditTask.query = stReturn.q_select_task>
<cfset NewOrEditTask.action = 'edit'>

<form action="act_edit_task.cfm" method="post" name="formeditnewtask" onSubmit="DisplayStatusInformation('<cfoutput>#GetLangVal('tsk_ph_status_saving')#</cfoutput>');">
<input type="hidden" name="frmentrykey" value="<cfoutput>#stReturn.q_select_task.entrykey#</cfoutput>">

<cfset sEntrykey = stReturn.q_select_task.entrykey>
<cfinclude template="dsp_inc_new_edit_task.cfm">
</form>