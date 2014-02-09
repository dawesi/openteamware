


<cfinvoke component="#request.a_str_component_workgroups#" method="UpdateWorkgroupRolesForUser" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="workgroupkey" value="#form.frmworkgroupkey#">
	<cfinvokeargument name="rolekeys" value="#form.frmrolekey#">
</cfinvoke>


<cflocation addtoken="no" url="../default.cfm?action=workgroupproperties&entrykey=#form.frmworkgroupkey##writeurltagsfromform()#">